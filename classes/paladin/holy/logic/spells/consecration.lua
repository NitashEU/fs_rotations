---@return boolean
function FS.paladin_holy.logic.spells.consecration()
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Get target position for consecration placement
    local target_pos = target:get_position()
    if not target_pos or target_pos:dist_to(FS.variables.me:get_position()) > 8 then
        return false
    end

    -- Check if spell is castable at position
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.consecration, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Queue consecration at target's position
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.consecration, FS.variables.me, 1)
    return true
end
