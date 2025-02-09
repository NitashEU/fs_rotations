function FS.modules.heal_engine.on_update()
    local is_in_combat = FS.variables.me:is_in_combat()
    if is_in_combat and not FS.modules.heal_engine.is_in_combat then
        FS.modules.heal_engine.is_in_combat = true
        FS.modules.heal_engine.start()
    elseif not is_in_combat and FS.modules.heal_engine.is_in_combat then
        FS.modules.heal_engine.is_in_combat = false
        FS.modules.heal_engine.reset()
    end
    if FS.modules.heal_engine.is_in_combat then
        for _, unit in pairs(FS.modules.heal_engine.units) do
            FS.modules.heal_engine.damage_taken_per_second[unit] = FS.modules.heal_engine.get_damage_taken_per_second(
                unit, 1)
            FS.modules.heal_engine.damage_taken_per_second_last_5_seconds[unit] = FS.modules.heal_engine
                .get_damage_taken_per_second(unit, 5)
            FS.modules.heal_engine.damage_taken_per_second_last_10_seconds[unit] = FS.modules.heal_engine
                .get_damage_taken_per_second(unit, 10)
            FS.modules.heal_engine.damage_taken_per_second_last_15_seconds[unit] = FS.modules.heal_engine
                .get_damage_taken_per_second(unit, 15)
        end
    end
end

function FS.modules.heal_engine.on_fast_update()
    if not FS.modules.heal_engine.is_in_combat then
        return
    end
    -- Remove older than 15 seconds
    for _, unit in pairs(FS.modules.heal_engine.units) do
        local stored_values = FS.modules.heal_engine.health_values[unit] or {}
        local valid_values = {}
        for _, value in ipairs(stored_values) do
            if core.game_time() - value.time < 15000 then
                table.insert(valid_values, value)
            end
        end
        FS.modules.heal_engine.health_values[unit] = valid_values
    end

    for _, unit in pairs(FS.modules.heal_engine.units) do
        local stored_values = FS.modules.heal_engine.health_values[unit] or {}
        local last_value = #stored_values > 0 and stored_values[#stored_values] or nil
        local new_value = {
            health = unit:get_health() + unit:get_total_shield(),
            max_health = unit:get_max_health(),
            health_percentage = (unit:get_health() + unit:get_total_shield()) / unit:get_max_health(),
            time = core.game_time()
        }
        if not last_value or last_value.health ~= new_value.health then
            table.insert(stored_values, new_value)
            FS.modules.heal_engine.current_health_values[unit] = new_value
        end
        FS.modules.heal_engine.health_values[unit] = stored_values
    end
end
