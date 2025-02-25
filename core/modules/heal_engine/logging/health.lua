--- Heal Engine Health Logging
--- Handles logging of health changes and damage events

-- Module namespace
local health_logger = {}

--- Log a health change if significant enough
---@param unit game_object The unit with health change
---@param old_health number Previous health value
---@param new_health number New health value
---@param threshold number Significance threshold
function health_logger.log_health_change(unit, old_health, new_health, threshold)
    -- Only log if debug logging is enabled
    if not FS.modules.heal_engine.settings.logging.is_debug_enabled() then
        return
    end
    
    local health_diff = new_health - old_health
    local max_health = unit:get_max_health()
    
    -- Only log significant changes
    if math.abs(health_diff) > max_health * threshold then
        core.log(string.format("Health change for %s: %.0f -> %.0f (diff: %.0f)",
            unit:get_name(), old_health, new_health, health_diff))
    end
end

--- Log damage events from DPS calculations
---@param unit game_object The unit taking damage
---@param window_size number The DPS window size in seconds
---@param dps_data table DPS calculation data
function health_logger.log_dps(unit, window_size, dps_data)
    -- Only log if debug logging is enabled and DPS window logging is enabled
    if not FS.modules.heal_engine.settings.logging.is_debug_enabled() or
       not FS.modules.heal_engine.settings.logging.dps.should_show_windows() then
        return
    end
    
    -- Extract data
    local dps = dps_data.dps
    local total_damage = dps_data.total_damage
    local time_span = dps_data.time_span
    local damage_events = dps_data.damage_events
    local significant_damage = dps_data.significant_damage
    
    -- Calculate threshold for dps change based on max health
    local max_health = unit:get_max_health()
    local dps_change_threshold = max_health * FS.modules.heal_engine.settings.logging.dps.get_threshold()
    
    -- Get previous DPS value
    local last_dps = (FS.modules.heal_engine.last_dps_values["last_" .. tostring(unit) .. "_" .. window_size] or {}).dps or 0
    local dps_change = math.abs(dps - last_dps)
    
    -- Log if this is the long window (15s) with significant damage, or any window with significant DPS change
    if (window_size == 15 and significant_damage) or
       (significant_damage and dps_change > dps_change_threshold) then
        core.log(string.format("DPS (%ds): %.0f damage over %.1f seconds = %.0f DPS (%d hits)",
            window_size, total_damage, time_span, dps, damage_events))
        
        -- Save last logged DPS for this unit and window
        FS.modules.heal_engine.last_dps_values["last_" .. tostring(unit) .. "_" .. window_size] = {
            dps = dps
        }
    end
end

--- Log fight-wide DPS statistics on combat end
---@param unit game_object The unit to log statistics for
---@param total_damage number Total damage taken during fight
---@param fight_duration number Fight duration in seconds
function health_logger.log_fight_dps(unit, total_damage, fight_duration)
    -- Only log if debug logging is enabled and fight DPS logging is enabled
    if not FS.modules.heal_engine.settings.logging.is_debug_enabled() or
       not FS.modules.heal_engine.settings.logging.dps.should_show_fight() then
        return
    end
    
    -- Only log if there was significant damage
    if total_damage <= 0 then
        return
    end
    
    local fight_dps = total_damage / fight_duration
    core.log(string.format("Final Fight Stats: %.0f total damage over %.1fs = %.0f average DPS",
        total_damage, fight_duration, fight_dps))
end

--- Log a damage event when detected by collector
---@param unit game_object The unit taking damage
---@param damage number The amount of damage taken
---@param current_health number Current health after damage
---@param previous_health number Health before damage
---@param current_time number Current game time
function health_logger.log_damage_event(unit, damage, current_health, previous_health, current_time)
    -- Only log if debug logging is enabled and DPS fight logging is enabled
    if not FS.modules.heal_engine.settings.logging.is_debug_enabled() or
       not FS.modules.heal_engine.settings.logging.dps.should_show_fight() then
        return
    end
    
    -- Only log significant damage
    local max_health = unit:get_max_health()
    if damage <= max_health * FS.modules.heal_engine.settings.logging.dps.get_threshold() then
        return
    end
    
    -- Get fight duration
    local fight_duration = (current_time - FS.modules.heal_engine.fight_start_time) / 1000
    local fight_dps = FS.modules.heal_engine.fight_total_damage[unit] / fight_duration
    
    core.log(string.format("Fight DPS: %.0f damage over %.1fs = %.0f DPS",
        FS.modules.heal_engine.fight_total_damage[unit], fight_duration, fight_dps))
end

--- Log combat state changes
---@param entering_combat boolean True if entering combat, false if leaving
function health_logger.log_combat_state(entering_combat)
    -- Only log if debug logging is enabled
    if not FS.modules.heal_engine.settings.logging.is_debug_enabled() then
        return
    end
    
    if entering_combat then
        core.log("Entered combat - starting heal engine")
    else
        core.log("Left combat - resetting heal engine")
    end
end

-- Export the module
FS.modules.heal_engine.health_logger = health_logger
return health_logger