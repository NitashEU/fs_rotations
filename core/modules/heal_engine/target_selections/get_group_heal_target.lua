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
    -- Parameter validation
    if not hp_threshold or not min_targets or not range or not spell_id then
        return nil
    end

    -- Check if override target is castable
    if override_target and not FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, override_target, skip_facing, skip_range) then
        return nil
    end

    -- Normal target selection
    for _, target in ipairs(FS.modules.heal_engine.units) do
        if ((override_target and override_target:is_valid() and not override_target:is_dead())
                or (target
                    and target:is_valid()
                    and not target:is_ghost()
                    and not target:is_dead()
                    and not FS.variables.debuff_up(1215760, target)
                    and FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, target, skip_facing, skip_range))) then
            local pos_unit = position_unit or override_target or target
            local targets_under_threshold = 0

            for _, unit in ipairs(FS.modules.heal_engine.units) do
                if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1215760, target) then
                    local health_data = FS.modules.heal_engine.current_health_values[unit]
                    if health_data
                        and health_data.health_percentage <= hp_threshold
                        and pos_unit:get_position():dist_to(unit:get_position()) <= range then
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
