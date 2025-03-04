---@type enums
local enums = require("common/enums")

FS.paladin_holy_herald.variables = {
    holy_power = function() return FS.variables.resource(enums.power_type.HOLYPOWER) end,
    avenging_crusader_up = function() return FS.variables.buff_up(FS.paladin_holy_herald.auras.avenging_crusader) end,
    avenging_wrath_up = function() return FS.variables.buff_up(FS.paladin_holy_herald.spells.avenging_wrath) end,
    awakening_max_remains = function() return FS.variables.buff_remains(FS.paladin_holy_herald.auras.awakening_max) end,
    awakening_stacks = function() return FS.variables.buff_stacks(FS.paladin_holy_herald.auras.awakening_stacks) or 0 end,
    awakening_near_max = function() return FS.paladin_holy_herald.variables.awakening_stacks() >= 13 end,
    blessed_assurance_up = function() return FS.variables.buff_up(FS.paladin_holy_herald.auras.blessed_assurance) end,
    -- holy_armament_override_up removed as it's not part of Herald of the Sun spec
    -- Rising Sunlight tracking (increased Holy Power generation)
    rising_sunlight_up = function() return FS.variables.buff_up(FS.paladin_holy_herald.auras.rising_sunlight) end,
    rising_sunlight_remains = function() return FS.variables.buff_remains(FS.paladin_holy_herald.auras.rising_sunlight) end,
    rising_sunlight_duration = 15, -- Base duration in seconds
    
    -- Track Holy Power during Rising Sunlight to avoid overcapping
    rising_sunlight_active_timestamp = 0,
    update_rising_sunlight_status = function()
        if FS.paladin_holy_herald.variables.rising_sunlight_up() then
            if FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp == 0 then
                -- Just activated
                FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp = core.time() / 1000
            end
        else
            -- Reset when not active
            FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp = 0
        end
    end,
    
    get_predicted_holy_power = function()
        local current_hp = FS.paladin_holy_herald.variables.holy_power()
        
        -- If Rising Sunlight isn't active, just return current Holy Power
        if not FS.paladin_holy_herald.variables.rising_sunlight_up() then
            return current_hp
        end
        
        -- Calculate how much Holy Power we might generate during remaining Rising Sunlight
        local time_in_buff = (core.time() / 1000) - FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp
        local remaining_time = FS.paladin_holy_herald.variables.rising_sunlight_remains() / 1000
        
        -- Estimate Holy Power generation: typically ~1 Holy Power per 2-3 seconds during buff
        local hp_generation_rate = 0.4 -- HP per second during Rising Sunlight
        local predicted_extra_hp = math.floor(remaining_time * hp_generation_rate)
        
        return math.min(5, current_hp + predicted_extra_hp) -- Cap at 5 Holy Power
    end,
    
    is_holy_power_overcap_risk = function()
        return FS.paladin_holy_herald.variables.get_predicted_holy_power() >= 5
    end,
    
    dawnlight_up = function() return FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight) end,
    dawnlight_count = function()
        local count = 0
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight, unit) then
                count = count + 1
            end
        end
        return count
    end,

    dawnlight_targets = function()
        local targets = {}
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight, unit) then
                table.insert(targets, unit)
            end
        end
        return targets
    end,
    -- Gleaming Rays tracking (increased critical chance)
    gleaming_rays_up = function() return FS.variables.buff_up(FS.paladin_holy_herald.auras.gleaming_rays) end,
    gleaming_rays_remains = function() return FS.variables.buff_remains(FS.paladin_holy_herald.auras.gleaming_rays) end,
    gleaming_rays_duration = 6, -- Base duration in seconds
    
    -- Solar Grace tracking (increased haste)
    solar_grace_stacks = function()
        return FS.variables.buff_stacks(FS.paladin_holy_herald.auras.solar_grace)
    end,
    solar_grace_remains = function() return FS.variables.buff_remains(FS.paladin_holy_herald.auras.solar_grace) end,
    solar_grace_haste_per_stack = 0.01, -- 1% haste per stack
    get_solar_grace_haste_bonus = function()
        local stacks = FS.paladin_holy_herald.variables.solar_grace_stacks() or 0
        return stacks * FS.paladin_holy_herald.variables.solar_grace_haste_per_stack
    end,

    -- Track Holy Prism state for Dawnlight application
    last_holy_prism_time = 0,
    holy_power_spenders_since_prism = 0,
    max_holy_power_spenders_window = 2, -- Holy Prism allows for 2 Holy Power spenders to apply Dawnlight
    last_holy_prism_target = nil, -- Track the last target Holy Prism was used on
    
    -- Check if we're in the post-Holy Prism state for Dawnlight application
    post_holy_prism_state = function() 
        -- Must be within time window and not have used up all Holy Power spenders
        local current_time = core.time() / 1000 -- Convert milliseconds to seconds
        local time_since_cast = current_time - FS.paladin_holy_herald.variables.last_holy_prism_time
        local time_window = 15 -- 15 seconds window after Holy Prism to apply Dawnlight (increased from 10)
        
        -- Both time window and Holy Power spender count must be valid
        return time_since_cast < time_window and 
               FS.paladin_holy_herald.variables.holy_power_spenders_since_prism < 
               FS.paladin_holy_herald.variables.max_holy_power_spenders_window
    end,
    
    -- Reset Holy Prism tracking (call when Holy Prism is cast)
    reset_holy_prism_tracking = function()
        FS.paladin_holy_herald.variables.last_holy_prism_time = core.time() / 1000
        FS.paladin_holy_herald.variables.holy_power_spenders_since_prism = 0
    end,
    
    -- Increment Holy Power spender counter (call after using a Holy Power spender)
    increment_holy_power_spender_count = function()
        FS.paladin_holy_herald.variables.holy_power_spenders_since_prism = 
            FS.paladin_holy_herald.variables.holy_power_spenders_since_prism + 1
    end,
    
    -- Check if Dawnlight should be prioritized after Holy Prism
    should_prioritize_dawnlight = function()
        -- True if we're in post-Holy Prism state and have the setting enabled
        return FS.paladin_holy_herald.variables.post_holy_prism_state() and
               FS.paladin_holy_herald.settings.hp_prioritize_dawnlight()
    end,
    
    -- Gets remaining HP spenders allowed in current window
    get_remaining_dawnlight_spenders = function()
        if not FS.paladin_holy_herald.variables.post_holy_prism_state() then
            return 0
        end
        
        return FS.paladin_holy_herald.variables.max_holy_power_spenders_window - 
               FS.paladin_holy_herald.variables.holy_power_spenders_since_prism
    end,

    -- Optimal beam positioning for Sun's Avatar
    optimal_beam_position = nil,

    -- Track beam intersection data
    beam_intersections = 0,
    update_beam_intersections = function()
        if FS.paladin_holy_herald.logic and FS.paladin_holy_herald.logic.spells and FS.paladin_holy_herald.logic.spells.get_current_intersection_count then
            FS.paladin_holy_herald.variables.beam_intersections = FS.paladin_holy_herald.logic.spells
            .get_current_intersection_count()
        end
    end,

    holy_shock_charges = function()
        local charges = core.spell_book.get_spell_charge(FS.paladin_holy_herald.spells.holy_shock)
        local max_charges = core.spell_book.get_spell_charge_max(FS.paladin_holy_herald.spells.holy_shock)

        if charges == max_charges then
            return charges
        end

        local cooldown = FS.api.spell_helper:get_remaining_charge_cooldown(FS.paladin_holy_herald.spells.holy_shock)
        -- Instead of haste, use base cooldown as it already includes haste
        local base_cooldown = core.spell_book.get_spell_charge_cooldown_duration(FS.paladin_holy_herald.spells
        .holy_shock)
        local recharge = cooldown / base_cooldown

        return charges + (1 - recharge)
    end,

    empyrean_legacy_up = function()
        return FS.variables.buff_up(FS.paladin_holy_herald.auras.empyrean_legacy)
    end,

    -- Fix the parameter type mismatch
    get_holy_power_as_number = function()
        return FS.paladin_holy_herald.variables.holy_power() or 0
    end,
    
    -- Holy Power management and overcap prevention
    max_holy_power = 5,
    
    -- Sun's Avatar tracking
    suns_avatar_up = function(unit) 
        unit = unit or FS.variables.me
        return FS.variables.buff_up(FS.paladin_holy_herald.auras.suns_avatar, unit) 
    end,
    
    suns_avatar_remains = function(unit) 
        unit = unit or FS.variables.me
        return FS.variables.buff_remains(FS.paladin_holy_herald.auras.suns_avatar, unit) 
    end,
    
    -- Get all units affected by Sun's Avatar
    suns_avatar_targets = function()
        local targets = {}
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.suns_avatar, unit) then
                table.insert(targets, unit)
            end
        end
        return targets
    end,
    
    -- Empyrean Legacy tracking
    empyrean_legacy_remains = function() 
        return FS.variables.buff_remains(FS.paladin_holy_herald.auras.empyrean_legacy) 
    end,
    
    -- Dawnlight tracking enhancements
    dawnlight_remains = function(unit)
        return FS.variables.buff_remains(FS.paladin_holy_herald.auras.dawnlight, unit)
    end,
    
    -- Eternal Flame tracking
    eternal_flame_up = function(unit)
        return FS.variables.buff_up(FS.paladin_holy_herald.auras.eternal_flame, unit)
    end,
    
    eternal_flame_remains = function(unit)
        return FS.variables.buff_remains(FS.paladin_holy_herald.auras.eternal_flame, unit)
    end,
    
    eternal_flame_duration = 30, -- Base duration in seconds
    
    -- Get all units with Eternal Flame HoT
    eternal_flame_targets = function()
        local targets = {}
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.eternal_flame, unit) then
                table.insert(targets, unit)
            end
        end
        return targets
    end,
    
    -- Get detailed info about Eternal Flame targets
    eternal_flame_targets_with_details = function()
        local targets = {}
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.eternal_flame, unit) then
                table.insert(targets, {
                    unit = unit,
                    remains = FS.paladin_holy_herald.variables.eternal_flame_remains(unit) / 1000,
                    health_percent = FS.api.unit_helper:get_health_percentage(unit) or 100
                })
            end
        end
        return targets
    end,
    
    -- Count active Eternal Flame HoTs
    eternal_flame_count = function()
        local count = 0
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.eternal_flame, unit) then
                count = count + 1
            end
        end
        return count
    end,
    
    dawnlight_targets_with_details = function()
        local targets = {}
        for _, unit in ipairs(FS.modules.heal_engine.units) do
            if FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight, unit) then
                table.insert(targets, {
                    unit = unit,
                    remains = FS.paladin_holy_herald.variables.dawnlight_remains(unit) / 1000,
                    health_percent = FS.api.unit_helper:get_health_percentage(unit) or 100
                })
            end
        end
        return targets
    end,
    
    -- Check if current Holy Power is at or near cap
    is_holy_power_overcapped = function()
        local current_hp = FS.paladin_holy_herald.variables.get_holy_power_as_number()
        return current_hp >= FS.paladin_holy_herald.variables.max_holy_power
    end,
    
    is_holy_power_near_cap = function()
        local current_hp = FS.paladin_holy_herald.variables.get_holy_power_as_number()
        return current_hp >= (FS.paladin_holy_herald.variables.max_holy_power - 1)
    end,
    
    -- Calculate Holy Power generation within given timeframe
    estimate_upcoming_holy_power = function(timeframe_seconds)
        local base_generation = 0
        
        -- Add Holy Power from Rising Sunlight if active
        if FS.paladin_holy_herald.variables.rising_sunlight_up() then
            local remaining_buff = FS.paladin_holy_herald.variables.rising_sunlight_remains() / 1000
            local time_to_consider = math.min(timeframe_seconds, remaining_buff)
            base_generation = base_generation + (time_to_consider * 0.4) -- HP per second during Rising Sunlight
        end
        
        -- Add potential Holy Shock generation based on charges
        local hs_charges = FS.paladin_holy_herald.variables.holy_shock_charges()
        if hs_charges >= 1 then
            base_generation = base_generation + 1 -- At least one HS within timeframe
            
            -- If Holy Shock is about to have a second charge
            if hs_charges > 1.7 then
                base_generation = base_generation + 1
            end
        end
        
        -- Factor in Crusader Strike cooldown if close enough
        local cs_cd = core.spell_book.get_spell_cooldown(FS.paladin_holy_herald.spells.crusader_strike)
        if cs_cd and cs_cd < timeframe_seconds then
            base_generation = base_generation + 1
        end
        
        -- Round to nearest whole number since HP comes in discrete amounts
        return math.floor(base_generation + 0.5)
    end,
    
    -- Advanced Holy Power tracking
    should_spend_at_low_hp = function(hp_threshold, current_hp)
        current_hp = current_hp or FS.paladin_holy_herald.variables.get_holy_power_as_number()
        
        -- Always spend if overcapped
        if current_hp >= FS.paladin_holy_herald.variables.max_holy_power then
            return true
        end
        
        -- Spend at 4 to avoid overcapping
        if current_hp >= 4 then
            -- Check if more HP incoming within next 3 seconds
            local incoming_hp = FS.paladin_holy_herald.variables.estimate_upcoming_holy_power(3)
            if incoming_hp > 0 then
                return true -- Spend to avoid overcapping
            end
        end
        
        -- Spend at 3 if critical healing needed and target below threshold
        if current_hp >= 3 and hp_threshold then
            local critical_target = FS.modules.heal_engine.get_single_target(
                hp_threshold,
                FS.paladin_holy_herald.spells.word_of_glory,
                true,
                false
            )
            if critical_target then
                return true
            end
        end
        
        return false
    end,
    
    -- Cooldown tracking for major abilities
    cooldown_tracked_spells = {
        avenging_wrath = {
            id = FS.paladin_holy_herald.spells.avenging_wrath,
            name = "Avenging Wrath",
            base_cooldown = 120,
            priority = 1 -- Higher priority for UI display
        },
        holy_prism = {
            id = FS.paladin_holy_herald.spells.holy_prism,
            name = "Holy Prism",
            base_cooldown = 20,
            priority = 2
        },
        divine_toll = {
            id = FS.paladin_holy_herald.spells.divine_toll,
            name = "Divine Toll",
            base_cooldown = 60,
            priority = 1
        },
        beacon_of_virtue = {
            id = FS.paladin_holy_herald.spells.beacon_of_virtue,
            name = "Beacon of Virtue",
            base_cooldown = 15,
            priority = 3
        }
    },
    
    -- Function to get current cooldown info for a specific spell
    get_spell_cooldown_info = function(spell_id)
        local remaining = core.spell_book.get_spell_cooldown(spell_id) or 0
        local charges = core.spell_book.get_spell_charge(spell_id) or 0
        local max_charges = core.spell_book.get_spell_charge_max(spell_id) or 1
        
        local info = {
            cooldown_remaining = remaining / 1000, -- Convert to seconds
            charges = charges,
            max_charges = max_charges,
            is_ready = (remaining <= 0 and charges > 0) or remaining <= 0
        }
        
        return info
    end,
    
    -- Get all tracked cooldowns with their current status
    get_all_tracked_cooldowns = function()
        local cooldowns = {}
        
        for key, spell in pairs(FS.paladin_holy_herald.variables.cooldown_tracked_spells) do
            local info = FS.paladin_holy_herald.variables.get_spell_cooldown_info(spell.id)
            
            cooldowns[key] = {
                name = spell.name,
                id = spell.id,
                remaining = info.cooldown_remaining,
                charges = info.charges,
                max_charges = info.max_charges,
                is_ready = info.is_ready,
                priority = spell.priority,
                base_cooldown = spell.base_cooldown
            }
        end
        
        return cooldowns
    end,
    
    -- Function to check if Empyrean Legacy should be used now
    should_use_empyrean_legacy = function()
        -- If Empyrean Legacy is not active, we can't use it
        if not FS.paladin_holy_herald.variables.empyrean_legacy_up() then
            return false
        end
        
        -- Check for critical healing targets as priority
        local critical_target = FS.modules.heal_engine.get_single_target(
            0.5, -- 50% health or below is critical
            FS.paladin_holy_herald.spells.word_of_glory,
            true,
            false
        )
        
        -- If there's a critical target, should use immediately
        if critical_target then
            return true
        end
        
        -- If buff is about to expire, use it to avoid wasting
        local remains = FS.paladin_holy_herald.variables.empyrean_legacy_remains() / 1000
        if remains <= 5 then -- If less than 5 seconds left
            return true
        end
        
        return false
    end
}
