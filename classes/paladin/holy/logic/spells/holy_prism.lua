---@return boolean
function FS.paladin_holy.logic.spells.holy_prism()
    -- Check if talent is learned
    if not FS.paladin_holy.talents.holy_prism then
        return false
    end

    -- Get settings
    local hp_threshold = FS.paladin_holy.settings.hp_hp_threshold()
    local min_targets = FS.paladin_holy.settings.hp_min_targets()

    -- Get optimal enemy target using heal engine
    local target = FS.modules.heal_engine.get_enemy_clustered_heal_target(
        hp_threshold,                     -- hp_threshold
        min_targets,                      -- min_targets
        5,                                -- max_targets (Holy Prism affects up to 5 targets)
        30,                               -- range (fixed at 30 yards)
        FS.paladin_holy.spells.holy_prism -- spell_id
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.holy_prism, target, 1)
    return true
end
