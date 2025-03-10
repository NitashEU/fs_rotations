---@return boolean
function FS.paladin_holy_herald.logic.rotations.avenging_wrath()
    -- This function handles Avenging Wrath windows with Herald of the Sun
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return false
    end
    local enemy = FS.variables.enemy_target()
    -- Queue spell cast
    if enemy and FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.holy_prism, FS.variables.me, enemy, false, false) then
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_prism, enemy, 1)
        return true -- Holy Prism queued successfully
    end
    if FS.paladin_holy_herald.logic.spells.holy_prism() then
        return true
    end
    if FS.paladin_holy_herald.logic.spells.divine_toll() then
        return true
    end
    return false
end
