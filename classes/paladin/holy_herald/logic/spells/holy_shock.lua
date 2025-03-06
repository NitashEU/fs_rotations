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
    local has_rising_sun = FS.paladin_holy_herald.variables.rising_sunlight_up()

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
        FS.paladin_holy_herald.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if tank_target and FS.modules.heal_engine.current_health_values[tank_target].health_percentage <= hp_threshold * 0.9 then
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_shock, tank_target, 1)
        return true
    end

    -- Then try regular healing target
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy_herald.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if not target then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_shock, target, 1)
    return true
end
