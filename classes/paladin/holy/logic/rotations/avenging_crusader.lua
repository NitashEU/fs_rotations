---@return boolean
function FS.paladin_holy.logic.rotations.avenging_crusader()
    if not FS.paladin_holy.variables.avenging_crusader_up() then
        return false
    end
    if FS.paladin_holy.logic.spells.ac_judgment() then
        return true
    end
    if FS.paladin_holy.logic.spells.ac_crusader_strike() then
        return true
    end
    if FS.paladin_holy.logic.spells.spend_holy_power(false) then
        return true
    end
    if (not FS.paladin_holy.variables.blessed_assurance_up()) and FS.paladin_holy.logic.spells.crusader_strike() then
        return true
    end
    if FS.paladin_holy.logic.spells.holy_shock() then
        return true
    end
    return false
end
