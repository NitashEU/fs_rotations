---Get a single healing target based on health threshold and spell castability
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param spell_id number ID of the healing spell to check castability
---@param skip_facing boolean Whether to skip facing requirement check
---@param skips_range boolean Whether to skip range requirement check
---@return game_object|nil target The target with maximum missing health that meets the criteria, or nil if no valid target found
function FS.modules.heal_engine.get_single_target(hp_threshold, spell_id, skip_facing, skips_range)
    local max_missing_health = 0
    local best_target = nil

    -- Validate parameters
    if not hp_threshold or not spell_id then
        return nil
    end

    -- Iterate through all units
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1220769, unit) then
            -- Get current health values for the unit
            local health_data = FS.modules.heal_engine.current_health_values[unit]

            -- Check if we have valid health data and unit is below threshold
            if health_data and health_data.health_percentage <= hp_threshold then
                -- Calculate missing health
                local missing_health = health_data.max_health - health_data.health

                -- Check if this unit has more missing health and spell is castable on them
                if missing_health > max_missing_health and FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, unit, skip_facing, skips_range) then
                    max_missing_health = missing_health
                    best_target = unit
                end
            end
        end
    end

    return best_target
end
