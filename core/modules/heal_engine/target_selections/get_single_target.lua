---Get a single healing target based on health threshold and spell castability
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param spell_id number ID of the healing spell to check castability
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@return game_object|nil target The target with maximum missing health that meets the criteria, or nil if no valid target found
function FS.modules.heal_engine.get_single_target(hp_threshold, spell_id, skip_facing, skip_range)
    local component = "heal_engine.get_single_target"
    local max_missing_health = 0
    local best_target = nil

    -- Required parameter validation
    if not hp_threshold then
        FS.error_handler:record(component, "hp_threshold is required")
        return nil
    end
    
    if not spell_id then
        FS.error_handler:record(component, "spell_id is required")
        return nil
    end
    
    -- Type validation
    if type(hp_threshold) ~= "number" then
        FS.error_handler:record(component, "hp_threshold must be a number")
        return nil
    end
    
    if type(spell_id) ~= "number" then
        FS.error_handler:record(component, "spell_id must be a number")
        return nil
    end
    
    -- Value range validation
    if hp_threshold < 0 or hp_threshold > 100 then
        FS.error_handler:record(component, "hp_threshold must be between 0-100")
        return nil
    end
    
    -- Boolean parameter validation with default values
    skip_facing = skip_facing == nil and false or skip_facing
    skip_range = skip_range == nil and false or skip_range
    
    if type(skip_facing) ~= "boolean" then
        FS.error_handler:record(component, "skip_facing must be a boolean")
        return nil
    end
    
    if type(skip_range) ~= "boolean" then
        FS.error_handler:record(component, "skip_range must be a boolean")
        return nil
    end

    -- Iterate through all units
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        -- Get current health values for the unit
        local health_data = FS.modules.heal_engine.current_health_values[unit]

        -- Check if we have valid health data and unit is below threshold
        if health_data and health_data.health_percentage <= hp_threshold then
            -- Calculate missing health
            local missing_health = health_data.max_health - health_data.health

            -- Check if this unit has more missing health and spell is castable on them
            if missing_health > max_missing_health and FS.api.spell_helper:is_spell_castable(spell_id, FS.variables.me, unit, skip_facing, skips_range) then
                max_missing_health = missing_health
                best_target = unit
            end
        end
    end

    return best_target
end