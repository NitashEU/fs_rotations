function FS.modules.heal_engine.on_fast_update()
    if not FS.modules.heal_engine.is_in_combat then
        return
    end

    local current_time = core.game_time()
    
    -- Maintain caches periodically
    FS.modules.heal_engine.maintain_caches(current_time)
    
    -- Update position cache for all units
    -- This ensures all target selection functions use fresh positions
    FS.modules.heal_engine.position_cache = {}
    FS.modules.heal_engine.position_cache_last_cleared = current_time

    -- Update health values for all units
    for _, unit in pairs(FS.modules.heal_engine.units) do
        -- Ensure circular buffer is initialized
        if not FS.modules.heal_engine.health_values[unit] then
            FS.modules.heal_engine.initialize_circular_buffer(unit)
        end
        
        local buffer = FS.modules.heal_engine.health_values[unit]
        local records = buffer.records
        local last_index = (buffer.next_index - 2) % buffer.capacity + 1
        local last_value = buffer.count > 0 and records[last_index] or nil
        
        local current_health = unit:get_health()
        local current_shield = unit:get_total_shield() or 0
        local total_health = current_health + current_shield

        -- Initialize fight-wide tracking if needed
        if not FS.modules.heal_engine.fight_start_time then
            FS.modules.heal_engine.fight_start_time = current_time
            FS.modules.heal_engine.fight_start_health[unit] = total_health
            FS.modules.heal_engine.fight_total_damage[unit] = 0
        end

        -- Get config values for health tracking
        local significant_change = FS.config:get("heal_engine.history.significant_change", 0.01)
        local record_interval = FS.config:get("heal_engine.history.record_interval", 250)
        
        -- Only store if health changed or enough time passed
        local should_store = not last_value
        if last_value then
            local health_changed = math.abs(last_value.health - total_health) > significant_change
            local time_passed = current_time - last_value.time >= record_interval
            should_store = health_changed or time_passed

            -- Track fight-wide damage
            if health_changed and last_value.health > total_health then
                local damage = last_value.health - total_health
                FS.modules.heal_engine.fight_total_damage[unit] = (FS.modules.heal_engine.fight_total_damage[unit] or 0) +
                    damage

                -- Log fight-wide DPS if enabled and significant damage occurred
                if FS.modules.heal_engine.settings.logging.dps.should_show_fight() and
                    FS.modules.heal_engine.settings.logging.is_debug_enabled() and
                    damage > unit:get_max_health() * FS.modules.heal_engine.settings.logging.dps.get_threshold() then
                    local fight_duration = (current_time - FS.modules.heal_engine.fight_start_time) / 1000
                    local fight_dps = FS.modules.heal_engine.fight_total_damage[unit] / fight_duration
                    core.log(string.format("Fight DPS: %.0f damage over %.1fs = %.0f DPS",
                        FS.modules.heal_engine.fight_total_damage[unit], fight_duration, fight_dps))
                end
            end

            -- Only log significant health changes if enabled
            if FS.modules.heal_engine.settings.logging.is_debug_enabled() and
                health_changed and
                math.abs(last_value.health - total_health) > unit:get_max_health() * FS.modules.heal_engine.settings.logging.health.get_threshold() then
                core.log(string.format("Health change for %s: %.0f -> %.0f (diff: %.0f)",
                    unit:get_name(), last_value.health, total_health,
                    total_health - last_value.health))
            end
        end

        if should_store then
            -- Get a health value object from the pool
            local new_value = FS.modules.heal_engine.get_health_value()
            new_value.health = total_health
            new_value.max_health = unit:get_max_health()
            new_value.health_percentage = current_health / unit:get_max_health()
            new_value.time = current_time

            -- Store in circular buffer
            FS.modules.heal_engine.store_health_value(unit, new_value)
            
            -- Update current health values reference
            FS.modules.heal_engine.current_health_values[unit] = new_value
        end
    end
end

-- Track last DPS update time
FS.modules.heal_engine.last_dps_update = FS.modules.heal_engine.last_dps_update or 0

-- Helper to update DPS values for all units based on enabled tracking windows.
local function update_all_units_dps()
    for _, unit in pairs(FS.modules.heal_engine.units) do
        if FS.modules.heal_engine.settings.tracking.windows.is_1s_enabled() then
            FS.modules.heal_engine.damage_taken_per_second[unit] =
                FS.modules.heal_engine.get_damage_taken_per_second(unit, 1)
        end
        if FS.modules.heal_engine.settings.tracking.windows.is_5s_enabled() then
            FS.modules.heal_engine.damage_taken_per_second_last_5_seconds[unit] =
                FS.modules.heal_engine.get_damage_taken_per_second(unit, 5)
        end
        if FS.modules.heal_engine.settings.tracking.windows.is_10s_enabled() then
            FS.modules.heal_engine.damage_taken_per_second_last_10_seconds[unit] =
                FS.modules.heal_engine.get_damage_taken_per_second(unit, 10)
        end
        if FS.modules.heal_engine.settings.tracking.windows.is_15s_enabled() then
            FS.modules.heal_engine.damage_taken_per_second_last_15_seconds[unit] =
                FS.modules.heal_engine.get_damage_taken_per_second(unit, 15)
        end
    end
end

function FS.modules.heal_engine.on_update()
    local current_time = core.game_time()
    local is_in_combat = FS.variables.me:is_in_combat()

    if is_in_combat and not FS.modules.heal_engine.is_in_combat then
        FS.modules.heal_engine.is_in_combat = true
        FS.modules.heal_engine.start()
        if FS.modules.heal_engine.settings.logging.is_debug_enabled() then
            core.log("Entered combat - starting heal engine")
        end
    elseif not is_in_combat and FS.modules.heal_engine.is_in_combat then
        -- Log final fight DPS before resetting
        if FS.modules.heal_engine.fight_start_time and
            FS.modules.heal_engine.settings.logging.dps.should_show_fight() and
            FS.modules.heal_engine.settings.logging.is_debug_enabled() then
            local fight_duration = (current_time - FS.modules.heal_engine.fight_start_time) / 1000
            for _, unit in pairs(FS.modules.heal_engine.units) do
                local total_damage = FS.modules.heal_engine.fight_total_damage[unit] or 0
                if total_damage > 0 then
                    local fight_dps = total_damage / fight_duration
                    core.log(string.format("Final Fight Stats: %.0f total damage over %.1fs = %.0f average DPS",
                        total_damage, fight_duration, fight_dps))
                end
            end
        end

        FS.modules.heal_engine.is_in_combat = false
        FS.modules.heal_engine.reset()
        if FS.modules.heal_engine.settings.logging.is_debug_enabled() then
            core.log("Left combat - resetting heal engine")
        end
        -- Clear DPS history when leaving combat
        FS.modules.heal_engine.last_dps_values = {}
        FS.modules.heal_engine.last_dps_update = 0
    end

    if FS.modules.heal_engine.is_in_combat then
        -- Only update DPS every 500ms to reduce spam
        if current_time - FS.modules.heal_engine.last_dps_update >= 500 then
            FS.modules.heal_engine.last_dps_update = current_time
            update_all_units_dps()
        end
    end
end
