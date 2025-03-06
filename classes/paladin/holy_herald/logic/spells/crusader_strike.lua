---@return boolean
function FS.paladin_holy_herald.logic.spells.crusader_strike()
    if not FS.variables.me:is_in_combat() then
        return false
    end
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.crusader_strike, FS.variables.me, target, false, false) then
        return false
    end
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.crusader_strike, target, 1)
    return true
end
