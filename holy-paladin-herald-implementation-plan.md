# Holy Paladin Herald of the Sun Implementation Plan

## Current State Analysis

The current Holy Paladin Herald of the Sun implementation has a good foundation with:
- Basic spell implementations
- Dawnlight tracking
- Holy Power management
- Target selection mechanisms
- Cooldown integration

However, there are several areas that need improvement to match best practices from the guides:

## Implementation Changes

### 1. Avenging Wrath Rotation Enhancement

The current `avenging_wrath.lua` needs to be enhanced to better handle the special beam mechanics:

```lua
function FS.paladin_holy_herald.logic.rotations.avenging_wrath()
    -- If not in Avenging Wrath window, return false to continue with standard rotation
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return false
    end
    
    -- During Avenging Wrath, prioritize beam optimization if enabled
    if FS.paladin_holy_herald.settings.optimize_beams() and 
       FS.paladin_holy_herald.logic.spells.optimize_dawnlight_beams() then
        return true
    end
    
    -- High priority on applying Dawnlight to allies who need it after Holy Prism
    if FS.paladin_holy_herald.variables.post_holy_prism_state() and 
       FS.paladin_holy_herald.logic.spells.apply_dawnlight() then
        return true
    end
    
    -- Prioritize Holy Shock during Avenging Wrath to generate Holy Power
    if FS.paladin_holy_herald.logic.spells.holy_shock() then
        return true
    end
    
    -- Spend Holy Power aggressively during Avenging Wrath
    if FS.paladin_holy_herald.logic.spells.spend_holy_power(true) then
        return true
    end
    
    -- Use Holy Prism if available during Avenging Wrath to generate more beams
    if FS.paladin_holy_herald.logic.spells.holy_prism() then
        return true
    }
    
    -- If no specific Avenging Wrath actions were taken, return false to continue with standard rotation
    return false
end
```

### 2. Beam Optimization Implementation

Create a new `dawnlight.lua` file to implement beam optimization logic:

```lua
function FS.paladin_holy_herald.logic.spells.optimize_dawnlight_beams()
    -- Only attempt beam optimization during Avenging Wrath
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return false
    end
    
    -- Get all targets with Dawnlight
    local dawnlight_targets = FS.paladin_holy_herald.variables.dawnlight_targets()
    if #dawnlight_targets < 2 then
        return false -- Need at least 2 targets to form beams
    end
    
    -- Calculate optimal position - pseudocode since we can't move character
    -- This will provide visual feedback to the player about optimal positioning
    local optimal_position = calculate_optimal_position(dawnlight_targets)
    FS.paladin_holy_herald.variables.optimal_beam_position = optimal_position
    
    -- Display visual indicators for optimal position
    if FS.paladin_holy_herald.settings.show_optimal_beam_position() then
        draw_optimal_position_indicator(optimal_position)
    end
    
    -- Count intersections with current position
    local current_intersections = count_beam_intersections(dawnlight_targets)
    FS.paladin_holy_herald.variables.beam_intersections = current_intersections
    
    return false -- Return false since we can't actually move the character
end

-- Calculate current beam intersections to track effectiveness
function FS.paladin_holy_herald.logic.spells.get_current_intersection_count()
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return 0
    end
    
    local dawnlight_targets = FS.paladin_holy_herald.variables.dawnlight_targets()
    return count_beam_intersections(dawnlight_targets)
end
```

### 3. Dawnlight Application Enhancement

Improve the Dawnlight application function:

