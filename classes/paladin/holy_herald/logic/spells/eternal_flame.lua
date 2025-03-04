---@return boolean
function FS.paladin_holy_herald.logic.spells.eternal_flame()
    -- Check if talent is learned
    if not FS.paladin_holy_herald.talents.eternal_flame then
        return false
    end
    
    -- Check Holy Power
    local currentHP = FS.paladin_holy_herald.variables.get_holy_power_as_number()
    if currentHP < 1 then
        return false
    end
    
    -- Get settings
    local hp_threshold = FS.paladin_holy_herald.settings.wog_hp_threshold()
    local tank_hp_threshold = FS.paladin_holy_herald.settings.wog_tank_hp_threshold()
    local critical_hp_threshold = FS.paladin_holy_herald.settings.wog_critical_hp_threshold()
    
    -- Check if Empyrean Legacy is active for enhanced healing
    local has_empyrean = FS.paladin_holy_herald.variables.empyrean_legacy_up()
    
    -- Get current active Eternal Flame HoTs
    local current_ef_count = FS.paladin_holy_herald.variables.eternal_flame_count()
    
    -- Target selection variables
    local target = nil
    local target_score = 0
    local max_ef_targets = 3 -- Maximum targets to maintain Eternal Flame on
    
    -- Determine if we're in an emergency situation
    local emergency_situation = false
    local critical_target = FS.modules.heal_engine.get_single_target(
        critical_hp_threshold,
        FS.paladin_holy_herald.spells.eternal_flame,
        true,
        false
    )
    
    if critical_target then
        local critical_hp = FS.api.unit_helper:get_health_percentage(critical_target)
        if critical_hp < critical_hp_threshold * 0.8 then
            emergency_situation = true
            target = critical_target
            target_score = 1000 -- Very high score to prioritize emergency healing
        end
    end
    
    -- If not an emergency, proceed with normal target selection
    if not emergency_situation then
        -- First try tank healing if they're low
        local tank_target = FS.modules.heal_engine.get_tank_damage_target(
            FS.paladin_holy_herald.spells.eternal_flame,
            true, -- skip_facing
            false -- skip_range
        )
        
        if tank_target then
            local tank_hp = FS.api.unit_helper:get_health_percentage(tank_target)
            
            -- If tank is below threshold
            if tank_hp <= tank_hp_threshold then
                target = tank_target
                target_score = (1 - tank_hp) * 100 -- Higher score for lower health
                
                -- Check if tank already has HoT
                if FS.paladin_holy_herald.variables.eternal_flame_up(tank_target) then
                    local remains = FS.paladin_holy_herald.variables.eternal_flame_remains(tank_target) / 1000
                    
                    -- Reduce score if HoT already present, unless very low health or HoT is about to expire
                    if tank_hp > tank_hp_threshold * 0.7 and remains > 3 then
                        target_score = target_score * 0.7
                    elseif remains < 3 then
                        -- Bonus for refreshing nearly expired HoT on tank
                        target_score = target_score * 1.1
                    end
                else
                    -- Significant bonus for applying new HoT to tank
                    target_score = target_score * 1.5
                end
            end
        end
        
        -- Check for other potential targets
        local general_targets = {}
        
        -- Function to score a potential target
        local function score_target(unit)
            if not unit then return 0 end
            
            local hp = FS.api.unit_helper:get_health_percentage(unit)
            if hp > hp_threshold then return 0 end
            
            local score = (1 - hp) * 100 -- Base score: lower health = higher score
            
            -- Check if unit already has HoT
            if FS.paladin_holy_herald.variables.eternal_flame_up(unit) then
                local remains = FS.paladin_holy_herald.variables.eternal_flame_remains(unit) / 1000
                
                -- If HoT has significant time left, reduce score substantially
                if remains > 6 then
                    score = score * 0.4 -- Substantial reduction for long remaining HoT
                elseif remains > 4 then
                    score = score * 0.6 -- Large reduction for medium remaining HoT
                elseif remains > 2 then
                    score = score * 0.8 -- Moderate reduction for short remaining HoT
                else
                    score = score * 0.9 -- Slight reduction for nearly expired HoT
                end
            else
                -- Bonus for applying new HoT
                score = score * 1.3
                
                -- Additional bonus if we have few active HoTs
                if current_ef_count < max_ef_targets - 1 then
                    score = score * 1.2
                end
            end
            
            -- Consider player role for scoring
            if FS.api.unit_helper:is_healer(unit) then
                score = score * 1.15 -- Priority to healers
            elseif FS.api.unit_helper:is_tank(unit) then
                score = score * 1.2 -- Highest priority to tanks
            end
            
            -- Consider player positioning - HoTs are more valuable on melee/tanks
            if FS.api.unit_helper:is_melee_dps(unit) then
                score = score * 1.1 -- Bonus for melee who take more damage
            end
            
            -- Consider incoming damage patterns
            local recent_damage = FS.api.unit_helper:get_recent_damage_taken(unit, 3) or 0
            if recent_damage > 0 then
                -- Normalize recent damage to a factor between 1.0 and 1.3
                local damage_factor = 1 + math.min(0.3, recent_damage / 100000)
                score = score * damage_factor
            end
            
            return score
        end
        
        -- Score all potential targets
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            local unit_score = score_target(unit)
            if unit_score > 0 then
                table.insert(general_targets, {unit = unit, score = unit_score})
            end
        end
        
        -- Sort by score (highest first)
        table.sort(general_targets, function(a, b) return a.score > b.score end)
        
        -- Check if we found a higher-scoring target than the tank
        if #general_targets > 0 and general_targets[1].score > target_score then
            target = general_targets[1].unit
            target_score = general_targets[1].score
        end
    end
    
    -- Consider Empyrean Legacy proc: if active, ensure we use it
    if has_empyrean and not target then
        -- If we have Empyrean Legacy but no good target, pick anyone who could use healing
        target = FS.modules.heal_engine.get_single_target(
            0.95, -- Almost anyone who's not at full health
            FS.paladin_holy_herald.spells.eternal_flame,
            true,
            false
        )
        
        if target then
            target_score = 50 -- Modest score just to use the proc
        end
    end
    
    -- If we have a target, cast Eternal Flame
    if target and target_score > 0 then
        -- Set priority based on multiple factors
        local priority = 1 -- Default normal priority
        
        -- Emergency healing gets highest priority
        if emergency_situation then
            priority = 0
        -- Empyrean Legacy proc gets high priority
        elseif has_empyrean then
            priority = 0
        -- Lower health gets higher priority
        elseif FS.api.unit_helper:get_health_percentage(target) < hp_threshold * 0.6 then
            priority = 0
        end
        
        -- Check Holy Power - scale up with Holy Power (1-3)
        local power_scale = math.min(3, currentHP) / 3
        local final_healing = power_scale * 100 -- Percentage of max healing based on Holy Power
        
        -- Queue spell cast
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.eternal_flame, target, priority)
        return true
    end
    
    return false
end