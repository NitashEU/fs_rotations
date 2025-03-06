---@return boolean
function FS.paladin_holy_herald.logic.spells.consecration()
    if not FS.variables.me:is_in_combat() then
        return false
    end
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Check if player is in melee range
    local player_pos = FS.variables.me:get_position()
    local target_pos = target:get_position()

    if not player_pos or not target_pos then
        return false
    end

    local distance = player_pos:dist_to(target_pos)
    if distance > 8 then
        return false
    end

    -- Check if spell is castable
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.consecration, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Queue consecration at player's position
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.consecration, FS.variables.me, 1)
    return true
end