```lua
function FS.paladin_holy_herald.logic.spells.apply_dawnlight()
    -- Check if we're in the post-Holy Prism state and have remaining applications
    if not FS.paladin_holy_herald.variables.post_holy_prism_state() then
        return false
    end
    
    local remaining_applications = FS.paladin_holy_herald.variables.get_remaining_dawnlight_spenders()
    if remaining_applications <= 0 then
        return false
    end
    
    -- Get targets without Dawnlight
    local targets_without_dawnlight = {}
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if not FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight, unit) then
            local health_pct = FS.api.unit_helper:get_health_percentage(unit)
            table.insert(targets_without_dawnlight, {unit = unit, health_pct = health_pct})
        end
    end
    
    -- Sort by health percentage (lowest first)
    table.sort(targets_without_dawnlight, function(a, b) return a.health_pct < b.health_pct end)
    
    -- If no valid targets without Dawnlight, return false
    if #targets_without_dawnlight == 0 then
        return false
    end
    
    -- Prefer targets that are below holy power spender threshold
    local hp_threshold = FS.paladin_holy_herald.settings.wog_hp_threshold()
    local best_target = nil
    
    -- First check if there's a critically low target without Dawnlight
    for _, target_data in ipairs(targets_without_dawnlight) do
        if target_data.health_pct <= hp_threshold then
            best_target = target_data.unit
            break
        end
    end
    
    -- If no low health target found, just take the first target without Dawnlight
    if not best_target and #targets_without_dawnlight > 0 then
        best_target = targets_without_dawnlight[1].unit
    end
    
    -- If still no valid target, return false
    if not best_target then
        return false
    end
    
    -- Use the appropriate Holy Power spender
    if FS.paladin_holy_herald.variables.empyrean_legacy_up() then
        -- Prioritize Eternal Flame with Empyrean Legacy
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.eternal_flame, best_target, 0)
        FS.paladin_holy_herald.variables.increment_holy_power_spender_count()
        return true
    else
        -- Use Word of Glory or Light of Dawn based on surrounding targets
        local nearby_injured = count_nearby_injured_allies(best_target, 15, hp_threshold)
        
        if nearby_injured >= 3 and FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.light_of_dawn) then
            -- Use Light of Dawn for AoE healing
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.light_of_dawn, FS.variables.me, 0)
            FS.paladin_holy_herald.variables.increment_holy_power_spender_count()
            return true
        else
            -- Use Word of Glory/Eternal Flame for single target
            local spell_id = FS.paladin_holy_herald.talents.eternal_flame 
                ? FS.paladin_holy_herald.spells.eternal_flame 
                : FS.paladin_holy_herald.spells.word_of_glory
                
            FS.api.spell_queue:queue_spell_target(spell_id, best_target, 0)
            FS.paladin_holy_herald.variables.increment_holy_power_spender_count()
            return true
        end
    end
    
    return false
end
```

### 4. Holy Shock Enhancement for Rising Sunlight

Improve Holy Shock to prioritize during Rising Sunlight:

```lua
function FS.paladin_holy_herald.logic.spells.holy_shock()
    -- Early exit if not castable
    if not FS.api.spell_helper:is_spell_queueable(FS.paladin_holy_herald.spells.holy_shock, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Get current charges and settings
    local charges = FS.paladin_holy_herald.variables.holy_shock_charges()
    local base_hp_threshold = FS.paladin_holy_herald.settings.hs_hp_threshold()
    local last_charge_threshold = FS.paladin_holy_herald.settings.hs_last_charge_hp_threshold()
    local rising_sun_threshold = FS.paladin_holy_herald.settings.hs_rising_sun_hp_threshold()
    
    -- Track buff states
    local has_rising_sun = FS.paladin_holy_herald.variables.rising_sunlight_up()
    local has_gleaming_rays = FS.paladin_holy_herald.variables.gleaming_rays_up()
    local solar_grace_stacks = FS.paladin_holy_herald.variables.solar_grace_stacks() or 0
    
    -- Holy Power overcap risk check during Rising Sunlight
    local is_overcap_risk = has_rising_sun and FS.paladin_holy_herald.variables.is_holy_power_overcap_risk()

    -- Calculate effective threshold based on state
    local hp_threshold = base_hp_threshold
    local priority = 1 -- Default priority
    
    -- Adjust healing threshold and priority based on buffs
    if has_rising_sun then
        hp_threshold = rising_sun_threshold -- More aggressive with Rising Sunlight
        
        if is_overcap_risk then
            -- When at risk of overcapping Holy Power, be even more aggressive
            hp_threshold = hp_threshold * 1.15 -- Further increase threshold
            priority = 0 -- Highest priority to prevent overcapping
        end
    elseif charges <= 1 then
        hp_threshold = last_charge_threshold -- More conservative with last charge
    elseif charges >= 1.8 then
        -- More aggressive usage when close to max charges
        hp_threshold = hp_threshold * 1.1
    end
    
    -- Adjust threshold based on Solar Grace (increased haste means more Holy Shocks available)
    if solar_grace_stacks > 0 then
        local haste_bonus = FS.paladin_holy_herald.variables.get_solar_grace_haste_bonus()
        -- Be more aggressive with high haste (up to 10% more aggressive at max stacks)
        hp_threshold = hp_threshold * (1 + (haste_bonus * 2))
    end
    
    -- Track if we should prefer critical healing due to Gleaming Rays
    local prefer_critical = has_gleaming_rays
    
    -- Try tanks first with a stricter threshold
    local tank_target = FS.modules.heal_engine.get_tank_damage_target(
        FS.paladin_holy_herald.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if tank_target and FS.modules.heal_engine.current_health_values[tank_target].health_percentage <= hp_threshold * 0.9 then
        FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_shock, tank_target, priority)
        return true
    end

    -- Target selection parameters based on buff states
    local target_selection_threshold = hp_threshold
    
    -- When Gleaming Rays is active (increased crit), prioritize lower health targets
    if prefer_critical then
        target_selection_threshold = target_selection_threshold * 0.9 -- Lower threshold to find more critical targets
    end
    
    -- Get regular healing target
    local target = FS.modules.heal_engine.get_single_target(
        target_selection_threshold,
        FS.paladin_holy_herald.spells.holy_shock,
        true, -- skip_facing
        false -- don't skip range
    )

    if not target then
        return false
    }

    FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.holy_shock, target, priority)
    return true
end
```

