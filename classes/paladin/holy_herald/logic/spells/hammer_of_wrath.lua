---@return boolean
function FS.paladin_holy.logic.spells.hammer_of_wrath()
    -- Get valid target
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Check spell can be cast
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.hammer_of_wrath, FS.variables.me, target, false, false) then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.hammer_of_wrath, target, 1)
    return true
end
