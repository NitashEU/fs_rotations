--- Attempts to cast Avenging Crusader when conditions are met
--- Requires:
--- - Valid enemy target
--- - Group healing requirements met (HP threshold and minimum targets in range)
--- - Spell is castable on player
---@return boolean Returns true if spell was queued, false otherwise
function FS.paladin_holy_herald.logic.spells.avenging_wrath()
    if not FS.variables.me:is_in_combat() then
        return false
    end
    local group_target = FS.modules.heal_engine.get_group_heal_target(
        FS.paladin_holy_herald.settings.aw_hp_threshold(), -- HP threshold for healing
        FS.paladin_holy_herald.settings.aw_min_targets(),  -- Minimum targets required
        30,                                                -- Range check in yards
        FS.paladin_holy_herald.spells.avenging_wrath,      -- Spell ID
        FS.variables.me,                                   -- Source unit
        FS.variables.me,                                   -- Target unit
        true,                                              -- Check facing
        false                                              -- Check line of sight
    )

    if not group_target then
        return false
    end

    FS.api.spell_queue:queue_spell_target_fast(FS.paladin_holy_herald.spells.avenging_wrath, FS.variables.me, 1)
    FS.paladin_holy_herald.logic.spells.beacon_of_virtue(true)
    return true
end
