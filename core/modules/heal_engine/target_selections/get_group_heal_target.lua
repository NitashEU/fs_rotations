---Get a target for group healing when enough units are below health threshold within range
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param min_targets number Minimum number of targets required below threshold
---@param range number Range to check for additional targets
---@param spell_id number ID of the healing spell to check castability
---@param override_target? game_object Optional override target to cast the spell on
---@param position_unit? game_object Optional unit to use as position reference for range checks (defaults to override_target or target)
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@return game_object|nil target The target to cast the spell on if conditions are met, or nil if conditions not met
function FS.modules.heal_engine.get_group_heal_target(hp_threshold, min_targets, range, spell_id, override_target,
                                                      position_unit, skip_facing, skip_range)
    local component = "heal_engine.get_group_heal_target"
    
    -- Required parameter validation
    if not hp_threshold then
        FS.error_handler:record(component, "hp_threshold is required")
        return nil
    end
    
    if not min_targets then
        FS.error_handler:record(component, "min_targets is required")
        return nil
    end
    
    if not range then
        FS.error_handler:record(component, "range is required")
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
    
    if type(min_targets) ~= "number" then
        FS.error_handler:record(component, "min_targets must be a number")
        return nil
    end
    
    if type(range) ~= "number" then
        FS.error_handler:record(component, "range must be a number")
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
    
    if min_targets < 1 then
        FS.error_handler:record(component, "min_targets must be at least 1")
        return nil
    end
    
    if range <= 0 then
        FS.error_handler:record(component, "range must be greater than 0")
        return nil
    end
    
    -- Optional parameter validation
    if override_target ~= nil then
        -- Verify override_target is a valid game object
        if not override_target.get_position then
            FS.error_handler:record(component, "override_target must be a valid game object with get_position method")
            return nil
        end
    end
    
    if position_unit ~= nil then
        -- Verify position_unit is a valid game object
        if not position_unit.get_position then
            FS.error_handler:record(component, "position_unit must be a valid game object with get_position method")
            return nil
        end
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

    -- Check if override target is castable
    if override_target and not FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, override_target, skip_facing, skip_range) then
        return nil
    end

    -- Normal target selection
    for _, target in ipairs(FS.modules.heal_engine.units) do
        if (override_target or FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, target, skip_facing, skip_range)) then
            local pos_unit = position_unit or override_target or target
            local targets_under_threshold = 0

            for _, unit in ipairs(FS.modules.heal_engine.units) do
                local health_data = FS.modules.heal_engine.current_health_values[unit]
                if health_data and health_data.health_percentage <= hp_threshold then
                    local distance = FS.modules.heal_engine.get_cached_distance(
                        FS.modules.heal_engine.get_cached_position(pos_unit),
                        FS.modules.heal_engine.get_cached_position(unit)
                    )
                    if distance <= range then
                        targets_under_threshold = targets_under_threshold + 1
                    end
                end
            end

            if targets_under_threshold >= min_targets then
                return override_target or target
            end
        end
    end

    return nil
end
