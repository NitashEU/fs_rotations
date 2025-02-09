--- Predicts the future health and health percentage of a unit after a given delay.
---@param unit game_object
---@param prediction_delay_seconds number
---@return number predictedHealth, number predictedPercentage
function FS.modules.heal_engine.get_predicted_health(unit, prediction_delay_seconds)
    local current = FS.modules.heal_engine.current_health_values[unit]
    if not current then
        return 0, 0
    end

    -- Calculate base rates using a recent 3-second window.
    local damage_per_sec = FS.modules.heal_engine.get_damage_taken_per_second(unit, 3)
    local healing_per_sec = FS.modules.heal_engine.get_healing_received_per_second(unit, 3)
    local net_change_per_sec = healing_per_sec - damage_per_sec

    local predictedHealth = current.health + (net_change_per_sec * prediction_delay_seconds)
    if predictedHealth > current.max_health then
        predictedHealth = current.max_health
    elseif predictedHealth < 0 then
        predictedHealth = 0
    end

    local predictedPercentage = predictedHealth / current.max_health
    return predictedHealth, predictedPercentage
end

return FS.modules.heal_engine.get_predicted_health 