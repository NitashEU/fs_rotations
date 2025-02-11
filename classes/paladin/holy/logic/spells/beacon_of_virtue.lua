---@return boolean
function FS.paladin_holy.logic.spells.beacon_of_virtue()
    -- Check if talent is learned
    if not FS.paladin_holy.talents.beacon_of_virtue then
        return false
    end

    -- Get settings
    local hp_threshold = FS.paladin_holy.settings.bov_hp_threshold()
    local min_targets = FS.paladin_holy.settings.bov_min_targets()
    local prioritize_distance = FS.paladin_holy.settings.bov_prioritize_distance()

    -- Use clustered heal target selector
    local target = FS.modules.heal_engine.get_clustered_heal_target(
        hp_threshold,                            -- hp_threshold
        min_targets,                             -- min_targets
        5,                                       -- max_targets (Beacon of Virtue affects up to 4 targets)
        30,                                      -- range (fixed at 30 yards)
        FS.paladin_holy.spells.beacon_of_virtue, -- spell_id
        prioritize_distance,                     -- prioritize_distance
        true,                                    -- skip_facing
        false                                    -- skip_range
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.beacon_of_virtue, target, 1)
    return true
end
