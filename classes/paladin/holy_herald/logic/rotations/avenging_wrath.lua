---@return boolean
function FS.paladin_holy_herald.logic.rotations.avenging_wrath()
    -- This function handles Avenging Wrath windows with Herald of the Sun
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return false
    end
    if FS.paladin_holy_herald.logic.spells.holy_prism() then
        return true
    end
    if FS.paladin_holy_herald.logic.spells.divine_toll() then
        return true
    end
    return false
end
