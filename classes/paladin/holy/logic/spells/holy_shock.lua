---@return boolean
function FS.paladin_holy.logic.spells.holy_shock()
    local component = "paladin_holy.spells.holy_shock"

    -- Early exit if not castable
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.holy_shock, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Get current charges and settings
    local charges = FS.paladin_holy.variables.holy_shock_charges()
    local base_hp_threshold = FS.paladin_holy.settings.hs_hp_threshold()
    local last_charge_threshold = FS.paladin_holy.settings.hs_last_charge_hp_threshold()
    local rising_sun_threshold = FS.paladin_holy.settings.hs_rising_sun_hp_threshold()
    local has_rising_sun = FS.paladin_holy.variables.rising_sunlight_up()

    -- Validate settings
    if not FS.validator.check_percent(base_hp_threshold, "base_hp_threshold", component) then
        return false
    end

    if not FS.validator.check_percent(last_charge_threshold, "last_charge_threshold", component) then
        return false
    end

    if not FS.validator.check_percent(rising_sun_threshold, "rising_sun_threshold", component) then
        return false
    end

    if not FS.validator.check_number(charges, "charges", 0, nil, component) then
        return false
    end

    if not FS.validator.check_boolean(has_rising_sun, "has_rising_sun", false, component) then
        return false
    end

    -- Calculate effective threshold based on state
    local hp_threshold = base_hp_threshold
    if has_rising_sun then
        hp_threshold = rising_sun_threshold
    elseif charges <= 1 then
        hp_threshold = last_charge_threshold -- More conservative with last charge
    elseif charges >= 1.8 then
        -- More aggressive usage when close to max charges
        hp_threshold = hp_threshold * 1.1
    end

    -- Try tanks first with a stricter threshold
    local tank_target = FS.modules.heal_engine.get_tank_damage_target(
        FS.paladin_holy.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if tank_target and FS.modules.heal_engine.current_health_values[tank_target] then
        -- Validate tank target has health data
        if not FS.validator.check_table(FS.modules.heal_engine.current_health_values[tank_target],
                "health_data for tank_target", component) then
            return false
        end

        local tank_health_pct = FS.modules.heal_engine.current_health_values[tank_target].health_percentage
        if tank_health_pct <= hp_threshold * 0.9 then
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.holy_shock, tank_target, 1)
            return true
        end
    end

    -- Then try regular healing target
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if not target then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.holy_shock, target, 1)
    return true
end
