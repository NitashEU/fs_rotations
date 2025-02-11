---@return boolean
function FS.paladin_holy.logic.spells.word_of_glory()
    -- Get settings
    local hp_threshold = FS.paladin_holy.settings.wog_hp_threshold()
    local tank_hp_threshold = FS.paladin_holy.settings.wog_tank_hp_threshold()

    -- First try tank healing if they're low
    local tank_target = FS.modules.heal_engine.get_tank_damage_target(
        FS.paladin_holy.spells.word_of_glory,
        true, -- skip_facing
        false -- skip_range
    )

    if tank_target and FS.api.unit_helper:get_health_percentage(tank_target) <= tank_hp_threshold then
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.word_of_glory, tank_target, 1)
        return true
    end

    -- Otherwise use standard single target selection
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy.spells.word_of_glory,
        true, -- skip_facing
        false -- skip_range
    )

    if not target then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.word_of_glory, target, 1)
    return true
end