### 5. Enhanced Empyrean Legacy Utilization

Create a specific function to check if Empyrean Legacy should be used now:

```lua
function FS.paladin_holy_herald.variables.should_use_empyrean_legacy()
    -- If Empyrean Legacy is not active, we can't use it
    if not FS.paladin_holy_herald.variables.empyrean_legacy_up() then
        return false
    }
    
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
    }
    
    -- If buff is about to expire, use it to avoid wasting
    local remains = FS.paladin_holy_herald.variables.empyrean_legacy_remains() / 1000
    if remains <= 5 then -- If less than 5 seconds left
        return true
    }
    
    return false
}
```

Then update the spend_holy_power function to use this check:

```lua
function FS.paladin_holy_herald.logic.spells.spend_holy_power(force_healing)
    -- First check if we should use Eternal Flame with Empyrean Legacy
    if FS.paladin_holy_herald.variables.empyrean_legacy_up() and 
       FS.paladin_holy_herald.variables.should_use_empyrean_legacy() then
        
        -- Get appropriate target for Eternal Flame
        local target = FS.modules.heal_engine.get_single_target(
            0.9, -- Even higher threshold to use Empyrean Legacy
            FS.paladin_holy_herald.spells.eternal_flame,
            true,
            false
        )
        
        if target then
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy_herald.spells.eternal_flame, target, 0)
            return true
        }
    }
    
    -- Rest of the function remains the same...
}
```

### 6. General Healing Rotation Update

Update the main healing rotation function to incorporate these improvements:

```lua
function FS.paladin_holy_herald.logic.rotations.healing()
    -- PRIORITY 1: Dawnlight Application
    -- This must be first to ensure we apply Dawnlight HoTs when needed
    -- during the limited window after Holy Prism
    if FS.paladin_holy_herald.logic.spells.apply_dawnlight() then
        return true
    }
    
    -- PRIORITY 2: Beam Optimization
    -- During Avenging Wrath, optimize player position for maximum beam intersections
    -- This is only active when the optimize_beams setting is enabled
    if FS.paladin_holy_herald.settings.optimize_beams() and 
       FS.paladin_holy_herald.variables.avenging_wrath_up() and
       FS.paladin_holy_herald.logic.spells.optimize_dawnlight_beams() then
        return true
    }
    
    -- PRIORITY 3: Major Cooldowns
    -- Divine Toll - instant Holy Shock on multiple targets
    if FS.paladin_holy_herald.logic.spells.divine_toll() then
        return true
    }
    
    -- Beacon of Virtue - multi-target beacon for group healing
    if FS.paladin_holy_herald.logic.spells.beacon_of_virtue() then
        return true
    }
    
    -- PRIORITY 4: Holy Prism
    -- Holy Prism is a key spell that enables Dawnlight application via Holy Power spenders
    if FS.paladin_holy_herald.logic.spells.holy_prism() then
        -- The reset function for tracking is already called inside the holy_prism implementation
        return true
    }
    
    -- PRIORITY 5: Empyrean Legacy
    -- Use Eternal Flame with Empyrean Legacy proc when appropriate
    if FS.paladin_holy_herald.variables.empyrean_legacy_up() and
       FS.paladin_holy_herald.variables.should_use_empyrean_legacy() and
       FS.paladin_holy_herald.logic.spells.eternal_flame() then
        return true
    }
    
    -- PRIORITY 6: Holy Power Spending
    -- Use Eternal Flame, Light of Dawn, or Word of Glory based on situation and settings
    -- This is our primary healing output and Dawnlight application method
    if FS.paladin_holy_herald.logic.spells.spend_holy_power(true) then
        return true
    }
    
    -- PRIORITY 7: Holy Power Generation and Supplemental Healing
    
    -- Holy Shock - primary Holy Power generator and healing spell
    if FS.paladin_holy_herald.logic.spells.holy_shock() then
        return true
    }
    
    -- Judgment - provides Holy Power via Judgment of Light talent
    if FS.paladin_holy_herald.logic.spells.judgment() then
        return true
    }
    
    -- Crusader Strike - Holy Power generator
    if FS.paladin_holy_herald.logic.spells.crusader_strike() then
        return true
    }
    
    -- Hammer of Wrath - additional Holy Power generator when available
    if FS.paladin_holy_herald.logic.spells.hammer_of_wrath() then
        return true
    }
    
    -- Consecration - low priority filler ability
    if FS.paladin_holy_herald.logic.spells.consecration() then
        return true
    }
    
    -- No valid action to take this cycle
    return false
}
```

