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

    -- If save_holy_prism is enabled, check if we're close to Awakening or have Avenging Wrath
    if FS.paladin_holy_herald.settings.hp_save_for_aw() then
        -- Check if Avenging Wrath is active - if active, we should use Holy Prism
        if FS.paladin_holy_herald.variables.avenging_wrath_up() then
            local enemy = FS.variables.enemy_target()
            -- Queue spell cast
            if enemy and FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.holy_prism, FS.variables.me, enemy, false, false) then
                FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_prism, enemy, 1)
                return true -- Holy Prism queued successfully
            end
        else
            -- Check if close to Awakening proc (dynamically use awakening_near_max)
            if
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
    local hp_threshold = FS.paladin_holy_herald.settings.hp_hp_threshold()
    local min_targets = FS.paladin_holy_herald.settings.hp_min_targets()

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

    return true
end
