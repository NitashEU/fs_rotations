---@return boolean
function FS.paladin_holy_herald.logic.spells.word_of_glory()
    -- Get settings
    local hp_threshold = FS.paladin_holy_herald.settings.wog_hp_threshold()
    local tank_hp_threshold = FS.paladin_holy_herald.settings.wog_tank_hp_threshold()
    local critical_hp_threshold = FS.paladin_holy_herald.settings.wog_critical_hp_threshold()
    
    -- Check if Holy Power should be saved for Eternal Flame based on the setting
    if FS.paladin_holy_herald.settings.use_eternal_flame() and
       FS.paladin_holy_herald.talents.eternal_flame and
       FS.paladin_holy_herald.variables.empyrean_legacy_up() then
        -- Check for critically low health targets first
        local critical_target = FS.modules.heal_engine.get_single_target(
            critical_hp_threshold,
            FS.paladin_holy_herald.spells.word_of_glory,
            true,
            false
        )
        
        -- If no critical target, prefer Eternal Flame
        if not critical_target then
            return false
        end
    end

    -- First try tank healing if they're low
    local tank_target = FS.modules.heal_engine.get_tank_damage_target(
        FS.paladin_holy_herald.spells.word_of_glory,
        true, -- skip_facing
        false -- skip_range
    )

    if tank_target then
        local tank_hp = FS.api.unit_helper:get_health_percentage(tank_target)
        if tank_hp <= tank_hp_threshold then
            -- Higher priority for very low health targets
            local priority = tank_hp < tank_hp_threshold * 0.7 and 0 or 1
            
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.word_of_glory, tank_target, priority)
            return true
        end
    end

    -- Check for critical healing needs
    local critical_target = FS.modules.heal_engine.get_single_target(
        critical_hp_threshold,
        FS.paladin_holy_herald.spells.word_of_glory,
        true,
        false
    )
    
    if critical_target then
        -- Highest priority for critical healing
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.word_of_glory, critical_target, 0)
        return true
    end

    -- Otherwise use standard single target selection
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.paladin_holy_herald.spells.word_of_glory,
        true, -- skip_facing
        false -- skip_range
    )

    if not target then
        return false
    end

    -- Standard priority for normal healing
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.word_of_glory, target, 1)
    return true
end
