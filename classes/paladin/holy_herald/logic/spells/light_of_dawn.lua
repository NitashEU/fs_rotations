---@return boolean
function FS.paladin_holy_herald.logic.spells.light_of_dawn()
    -- Early exit if not castable
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.light_of_dawn, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Get settings
    local hp_threshold = 0.95 --FS.paladin_holy_herald.settings.lod_hp_threshold()
    local min_targets = 2     --FS.paladin_holy_herald.settings.lod_min_targets()

    -- Get target using frontal cone heal target selection
    --local target = FS.modules.heal_engine.get_frontal_cone_heal_target(
    --    hp_threshold,
    --    min_targets,
    --    15, -- Cone angle in degrees
    --    25, -- Range in yards
    --    FS.paladin_holy_herald.spells.light_of_dawn
    --)

    --if not target then
    --    return false
    --end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.light_of_dawn, FS.variables.me, 1)
    return true
end
