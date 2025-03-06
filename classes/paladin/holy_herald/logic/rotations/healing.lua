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
    if FS.paladin_holy_herald.logic.spells.spend_holy_power() then
        return true
    end

    if FS.paladin_holy_herald.settings.aw_auto_use() and FS.paladin_holy_herald.logic.spells.avenging_wrath() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.beacon_of_virtue() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.holy_shock() then
        return true
    end

    if FS.paladin_holy_herald.variables.divine_favor_up() and FS.paladin_holy_herald.variables.infusion_of_light_up() then
        if FS.paladin_holy_herald.logic.spells.holy_light() then
            return true
        end
    end

    if FS.paladin_holy_herald.logic.spells.holy_prism() then
        return true
    end

    if FS.paladin_holy_herald.variables.infusion_of_light_up() then
        if FS.paladin_holy_herald.logic.spells.flash_of_light() then
            return true
        end
        if FS.paladin_holy_herald.logic.spells.judgment() then
            return true
        end
    end

    if FS.paladin_holy_herald.logic.spells.holy_shock() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.spend_holy_power() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.judgment() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.hammer_of_wrath() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.crusader_strike() then
        return true
    end

    if FS.paladin_holy_herald.logic.spells.flash_of_light() then
        return true
    end

    -- Consecration - low priority filler ability
    if FS.paladin_holy_herald.logic.spells.consecration() then
        return true
    end

    return false
end