### 7. Rising Sunlight Tracking Enhancement

Enhance Rising Sunlight tracking to better manage Holy Power:

```lua
-- Add to variables.lua
FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp = 0

function FS.paladin_holy_herald.variables.update_rising_sunlight_status()
    if FS.paladin_holy_herald.variables.rising_sunlight_up() then
        if FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp == 0 then
            -- Just activated
            FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp = core.time() / 1000
        }
    } else {
        -- Reset when not active
        FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp = 0
    }
}

function FS.paladin_holy_herald.variables.get_predicted_holy_power()
    local current_hp = FS.paladin_holy_herald.variables.holy_power()
    
    -- If Rising Sunlight isn't active, just return current Holy Power
    if not FS.paladin_holy_herald.variables.rising_sunlight_up() then
        return current_hp
    }
    
    -- Calculate how much Holy Power we might generate during remaining Rising Sunlight
    local time_in_buff = (core.time() / 1000) - FS.paladin_holy_herald.variables.rising_sunlight_active_timestamp
    local remaining_time = FS.paladin_holy_herald.variables.rising_sunlight_remains() / 1000
    
    -- Estimate Holy Power generation: typically ~1 Holy Power per 2-3 seconds during buff
    local hp_generation_rate = 0.4 -- HP per second during Rising Sunlight
    local predicted_extra_hp = math.floor(remaining_time * hp_generation_rate)
    
    return math.min(5, current_hp + predicted_extra_hp) -- Cap at 5 Holy Power
}

function FS.paladin_holy_herald.variables.is_holy_power_overcap_risk()
    return FS.paladin_holy_herald.variables.get_predicted_holy_power() >= 5
}
```

### 8. Fix Namespace Consistency Issues

Throughout the codebase, ensure all references use `FS.paladin_holy_herald` instead of `FS.paladin_holy`. This will require a global search and replace operation across all files.

## Recommended Settings

Add these settings to the `settings.lua` file:

```lua
-- Add to settings.lua
---@type fun(): boolean
optimize_beams = function() return FS.paladin_holy_herald.menu.optimize_beams_check:get_state() end,

---@type fun(): boolean
show_optimal_beam_position = function() return FS.paladin_holy_herald.menu.show_optimal_beam_position_check:get_state() end,

---@type fun(): number
hs_rising_sun_hp_threshold = function() return FS.paladin_holy_herald.menu.hs_rising_sun_hp_threshold_slider:get() / 100 end,
```

## UI Menu Updates

Add these UI elements to the menu:

```lua
-- Add to menu.lua
FS.paladin_holy_herald.menu.optimize_beams_check = FS.ui.checkbox(
    "Optimize Beams",
    "Attempts to optimize your position for maximum beam intersections during Avenging Wrath",
    true
)

FS.paladin_holy_herald.menu.show_optimal_beam_position_check = FS.ui.checkbox(
    "Show Optimal Position",
    "Displays a visual indicator for the optimal position during Avenging Wrath",
    true
)

FS.paladin_holy_herald.menu.hs_rising_sun_hp_threshold_slider = FS.ui.slider(
    "Holy Shock Health Threshold During Rising Sunlight",
    "Health percentage threshold for using Holy Shock during Rising Sunlight buff",
    70, -- Default value
    1, -- Min
    100, -- Max
    1 -- Step
)
```

## Testing Plan

After implementing these changes, test the rotation with the following scenarios:

1. Basic healing rotation without cooldowns
2. Rotation during Avenging Wrath with multiple targets
3. Holy Prism followed by Holy Power spenders to apply Dawnlight
4. Rising Sunlight buff handling
5. Empyrean Legacy proc utilization
6. Beam optimization visual feedback

This will ensure all the enhanced functionality works as expected and provides an improved healing experience for Holy Paladin Herald of the Sun players.
