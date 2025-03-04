---@return boolean
function FS.paladin_holy_herald.logic.spells.holy_shock()
    -- Early exit if not castable
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.holy_shock, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Get current charges and settings
    local charges = FS.paladin_holy_herald.variables.holy_shock_charges()
    local base_hp_threshold = FS.paladin_holy_herald.settings.hs_hp_threshold()
    local last_charge_threshold = FS.paladin_holy_herald.settings.hs_last_charge_hp_threshold()
    local rising_sun_threshold = FS.paladin_holy_herald.settings.hs_rising_sun_hp_threshold()
    
    -- Track buff states
    local has_rising_sun = FS.paladin_holy_herald.variables.rising_sunlight_up()
    local has_gleaming_rays = FS.paladin_holy_herald.variables.gleaming_rays_up()
    local solar_grace_stacks = FS.paladin_holy_herald.variables.solar_grace_stacks() or 0
    
    -- Holy Power overcap risk check during Rising Sunlight
    local is_overcap_risk = has_rising_sun and FS.paladin_holy_herald.variables.is_holy_power_overcap_risk()

    -- Calculate effective threshold based on state
    local hp_threshold = base_hp_threshold
    local priority = 1 -- Default priority
    
    -- Adjust healing threshold and priority based on buffs
    if has_rising_sun then
        hp_threshold = rising_sun_threshold -- More aggressive with Rising Sunlight
        
        if is_overcap_risk then
            -- When at risk of overcapping Holy Power, be even more aggressive
            hp_threshold = hp_threshold * 1.15 -- Further increase threshold
            priority = 0 -- Highest priority to prevent overcapping
        end
    elseif charges <= 1 then
        hp_threshold = last_charge_threshold -- More conservative with last charge
    elseif charges >= 1.8 then
        -- More aggressive usage when close to max charges
        hp_threshold = hp_threshold * 1.1
    end
    
    -- Adjust threshold based on Solar Grace (increased haste means more Holy Shocks available)
    if solar_grace_stacks > 0 then
        local haste_bonus = FS.paladin_holy_herald.variables.get_solar_grace_haste_bonus()
        -- Be more aggressive with high haste (up to 10% more aggressive at max stacks)
        hp_threshold = hp_threshold * (1 + (haste_bonus * 2))
    end
    
    -- Track if we should prefer critical healing due to Gleaming Rays
    local prefer_critical = has_gleaming_rays
    
    -- Try tanks first with a stricter threshold
    local tank_target = FS.modules.heal_engine.get_tank_damage_target(
        FS.paladin_holy_herald.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if tank_target and FS.modules.heal_engine.current_health_values[tank_target].health_percentage <= hp_threshold * 0.9 then
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_shock, tank_target, priority)
        return true
    end

    -- Target selection parameters based on buff states
    local target_selection_threshold = hp_threshold
    
    -- When Gleaming Rays is active (increased crit), prioritize lower health targets
    if prefer_critical then
        target_selection_threshold = target_selection_threshold * 0.9 -- Lower threshold to find more critical targets
    end
    
    -- Get regular healing target
    local target = FS.modules.heal_engine.get_single_target(
        target_selection_threshold,
        FS.paladin_holy_herald.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if not target then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_shock, target, priority)
    return true
end
