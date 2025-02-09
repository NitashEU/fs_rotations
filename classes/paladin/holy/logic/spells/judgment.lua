---@return boolean
function FS.paladin_holy.logic.spells.judgment()
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Don't cast if awakening_max buff is active with more than 4 seconds remaining
    if FS.paladin_holy.variables.awakening_max_remains() > 4000 then
        return false
    end

    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.judgment, FS.variables.me, target, false, false) then
        return false
    end
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.judgment, target, 1)
    return true
end

---@return boolean
function FS.paladin_holy.logic.spells.ac_judgment()
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.judgment, FS.variables.me, target, false, false) then
        return false
    end
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.judgment, target, 1)
    return true
end
