---@return boolean
function FS.paladin_holy_herald.logic.spells.light_of_dawn()
    -- Get settings
    local hp_threshold = FS.paladin_holy_herald.settings.lod_hp_threshold()
    local min_targets = FS.paladin_holy_herald.settings.lod_min_targets()
    
    -- If Eternal Flame is preferred and Empyrean Legacy is up, check if we should use it instead
    if FS.paladin_holy_herald.settings.use_eternal_flame() and
       FS.paladin_holy_herald.variables.empyrean_legacy_up() and
       FS.paladin_holy_herald.talents.eternal_flame then
        
        -- Don't use LoD unless we need AoE healing for multiple targets
        local multi_target_threshold = min_targets + 1 -- Higher bar when Empyrean Legacy is up
        
        -- Count low-health targets
        local low_health_count = 0
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.api.unit_helper:get_health_percentage(unit) <= hp_threshold then
                low_health_count = low_health_count + 1
                if low_health_count >= multi_target_threshold then
                    break
                end
            end
        end
        
        -- If not enough low-health targets, prefer Eternal Flame
        if low_health_count < multi_target_threshold then
            return false
        end
    end
    
    -- Adjust minimum targets based on Holy Power
    local current_hp = FS.paladin_holy_herald.variables.get_holy_power_as_number()
    local adjusted_min_targets = min_targets
    
    -- Be more aggressive with spending if near cap
    if FS.paladin_holy_herald.variables.is_holy_power_near_cap() then
        adjusted_min_targets = math.max(1, min_targets - 1) -- Lower the bar when near cap
    end

    -- Use frontal cone heal target selector
    local target = FS.modules.heal_engine.get_frontal_cone_heal_target(
        hp_threshold,                              -- hp_threshold
        adjusted_min_targets,                      -- min_targets
        15,                                        -- range
        46,                                        -- cone angle in degrees
        FS.paladin_holy_herald.spells.light_of_dawn -- spell_id
    )

    if not target then
        return false
    end
    
    -- Priority based on number of targets and Holy Power status
    local priority = 1
    
    -- Higher priority if Holy Power is near cap
    if FS.paladin_holy_herald.variables.is_holy_power_near_cap() then
        priority = 0
    end
    
    -- Count how many targets are actually hit by LoD
    local hit_count = 0
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if FS.api.unit_helper:get_health_percentage(unit) <= hp_threshold and
           FS.api.unit_helper:is_in_frontal_cone(FS.variables.me, unit, 46, 15) then
            hit_count = hit_count + 1
        end
    end
    
    -- Higher priority for hitting more targets (efficiency)
    if hit_count >= min_targets + 2 then
        priority = 0 -- High priority for very efficient LoD
    end

    -- Queue spell cast on player (cone originates from us)
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.light_of_dawn, FS.variables.me, priority)
    return true
end
