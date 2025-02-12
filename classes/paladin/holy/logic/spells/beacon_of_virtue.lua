--- Beacon of Virtue logic
--- Attempts to cast Beacon of Virtue when conditions are met
--- Requires:
--- - Talent is learned
--- - Group healing requirements met (HP threshold and minimum targets in range)
--- - Spell is castable on player
---@param ignore_threshold boolean? If true, ignores HP threshold check
---@return boolean
function FS.paladin_holy.logic.spells.beacon_of_virtue(ignore_threshold)
    -- Check if talent is learned
    if not FS.paladin_holy.talents.beacon_of_virtue then
        return false
    end

    -- Get settings
    local hp_threshold = ignore_threshold and 1 or FS.paladin_holy.settings.bov_hp_threshold()
    local min_targets = FS.paladin_holy.settings.bov_min_targets()
    local use_distance = FS.paladin_holy.settings.bov_use_distance()

    -- Create weights table
    local weights = {
        health = FS.paladin_holy.settings.bov_health_weight(),
        damage = FS.paladin_holy.settings.bov_damage_weight(),
        cluster = FS.paladin_holy.settings.bov_cluster_weight(),
        distance = use_distance and FS.paladin_holy.settings.bov_distance_weight() or 0
    }

    -- Use clustered heal target selector
    local target = FS.modules.heal_engine.get_clustered_heal_target(
        hp_threshold,                            -- hp_threshold
        min_targets,                             -- min_targets
        5,                                       -- max_targets (Beacon of Virtue affects up to 4 targets)
        30,                                      -- range (fixed at 30 yards)
        FS.paladin_holy.spells.beacon_of_virtue, -- spell_id
        use_distance,                            -- prioritize_distance
        true,                                    -- skip_facing
        false,                                   -- skip_range
        weights                                  -- weights
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.beacon_of_virtue, target, 1)
    return true
end
