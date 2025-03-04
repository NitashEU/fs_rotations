---Get a healer target that has taken the most damage in the last 15 seconds
---@param spell_id number ID of the spell to check castability
---@param skip_facing boolean Whether to skip facing requirement check
---@param skips_range boolean Whether to skip range requirement check
---@param skip_me boolean Whether to skip the player character as a potential target
---@return game_object|nil target The healer with highest damage taken that meets the criteria, or nil if no valid target found
function FS.modules.heal_engine.get_healer_damage_target(spell_id, skip_facing, skips_range, skip_me)
    local max_damage = 0
    local best_target = nil

    -- Validate parameters
    if not spell_id then
        return nil
    end

    -- Iterate through healers
    for _, unit in ipairs(FS.modules.heal_engine.healers) do
        -- Skip player character if skip_me is true
        if not (skip_me and unit == FS.variables.me) then
            -- Get damage taken in last 15 seconds
            local damage = FS.modules.heal_engine.damage_taken_per_second_last_15_seconds[unit] or 0

            -- Check if this unit has taken more damage and spell is castable on them
            if damage > max_damage and FS.api.spell_helper:is_spell_castable(spell_id, FS.variables.me, unit, skip_facing, skips_range) then
                max_damage = damage
                best_target = unit
            end
        end
    end

    return best_target
end
