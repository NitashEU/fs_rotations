---@return boolean
function FS.paladin_holy.logic.spells.holy_shock()
    -- Get valid target
    local target = FS.modules.heal_engine.get_single_target(FS.paladin_holy.settings.hs_hp_threshold(),
        FS.paladin_holy.spells.holy_shock, true, true)

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.holy_shock, target, 1)
    return true
end
