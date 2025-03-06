---@return boolean
function FS.paladin_holy_herald.logic.spells.holy_light()
    if true then return false end
    -- Get settings and state
    local hp_threshold = FS.paladin_holy_herald.settings.hl_hp_threshold()

    -- Get single target for sustained healing
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy_herald.spells.holy_light,
        true, -- skip_facing
        false -- skip_range
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_light, target, 1, nil)
    --FS.api.movement_handler:pause_movement(0.2, 0)
    return true
end
