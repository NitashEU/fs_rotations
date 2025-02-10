--- Attempts to cast Avenging Crusader when conditions are met
--- Requires:
--- - Valid enemy target
--- - Group healing requirements met (HP threshold and minimum targets in range)
--- - Spell is castable on player
---@return boolean Returns true if spell was queued, false otherwise
function FS.paladin_holy.logic.spells.avenging_crusader()
    local enemy_target = FS.variables.enemy_target()
    if not enemy_target then
        return false
    end

    local group_target = FS.modules.heal_engine.get_group_heal_target(
        FS.paladin_holy.settings.ac_hp_threshold(), -- HP threshold for healing
        FS.paladin_holy.settings.ac_min_targets(),  -- Minimum targets required
        20,                                         -- Range check in yards
        FS.paladin_holy.spells.avenging_crusader,   -- Spell ID
        FS.variables.me,                            -- Source unit
        enemy_target,                               -- Target unit
        true,                                       -- Check facing
        true                                        -- Check line of sight
    )

    if not group_target then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.avenging_crusader, FS.variables.me, 1)
    return true
end
