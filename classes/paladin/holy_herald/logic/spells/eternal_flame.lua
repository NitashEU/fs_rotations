---@return boolean
function FS.paladin_holy_herald.logic.spells.eternal_flame()
    -- Check if talent is learned
    if not FS.paladin_holy_herald.talents.eternal_flame then
        return false
    end

    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.eternal_flame, FS.variables.me, FS.variables.me, true, true) then
        return false
    end


    -- Get settings
    local hp_threshold = FS.paladin_holy_herald.settings.ef_hp_threshold()
    local tank_hp_threshold = FS.paladin_holy_herald.settings.ef_tank_hp_threshold()
    local critical_hp_threshold = FS.paladin_holy_herald.settings.ef_critical_hp_threshold()

    -- Check if Empyrean Legacy is active for enhanced healing
    local has_empyrean = FS.paladin_holy_herald.variables.empyrean_legacy_up()

    -- Get current active Eternal Flame HoTs
    local current_ef_count = FS.paladin_holy_herald.variables.eternal_flame_count()
    local max_ef_targets = 3 -- Maximum targets to maintain Eternal Flame on

    -- Get optimal target using the heal engine
    local target = FS.modules.heal_engine.get_eternal_flame_target(
        hp_threshold,
        tank_hp_threshold,
        critical_hp_threshold,
        FS.paladin_holy_herald.spells.eternal_flame,
        true,  -- skip_facing
        false, -- skip_range
        current_ef_count,
        max_ef_targets,
        has_empyrean,
        FS.paladin_holy_herald.variables.eternal_flame_up,
        FS.paladin_holy_herald.variables.eternal_flame_remains
    )

    -- If we have a target, cast Eternal Flame
    if target then
        -- Queue spell cast
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.eternal_flame, target, 1)
        return true
    end

    return false
end
