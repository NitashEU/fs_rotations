---@return boolean
function FS.paladin_holy.logic.spells.holy_light()
    -- Get settings and state
    local hp_threshold = FS.paladin_holy.settings.hl_hp_threshold()
    local has_infusion = FS.variables.buff_up(FS.paladin_holy.auras.infusion_of_light)
    
    -- Use higher threshold with Infusion of Light
    if has_infusion then
        hp_threshold = FS.paladin_holy.settings.hl_infusion_hp_threshold()
    end

    -- Get single target for sustained healing
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy.spells.holy_light,
        true,  -- skip_facing
        false  -- skip_range
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.holy_light, target, 1)
    return true
end