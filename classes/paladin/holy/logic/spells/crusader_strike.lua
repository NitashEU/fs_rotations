---@return boolean
function FS.paladin_holy.logic.spells.crusader_strike()
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.crusader_strike, FS.variables.me, target, false, false) then
        return false
    end
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.crusader_strike, target, 1)
    return true
end

---@return boolean
function FS.paladin_holy.logic.spells.ac_crusader_strike()
    if not FS.paladin_holy.variables.blessed_assurance_up() then
        return false
    end
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.crusader_strike, FS.variables.me, target, false, false) then
        return false
    end
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.crusader_strike, target, 1)
    return true
end
