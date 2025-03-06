---@return boolean
function FS.paladin_holy_herald.logic.spells.hammer_of_wrath()
    if not FS.variables.me:is_in_combat() then
        return false
    end
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end

    -- Check if target is below 20% health or we have Avenging Wrath active
    --local can_use = (target:get_health() / target:get_max_health()) <= 0.2 or
    --FS.paladin_holy_herald.variables.avenging_wrath_up()
    --
    --if not can_use then
    --    return false
    --end

    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.hammer_of_wrath, FS.variables.me, target, false, false) then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.hammer_of_wrath, target, 1)
    return true
end
