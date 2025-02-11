---@return boolean
function FS.paladin_holy.logic.rotations.healing()
    if FS.paladin_holy.logic.spells.avenging_crusader() then
        return true
    end
    if FS.paladin_holy.logic.spells.divine_toll() then
        return true
    end
    if FS.paladin_holy.logic.spells.beacon_of_virtue() then
        return true
    end
    if FS.paladin_holy.logic.spells.holy_prism() then
        return true
    end
    if FS.paladin_holy.logic.spells.holy_arnament() then
        return true
    end
    if FS.paladin_holy.logic.spells.holy_shock() then
        return true
    end
    if FS.paladin_holy.logic.spells.judgment() then
        return true
    end
    if FS.paladin_holy.logic.spells.crusader_strike() then
        return true
    end
    if FS.paladin_holy.logic.spells.hammer_of_wrath() then
        return true
    end
    return false
end
