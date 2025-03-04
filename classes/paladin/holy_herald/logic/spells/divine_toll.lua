---@return boolean
function FS.paladin_holy.logic.spells.divine_toll()
    -- Get target using clustered heal target selection, centered on player
    local target = FS.modules.heal_engine.get_clustered_heal_target(
        FS.paladin_holy.settings.dt_hp_threshold(),
        FS.paladin_holy.settings.dt_min_targets(),
        5, -- Divine Toll affects up to 5 targets total
        30, -- 30 yard range
        FS.paladin_holy.spells.divine_toll,
        false, -- Don't prioritize distance
        true, -- Skip facing
        false, -- Don't skip range
        {
            health = FS.paladin_holy.settings.dt_health_weight(),
            damage = FS.paladin_holy.settings.dt_damage_weight(),
            cluster = FS.paladin_holy.settings.dt_cluster_weight(),
            distance = 0 -- Don't use distance weight for Divine Toll
        },
        FS.variables.me -- Use player as center for cluster calculations
    )

    if not target then
        return false
    end

    -- Queue only Divine Toll cast - additional Holy Shocks are automatic
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.divine_toll, target, 1)
    return true
end
