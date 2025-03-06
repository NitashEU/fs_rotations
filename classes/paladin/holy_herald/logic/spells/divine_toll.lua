---@return boolean
function FS.paladin_holy_herald.logic.spells.divine_toll()
    -- Check if talent is learned
    if not FS.paladin_holy_herald.talents.divine_toll then
        return false
    end

    -- Early exit if Divine Toll is on cooldown
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.divine_toll, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Check if close to Awakening proc (dynamically use awakening_near_max)
    if
        FS.paladin_holy_herald.talents.awakening and
        FS.paladin_holy_herald.variables.awakening_near_max() then
        return false -- Save Holy Prism for Awakening
    end

    -- Check cooldown of Avenging Wrath
    local aw_cd = core.spell_book.get_spell_cooldown(FS.paladin_holy_herald.spells.avenging_wrath)
    if aw_cd and aw_cd <= 45 then
        return false -- Save Holy Prism for imminent Avenging Wrath
    end

    -- Get settings
    local hp_threshold = FS.paladin_holy_herald.settings.dt_hp_threshold()
    local min_targets = FS.paladin_holy_herald.settings.dt_min_targets()

    if FS.paladin_holy_herald.settings.dt_force_on_aw() then
        hp_threshold = FS.paladin_holy_herald.variables.avenging_wrath_up() and 1 or hp_threshold
        min_targets = FS.paladin_holy_herald.variables.avenging_wrath_up() and 1 or min_targets
    end

    -- Get weights for target selection
    local weights = {
        health = FS.paladin_holy_herald.settings.dt_health_weight(),
        damage = FS.paladin_holy_herald.settings.dt_damage_weight(),
        cluster = FS.paladin_holy_herald.settings.dt_cluster_weight(),
        distance = 0 -- Divine Toll doesn't use distance weighting
    }

    -- Get optimal target using clustered heal target selection
    local target = FS.modules.heal_engine.get_clustered_heal_target(
        hp_threshold,
        min_targets,
        5,       -- Divine Toll affects up to 5 targets
        40,      -- Range in yards
        FS.paladin_holy_herald.spells.divine_toll,
        false,   -- Don't prioritize distance
        true,    -- Skip facing
        false,   -- Don't skip range
        weights, -- Use configured weights
        FS.variables.me
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.divine_toll, target, 1) -- Priority 0 for major cooldown
    return true
end
