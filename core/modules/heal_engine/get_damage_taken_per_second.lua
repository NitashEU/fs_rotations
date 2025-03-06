---@param unit game_object
---@param last_x_seconds number
---@return number
function FS.modules.heal_engine.get_damage_taken_per_second(unit, last_x_seconds)
    local total_damage = 0
    local start_time = core.game_time() - last_x_seconds * 1000
    local values = FS.modules.heal_engine.health_values[unit] or {}
    local valid_values = {}

    for _, value in ipairs(values) do
        if value.time >= start_time then
            table.insert(valid_values, value)
        end
    end

    for i = 2, #valid_values do
        local current_health = valid_values[i].health
        local previous_health = valid_values[i - 1].health
        local missing_health = previous_health - current_health
        if missing_health > 0 then
            total_damage = total_damage + missing_health
        end
    end

    if #valid_values > 1 then
        local time_diff = valid_values[#valid_values].time - valid_values[1].time
        return total_damage / (time_diff / 1000)
    elseif #valid_values == 1 then
        return total_damage
    else
        return 0
    end
end
