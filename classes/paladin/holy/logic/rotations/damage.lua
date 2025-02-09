---@return boolean
function FS.paladin_holy.logic.rotations.damage()
    -- Follow priority system
    -- 1. Judgment
    if FS.paladin_holy.logic.spells.judgment() then
        return true
    end

    -- 2. Crusader Strike
    if FS.paladin_holy.logic.spells.crusader_strike() then
        return true
    end

    -- 3. Hammer of Wrath
    if FS.paladin_holy.logic.spells.hammer_of_wrath() then
        return true
    end

    return false
end
