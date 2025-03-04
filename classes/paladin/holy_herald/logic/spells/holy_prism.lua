---@return boolean
function FS.paladin_holy_herald.logic.spells.holy_prism()
    -- Check if talent is learned
    if not FS.paladin_holy_herald.talents.holy_prism then
        return false
    end

    -- Early exit if Holy Prism is on cooldown
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.holy_prism, FS.variables.me, FS.variables.me, true, true) then
        return false
    end
    
    -- Check for auto-use setting - if disabled, don't auto-cast
    if not FS.paladin_holy_herald.settings.hp_auto_use() then
        return false
    end
    
    -- Rising Sunlight buff tracking - Prioritize using Holy Prism with Rising Sunlight
    local rising_sunlight_active = FS.paladin_holy_herald.variables.rising_sunlight_up()
    local rising_sunlight_hp_threshold = rising_sunlight_active and 0.85 or FS.paladin_holy_herald.settings.hp_hp_threshold()
    
    -- If save_holy_prism is enabled, check if we're close to Awakening or have Avenging Wrath
    if FS.paladin_holy_herald.settings.save_holy_prism() then
        -- Check if Avenging Wrath is active - if active, we should use Holy Prism
        if FS.paladin_holy_herald.variables.avenging_wrath_up() then
            -- Continue with Holy Prism cast
        else
            -- Check if close to Awakening proc (dynamically use awakening_near_max)
            if FS.paladin_holy_herald.settings.hp_save_for_awakening() and 
               FS.paladin_holy_herald.talents.awakening and 
               FS.paladin_holy_herald.variables.awakening_near_max() then
                return false -- Save Holy Prism for Awakening
            end
            
            -- Check cooldown of Avenging Wrath
            local aw_cd = core.spell_book.get_spell_cooldown(FS.paladin_holy_herald.spells.avenging_wrath)
            if aw_cd and aw_cd <= 5 then
                return false -- Save Holy Prism for imminent Avenging Wrath
            end
        end
    end

    -- Get settings - use Rising Sunlight modified threshold if active
    local hp_threshold = rising_sunlight_active and rising_sunlight_hp_threshold or FS.paladin_holy_herald.settings.hp_hp_threshold()
    local min_targets = FS.paladin_holy_herald.settings.hp_min_targets()
    
    -- If we have Dawnlight application priority enabled, reduce minimum targets
    local prioritize_dawnlight = FS.paladin_holy_herald.settings.hp_prioritize_dawnlight()
    if prioritize_dawnlight and FS.paladin_holy_herald.variables.post_holy_prism_state() then
        min_targets = math.max(1, min_targets - 1) -- Reduce minimum targets but ensure at least 1
    end

    -- Get optimal enemy target using heal engine
    local target = FS.modules.heal_engine.get_enemy_clustered_heal_target(
        hp_threshold,                            -- hp_threshold
        min_targets,                             -- min_targets
        5,                                       -- max_targets (Holy Prism affects up to 5 targets)
        30,                                      -- range (fixed at 30 yards)
        FS.paladin_holy_herald.spells.holy_prism -- spell_id
    )

    if not target then
        return false
    end

    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_prism, target, 1)
    
    -- Reset Holy Prism tracking for Dawnlight application
    FS.paladin_holy_herald.variables.reset_holy_prism_tracking()
    
    -- Update the target selection object to track last successful target
    FS.paladin_holy_herald.variables.last_holy_prism_target = target
    
    return true
end
