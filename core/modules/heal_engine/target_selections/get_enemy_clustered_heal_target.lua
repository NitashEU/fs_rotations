---Get allied healing coverage from current enemy target position
---@param hp_threshold number Maximum health percentage to consider allies for healing (0-100)
---@param min_targets number Minimum number of allies required below threshold
---@param max_targets number Maximum number of targets that can be affected
---@param range number Range to check for additional targets
---@param spell_id number ID of the healing spell to check castability
---@param custom_weight? table Optional table with custom weights for sorting
---@return game_object|nil target The current enemy target if conditions are met, nil otherwise
function FS.modules.heal_engine.get_enemy_clustered_heal_target(hp_threshold, min_targets, max_targets, range, spell_id,
                                                                custom_weight)
    local component = "heal_engine.get_enemy_clustered_heal_target"
    
    -- Required parameter validation
    if not hp_threshold then
        FS.error_handler:record(component, "hp_threshold is required")
        return nil
    end
    
    if not min_targets then
        FS.error_handler:record(component, "min_targets is required")
        return nil
    end
    
    if not max_targets then
        FS.error_handler:record(component, "max_targets is required")
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
    
    if type(max_targets) ~= "number" then
        FS.error_handler:record(component, "max_targets must be a number")
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
    
    if max_targets < min_targets then
        FS.error_handler:record(component, "max_targets must be greater than or equal to min_targets")
        return nil
    end
    
    if range <= 0 then
        FS.error_handler:record(component, "range must be greater than 0")
        return nil
    end
    
    -- Optional parameter validation
    if custom_weight ~= nil and type(custom_weight) ~= "table" then
        FS.error_handler:record(component, "custom_weight must be a table")
        return nil
    end

    local target = FS.variables.enemy_target()

    if not target then
        return nil
    end

    -- Check if we have a valid enemy target
    if not FS.variables.target or not FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, target, false, false) then
        return nil
    end

    ---@class NearbyAlly
    ---@field unit game_object
    ---@field health_pct number

    -- Collect and sort nearby allies by health percentage
    ---@type NearbyAlly[]
    local nearby_allies = {}

    for _, unit in ipairs(FS.modules.heal_engine.units) do
        local health_data = FS.modules.heal_engine.current_health_values[unit]
        if health_data and health_data.health_percentage <= hp_threshold then
            local distance = FS.modules.heal_engine.get_cached_distance(
                FS.modules.heal_engine.get_cached_position(target),
                FS.modules.heal_engine.get_cached_position(unit)
            )
            if distance <= range then
                table.insert(nearby_allies, {
                    unit = unit,
                    health_pct = health_data.health_percentage,
                })
            end
        end
    end

    -- Sort by health percentage and custom weight if provided
    table.sort(nearby_allies, function(a, b)
        return a.health_pct < b.health_pct
    end)

    -- Check if we have enough targets
    local count = math.min(#nearby_allies, max_targets)
    if count < min_targets then
        return nil
    end

    return target
end
