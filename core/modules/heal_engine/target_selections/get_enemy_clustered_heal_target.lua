---Get allied healing coverage from current enemy target position
---@param hp_threshold number Maximum health percentage to consider allies for healing (0-100)
---@param min_targets number Minimum number of allies required below threshold
---@param max_targets number Maximum number of targets that can be affected
---@param range number Range to check for additional targets
---@param spell_id number ID of the healing spell to check castability
---@return game_object|nil target The current enemy target if conditions are met, nil otherwise
function FS.modules.heal_engine.get_enemy_clustered_heal_target(hp_threshold, min_targets, max_targets, range, spell_id,
                                                                custom_weight)
    -- Parameter validation
    if not hp_threshold or not min_targets or not max_targets or not range or not spell_id then
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
        if target and target:is_valid() and not target:is_ghost() and not target:is_dead() and not FS.variables.debuff_up(1220769, target) and health_data
            and health_data.health_percentage <= hp_threshold
            and target:get_position():dist_to(unit:get_position()) <= range then
            table.insert(nearby_allies, {
                unit = unit,
                health_pct = health_data.health_percentage,
            })
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
