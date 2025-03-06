---@return boolean Returns true if spell was queued, false otherwise
function FS.paladin_holy_herald.logic.spells.blessing_of_the_seasons()
    if not FS.variables.me:is_in_combat() then
        return false
    end

    if FS.api.spell_helper:is_spell_on_cooldown(FS.paladin_holy_herald.spells.blessing_of_the_seasons) then
        return false
    end

    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.blessing_of_the_seasons, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.blessing_of_the_seasons, FS.variables.me, 1)

    return true
end
