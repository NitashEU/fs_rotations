function FS.modules.heal_engine.on_fast_update()
    if not FS.modules.heal_engine.is_in_combat then
        return
    end

    local current_time = core.game_time()

    -- Update health values for all units
    for _, unit in pairs(FS.modules.heal_engine.units) do
        if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1215760, unit) then
            local stored_values = FS.modules.heal_engine.health_values[unit] or {}
            local last_value = #stored_values > 0 and stored_values[#stored_values] or nil
            local current_health = unit:get_health()
            local current_shield = unit:get_total_shield() or 0
            local total_health = current_health + current_shield

            local valid_values = {}
            local removed_count = 0
            for _, value in ipairs(stored_values) do
                if current_time - value.time < 15000 then
                    table.insert(valid_values, value)
                else
                    removed_count = removed_count + 1
                end
            end

            stored_values = valid_values

            -- Initialize fight-wide tracking if needed
            if not FS.modules.heal_engine.fight_start_time then
                FS.modules.heal_engine.fight_start_time = current_time
                FS.modules.heal_engine.fight_start_health[unit] = total_health
                FS.modules.heal_engine.fight_total_damage[unit] = 0
            end

            -- Only store if health changed or enough time passed (250ms)
            local should_store = not last_value
            if last_value then
                local health_changed = math.abs(last_value.health - total_health) > 0.01
                local time_passed = current_time - last_value.time >= 250
                should_store = health_changed or time_passed

                -- Track fight-wide damage
                if health_changed and last_value.health > total_health then
                    local damage = last_value.health - total_health
                    FS.modules.heal_engine.fight_total_damage[unit] = (FS.modules.heal_engine.fight_total_damage[unit] or 0) +
                        damage
                end
            end

            if should_store then
                local new_value = {
                    health = total_health,
                    max_health = unit:get_max_health(),
                    health_percentage = current_health / unit:get_max_health(),
                    time = current_time
                }

                table.insert(stored_values, new_value)
                FS.modules.heal_engine.current_health_values[unit] = new_value
            end

            FS.modules.heal_engine.health_values[unit] = stored_values
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
    elseif not is_in_combat and FS.modules.heal_engine.is_in_combat then
        -- Log final fight DPS before resetting
        if FS.modules.heal_engine.fight_start_time and
            FS.modules.heal_engine.settings.logging.dps.should_show_fight() then
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
