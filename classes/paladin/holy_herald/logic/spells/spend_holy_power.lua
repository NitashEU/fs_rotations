---@return boolean
function FS.paladin_holy_herald.logic.spells.spend_holy_power(requireBA)
    --local currentHP = FS.paladin_holy_herald.variables.holy_power()
    --
    ---- Check for overcapping risk
    --local overcap_risk = FS.paladin_holy_herald.variables.is_holy_power_near_cap()
    --local incoming_hp = overcap_risk and FS.paladin_holy_herald.variables.estimate_upcoming_holy_power(3) or 0
    --local imminent_overcap = (currentHP + incoming_hp) > FS.paladin_holy_herald.variables.max_holy_power
    --
    ---- Get critical health threshold for emergency spending
    --local critical_hp_threshold = FS.paladin_holy_herald.settings.ef_critical_hp_threshold()
    --
    ---- Determine if we should spend based on current state
    --local should_spend = false
    --
    ---- Check spending conditions
    --if requireBA then
    --    -- Normal rotation conditions
    --
    --    -- Forced spending conditions (overcap prevention)
    --    if overcap_risk or imminent_overcap then
    --        should_spend = true
    --        -- Standard spending at 4+ HP
    --    elseif currentHP >= 4 then
    --        should_spend = true
    --        -- Conditional spending at 3 HP based on critical healing needs
    --    elseif currentHP == 3 then
    --        -- Only spend if critical healing is needed
    --        should_spend = FS.paladin_holy_herald.variables.should_spend_at_low_hp(critical_hp_threshold, currentHP)
    --    end
    --
    --    -- Exit if we shouldn't spend
    --    if not should_spend then
    --        return false
    --    end
    --else
    --    -- AC rotation: spend unless Blessed Assurance is up
    --    if FS.paladin_holy_herald.variables.blessed_assurance_up() and
    --        not (overcap_risk or imminent_overcap) then
    --        return false
    --    end
    --end
    --
    ---- Helper function to track Holy Power spender usage for tracking systems
    --local function track_hp_spender()
    --    -- Increment Holy Power spender count if we're in post-Holy Prism state
    --    if FS.paladin_holy_herald.variables.post_holy_prism_state() then
    --        FS.paladin_holy_herald.variables.increment_holy_power_spender_count()
    --    end
    --
    --    -- Other tracking systems could be added here if needed
    --end
    --
    ---- PRIORITY 2: Empyrean Legacy with Eternal Flame
    --if FS.paladin_holy_herald.variables.empyrean_legacy_up() and
    --    FS.paladin_holy_herald.talents.eternal_flame then
    --    if FS.paladin_holy_herald.logic.spells.eternal_flame() then
    --        track_hp_spender()
    --        return true
    --    end
    --end
    --
    ---- PRIORITY 3: Critical single-target healing with Eternal Flame
    --local critical_target = FS.modules.heal_engine.get_single_target(
    --    critical_hp_threshold,
    --    FS.paladin_holy_herald.spells.eternal_flame,
    --    true,
    --    false
    --)
    --
    --if critical_target then
    --    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.eternal_flame, critical_target, 1) -- Priority 0 for critical healing
    --    track_hp_spender()
    --    return true
    --end
    --
    ---- PRIORITY 4: Multi-target evaluation
    ---- Count how many targets would benefit from LoD versus Eternal Flame
    --
    --local lod_min_targets = FS.paladin_holy_herald.settings.lod_min_targets()
    --
    ---- Don't bother with expensive counting if we're overcapping - just spend
    --if not (overcap_risk or imminent_overcap) then
    --    -- Get efficiency metrics for both spenders
    --    local lod_target = FS.modules.heal_engine.get_frontal_cone_heal_target(
    --        FS.paladin_holy_herald.settings.lod_hp_threshold(),
    --        lod_min_targets,
    --        15,
    --        46,
    --        FS.paladin_holy_herald.spells.light_of_dawn
    --    )
    --
    --    -- Count targets who would be hit by Light of Dawn
    --    local lod_hit_count = 0
    --    if lod_target then
    --        for _, unit in ipairs(FS.modules.heal_engine.units) do
    --            if FS.api.unit_helper:get_health_percentage(unit) <= FS.paladin_holy_herald.settings.lod_hp_threshold() and
    --                FS.api.unit_helper:is_in_frontal_cone(FS.variables.me, unit, 46, 15) then
    --                lod_hit_count = lod_hit_count + 1
    --            end
    --        end
    --    end
    --
    --    -- Get information about current Eternal Flame HoTs
    --    local ef_count = 0
    --    local ef_targets_need_refresh = 0
    --
    --    -- Only check if talent is learned
    --    if FS.paladin_holy_herald.talents.eternal_flame then
    --        ef_count = FS.paladin_holy_herald.variables.eternal_flame_count()
    --
    --        -- Check for HoTs that need refreshing (< 3 seconds remaining)
    --        local ef_targets = FS.paladin_holy_herald.variables.eternal_flame_targets_with_details()
    --        for _, target_info in ipairs(ef_targets) do
    --            if target_info.remains < 3 and target_info.health_percent < 90 then
    --                ef_targets_need_refresh = ef_targets_need_refresh + 1
    --            end
    --        end
    --    end
    --
    --    -- Evaluate healing priorities based on situation
    --    local use_lod = false
    --    local use_ef = false
    --
    --    -- Calculate healing efficiency scores
    --    local lod_efficiency = lod_hit_count * 0.8 -- Each target hit is worth 0.8 points
    --    local ef_efficiency = 0
    --
    --    -- Prioritize Eternal Flame in these cases:
    --    -- 1. We have less than 3 HoTs active and someone needs healing
    --    -- 2. We have Empyrean Legacy proc
    --    -- 3. We have HoTs that need refreshing
    --    if FS.paladin_holy_herald.talents.eternal_flame then
    --        -- Base efficiency: count existing HoTs and ones needing refresh
    --        ef_efficiency = (3 - ef_count) * 1.2 -- Each missing HoT is worth 1.2 points
    --        ef_efficiency = ef_efficiency +
    --            (ef_targets_need_refresh * 0.8)  -- Each HoT needing refresh is worth 0.8 points
    --
    --        -- Bonus for Empyrean Legacy
    --        if FS.paladin_holy_herald.variables.empyrean_legacy_up() then
    --            ef_efficiency = ef_efficiency + 2.5 -- Significant bonus for Empyrean Legacy
    --        end
    --    end
    --
    --    -- If overcap is approaching, prioritize spending over optimal usage
    --    if currentHP >= 4 then
    --        -- Just use whatever is more efficient
    --        use_lod = lod_efficiency >= ef_efficiency and lod_hit_count >= lod_min_targets
    --        use_ef = ef_efficiency > lod_efficiency
    --    else
    --        -- Require higher efficiency thresholds when not at risk of overcapping
    --        use_lod = lod_efficiency >= (ef_efficiency + 0.5) and lod_hit_count >= lod_min_targets
    --        use_ef = ef_efficiency > (lod_efficiency + 0.5)
    --    end
    --
    --    -- Apply healing based on calculated priorities
    --    if use_lod then
    --        if FS.paladin_holy_herald.logic.spells.light_of_dawn() then
    --            track_hp_spender()
    --            return true
    --        end
    --    elseif use_ef then
    --        if FS.paladin_holy_herald.logic.spells.eternal_flame() then
    --            track_hp_spender()
    --            return true
    --        end
    --    else
    --        -- Try both if neither was clearly preferred
    --        -- First Light of Dawn if it would hit enough targets
    --        if lod_hit_count >= lod_min_targets then
    --            if FS.paladin_holy_herald.logic.spells.light_of_dawn() then
    --                track_hp_spender()
    --                return true
    --            end
    --        end
    --
    --        -- Then Eternal Flame
    --        if FS.paladin_holy_herald.talents.eternal_flame then
    --            if FS.paladin_holy_herald.logic.spells.eternal_flame() then
    --                track_hp_spender()
    --                return true
    --            end
    --        end
    --    end
    --else
    --    -- When overcapping, try all options without the detailed evaluation
    --
    --    -- If we have Empyrean Legacy, prioritize Eternal Flame
    --    if FS.paladin_holy_herald.variables.empyrean_legacy_up() and
    --        FS.paladin_holy_herald.talents.eternal_flame then
    --        if FS.paladin_holy_herald.logic.spells.eternal_flame() then
    --            track_hp_spender()
    --            return true
    --        end
    --    end
    --
    --    -- Otherwise try Light of Dawn first for AoE healing when near cap
    --    if FS.paladin_holy_herald.logic.spells.light_of_dawn() then
    --        track_hp_spender()
    --        return true
    --    end
    --
    --    -- Then Eternal Flame
    --    if FS.paladin_holy_herald.talents.eternal_flame then
    --        if FS.paladin_holy_herald.logic.spells.eternal_flame() then
    --            track_hp_spender()
    --            return true
    --        end
    --    end
    --end

    local ef_count = 0
    local ef_targets_need_refresh = 0

    -- Only check if talent is learned
    if FS.paladin_holy_herald.talents.eternal_flame then
        ef_count = FS.paladin_holy_herald.variables.eternal_flame_count()

        -- Check for HoTs that need refreshing (< 3 seconds remaining)
        local ef_targets = FS.paladin_holy_herald.variables.eternal_flame_targets_with_details()
        for _, target_info in ipairs(ef_targets) do
            if target_info.remains < 3 and target_info.health_percent < 90 then
                ef_targets_need_refresh = ef_targets_need_refresh + 1
            end
        end
    end

    if FS.paladin_holy_herald.logic.spells.eternal_flame() then
        -- PRIORITY 5: Regular single-target Eternal Flame as fallback
        return true
    elseif FS.paladin_holy_herald.logic.spells.light_of_dawn() then
        return true
    end

    if not FS.variables.me:is_in_combat() then
        return false
    end

    -- PRIORITY 6: Shield of the Righteous if nothing else to spend on and in melee range
    local enemy_target = FS.variables.enemy_target()
    if enemy_target and FS.paladin_holy_herald.variables.holy_power() >= 5 then
        local target_pos = enemy_target:get_position()
        local self_pos = FS.variables.me:get_position()

        if target_pos and self_pos and target_pos:dist_to(self_pos) <= 8 and
            FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.shield_of_the_righteous, FS.variables.me, FS.variables.me, true, true) then
            -- Lowest priority for SotR unless we're going to overcap

            FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.shield_of_the_righteous, FS.variables.me,
                1)
            --track_hp_spender()
            return true
        end
    end

    return false
end
