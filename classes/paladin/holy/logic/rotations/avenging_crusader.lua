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
    return true
end
