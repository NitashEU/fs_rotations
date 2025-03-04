-------------------------------------------------------------------------------------------------------------------
-- Herald of the Sun: Main Healing Rotation
--
-- This is the primary healing rotation for the Herald of the Sun specialization.
-- It defines the priority system for all spells and abilities, with special focus on:
-- 1. Dawnlight application after Holy Prism
-- 2. Beam optimization during Avenging Wrath
-- 3. Cooldown management and usage
-- 4. Holy Power generation and spending
--
-- The rotation follows a specific priority system that adapts to different situations:
-- - Prioritizes Dawnlight application after Holy Prism
-- - Manages cooldowns according to settings and combat state
-- - Optimizes Holy Power spending based on healing needs
-- - Generates Holy Power through Holy Shock and other abilities
-- - Provides supplemental healing through filler spells
-------------------------------------------------------------------------------------------------------------------
---@return boolean True if a spell was cast, false if no action was taken
function FS.paladin_holy_herald.logic.rotations.healing()
    -- PRIORITY 1: Dawnlight Application
    -- This must be first to ensure we apply Dawnlight HoTs when needed
    -- during the limited window after Holy Prism
    if FS.paladin_holy_herald.logic.spells.apply_dawnlight() then
        return true
    end
    
    -- PRIORITY 2: Beam Optimization
    -- During Avenging Wrath, optimize player position for maximum beam intersections
    -- This is only active when the optimize_beams setting is enabled
    if FS.paladin_holy_herald.settings.optimize_beams() and 
       FS.paladin_holy_herald.logic.spells.optimize_dawnlight_beams() then
        return true
    end
    
    -- PRIORITY 3: Major Cooldowns
    -- Avenging Crusader - powerful DPS-to-healing conversion cooldown
    if FS.paladin_holy_herald.logic.spells.avenging_crusader() then
        return true
    end
    
    -- Divine Toll - instant Holy Shock on multiple targets
    if FS.paladin_holy_herald.logic.spells.divine_toll() then
        return true
    end
    
    -- Beacon of Virtue - multi-target beacon for group healing
    if FS.paladin_holy_herald.logic.spells.beacon_of_virtue() then
        return true
    end
    
    -- PRIORITY 4: Holy Prism
    -- Holy Prism is a key spell that enables Dawnlight application via Holy Power spenders
    if FS.paladin_holy_herald.logic.spells.holy_prism() then
        -- The reset function for tracking is already called inside the holy_prism implementation
        return true
    end
    
    -- PRIORITY 5: Holy Power Spending
    -- Use Eternal Flame, Light of Dawn, or Word of Glory based on situation and settings
    -- This is our primary healing output and Dawnlight application method
    if FS.paladin_holy_herald.logic.spells.spend_holy_power(true) then
        return true
    end
    
    -- PRIORITY 6: Holy Power Generation and Supplemental Healing
    
    -- Judgment - provides Holy Power via Judgment of Light talent
    if FS.paladin_holy_herald.logic.spells.judgment() then
        return true
    end
    
    -- Holy Shock - primary Holy Power generator and healing spell
    if FS.paladin_holy_herald.logic.spells.holy_shock() then
        return true
    end
    
    -- Crusader Strike - Holy Power generator
    if FS.paladin_holy_herald.logic.spells.crusader_strike() then
        return true
    end
    
    -- Hammer of Wrath - additional Holy Power generator when available
    if FS.paladin_holy_herald.logic.spells.hammer_of_wrath() then
        return true
    end
    
    -- Consecration - low priority filler ability
    if FS.paladin_holy_herald.logic.spells.consecration() then
        return true
    end
    
    -- No valid action to take this cycle
    return false
end
