---@return boolean
function FS.paladin_holy.logic.spells.flash_of_light()
    -- Get settings and state
    local hp_threshold = FS.paladin_holy.settings.fol_hp_threshold()
    local has_infusion = FS.variables.buff_up(FS.paladin_holy.auras.infusion_of_light)
    
    -- Use higher threshold with Infusion of Light
    if has_infusion then
        hp_threshold = FS.paladin_holy.settings.fol_infusion_hp_threshold()
    end

    -- Try tank healing first for emergency situations
    local tank_target = FS.modules.heal_engine.get_tank_damage_target(
        FS.paladin_holy.spells.flash_of_light,
        true,  -- skip_facing
        false  -- don't skip range
    )

    if tank_target and FS.modules.heal_engine.current_health_values[tank_target].health_percentage <= hp_threshold * 0.9 then
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.flash_of_light, tank_target, 1)
        return true
    end

    -- Then try raid healing on most injured target
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy.spells.flash_of_light,
        true,  -- skip_facing
        false  -- don't skip range
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.flash_of_light, target, 1)
    return true
end