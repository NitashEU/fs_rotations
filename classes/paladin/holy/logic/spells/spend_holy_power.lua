---@return boolean
function FS.paladin_holy.logic.spells.spend_holy_power(requireBA)
    local currentHP = FS.paladin_holy.variables.holy_power()
    
    -- Check spending conditions
    if requireBA then
        -- Normal rotation conditions
        -- Spend at 4+ HP, or at 3+ if critical healing needed
        if currentHP < 3 then
            return false
        end
        
        -- Check for critical healing needs at 3 HP
        if currentHP == 3 then
            local critical_target = FS.modules.heal_engine.get_single_target(
                FS.paladin_holy.settings.wog_critical_hp_threshold(),
                FS.paladin_holy.spells.word_of_glory,
                true,
                false
            )
            if not critical_target then
                return false
            end
        end
    else
        -- AC rotation: spend unless Blessed Assurance is up
        if FS.paladin_holy.variables.blessed_assurance_up() then
            return false
        end
    end

    -- Use spells in priority order
    -- Word of Glory for critical healing or tank healing
    if FS.paladin_holy.logic.spells.word_of_glory() then
        return true
    end
    
    -- Light of Dawn for efficient group healing
    if FS.paladin_holy.logic.spells.light_of_dawn() then
        return true
    end

    -- Shield of the Righteous if nothing else to spend on and in melee
    local target = FS.variables.enemy_target()
    if target then
        local target_pos = target:get_position()
        if target_pos and target_pos:dist_to(FS.variables.me:get_position()) <= 8 and
           FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.shield_of_the_righteous, FS.variables.me, FS.variables.me, true, true) then
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.shield_of_the_righteous, FS.variables.me, 1)
            return true
        end
    end
    return false
end
