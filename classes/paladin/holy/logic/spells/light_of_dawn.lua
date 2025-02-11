---@return boolean
function FS.paladin_holy.logic.spells.light_of_dawn()
    -- Get settings
    local hp_threshold = FS.paladin_holy.settings.lod_hp_threshold()
    local min_targets = FS.paladin_holy.settings.lod_min_targets()

    -- Use frontal cone heal target selector
    local target = FS.modules.heal_engine.get_frontal_cone_heal_target(
        hp_threshold,                        -- hp_threshold
        min_targets,                         -- min_targets
        15,                                  -- radius (cone length)
        46,                                  -- angle (in degrees)
        FS.paladin_holy.spells.light_of_dawn -- spell_id
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.light_of_dawn, target, 1)
    return true
end
