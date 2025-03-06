---@return boolean
function FS.paladin_holy_herald.logic.spells.judgment()
    if not FS.variables.me:is_in_combat() then
        return false
    end
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Give highest priority to Judgment when Awakening max buff is active (proc ready)
    if FS.paladin_holy_herald.variables.awakening_max_remains() > 0 then
        if FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.judgment, FS.variables.me, target, false, false) then
            -- Use highest priority (0) for Judgment when Awakening max is active
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.judgment, target, 1)
            return true
        end
        return false -- If Judgment isn't available, don't allow other actions to take priority
    end

    -- Normal priority for Judgment
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.judgment, FS.variables.me, target, false, false) then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.judgment, target, 1)
    return true
end

---@return boolean
function FS.paladin_holy_herald.logic.spells.ac_judgment()
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Give highest priority to Judgment when Awakening max buff is active (proc ready)
    if FS.paladin_holy_herald.variables.awakening_max_remains() > 0 then
        if FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.judgment, FS.variables.me, target, false, false) then
            -- Use highest priority (0) for Judgment when Awakening max is active
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.judgment, target, 1)
            return true
        end
        return false -- If Judgment isn't available, don't allow other actions to take priority
    end

    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.judgment, FS.variables.me, target, false, false) then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.judgment, target, 1)
    return true
end
