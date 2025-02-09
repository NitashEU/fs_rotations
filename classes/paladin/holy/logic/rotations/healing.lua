---@return boolean
function FS.paladin_holy.logic.rotations.healing()
    -- Healing rotation implementation will be added here
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
