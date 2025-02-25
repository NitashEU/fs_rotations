---Get a healer target that has taken the most damage in the last 15 seconds
---@param spell_id number ID of the spell to check castability
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@param skip_me boolean Whether to skip the player character as a potential target
---@return game_object|nil target The healer with highest damage taken that meets the criteria, or nil if no valid target found
function FS.modules.heal_engine.get_healer_damage_target(spell_id, skip_facing, skip_range, skip_me)
    local component = "heal_engine.get_healer_damage_target"
    local max_damage = 0
    local best_target = nil

    -- Required parameter validation
    if not spell_id then
        FS.error_handler:record(component, "spell_id is required")
        return nil
    end
    
    -- Type validation
    if type(spell_id) ~= "number" then
        FS.error_handler:record(component, "spell_id must be a number")
        return nil
    end
    
    -- Boolean parameter validation with default values
    skip_facing = skip_facing == nil and false or skip_facing
    skip_range = skip_range == nil and false or skip_range
    skip_me = skip_me == nil and false or skip_me
    
    if type(skip_facing) ~= "boolean" then
        FS.error_handler:record(component, "skip_facing must be a boolean")
        return nil
    end
    
    if type(skip_range) ~= "boolean" then
        FS.error_handler:record(component, "skip_range must be a boolean")
        return nil
    end
    
    if type(skip_me) ~= "boolean" then
        FS.error_handler:record(component, "skip_me must be a boolean")
        return nil
    end
    
    -- Validate healers array exists and isn't empty
    if not FS.modules.heal_engine.healers or #FS.modules.heal_engine.healers == 0 then
        FS.error_handler:record(component, "No healers available for targeting")
        return nil
    end

    -- Iterate through healers
    for _, unit in ipairs(FS.modules.heal_engine.healers) do
        -- Skip player character if skip_me is true
        if not (skip_me and unit == FS.variables.me) then
            -- Get damage taken in last 15 seconds
            local damage = FS.modules.heal_engine.damage_taken_per_second_last_15_seconds[unit] or 0

            -- Check if this unit has taken more damage and spell is castable on them
            if damage > max_damage and FS.api.spell_helper:is_spell_castable(spell_id, FS.variables.me, unit, skip_facing, skip_range) then
                max_damage = damage
                best_target = unit
            end
        end
    end

    return best_target
end
