---@return boolean
function FS.paladin_holy_herald.logic.rotations.avenging_wrath()
    -- This function handles Avenging Wrath windows with Herald of the Sun
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return false
    end
    
    -- Optimize positioning for Sun's Avatar beams
    if FS.paladin_holy_herald.settings.optimize_beams() and 
       FS.paladin_holy_herald.logic.spells.optimize_dawnlight_beams() then
        return true
    end
    
    -- Prioritize applying Dawnlight to allies without it if we recently used Holy Prism
    if FS.paladin_holy_herald.variables.post_holy_prism_state() and 
       FS.paladin_holy_herald.logic.spells.apply_dawnlight() then
        return true
    end
    
    -- Pass control to the standard healing rotation
    return false
end
