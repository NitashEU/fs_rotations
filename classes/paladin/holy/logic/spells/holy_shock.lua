---@return boolean
function FS.paladin_holy.logic.spells.holy_shock()
    -- Get settings
    local base_hp_threshold = FS.paladin_holy.settings.hs_hp_threshold()
    local last_charge_threshold = FS.paladin_holy.settings.hs_last_charge_hp_threshold()
    local rising_sun_threshold = FS.paladin_holy.settings.hs_rising_sun_hp_threshold()

    -- Check charges and buffs using variables
    local charges = FS.paladin_holy.variables.holy_shock_charges()
    local is_last_charge = charges <= 1
    local has_rising_sun = FS.paladin_holy.variables.rising_sunlight_up()

    -- Determine which threshold to use
    local hp_threshold = base_hp_threshold
    if has_rising_sun then
        hp_threshold = rising_sun_threshold
    elseif is_last_charge then
        hp_threshold = last_charge_threshold
    end

    -- Use heal engine's single target selection
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,    -- hp_threshold
        FS.paladin_holy.spells.holy_shock, -- spell_id
        true,          -- skip_facing
        false          -- skip_range
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.holy_shock, target, 1)
    return true
end
