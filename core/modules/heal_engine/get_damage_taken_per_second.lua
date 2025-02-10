local profiler = require("common/modules/profiler")

-- Store last DPS values to detect significant changes
FS.modules.heal_engine.last_dps_values = FS.modules.heal_engine.last_dps_values or {}

---Calculate the damage taken per second for a unit over a specified time period
---@param unit game_object The unit to calculate damage for
---@param last_x_seconds number The number of seconds to look back
---@return number The calculated damage per second
function FS.modules.heal_engine.get_damage_taken_per_second(unit, last_x_seconds)
    local current_time = core.game_time()
    local values = FS.modules.heal_engine.health_values[unit] or {}
    
    -- Early exit if we don't have enough values
    if #values < 2 then
        return 0
    end

    -- Start profiling
    profiler.start("get_damage_taken_per_second")

    -- Find first valid index (binary search for better performance)
    local start_time = current_time - last_x_seconds * 1000
    local left, right = 1, #values
    local first_valid_index = right + 1

    while left <= right do
        local mid = math.floor((left + right) / 2)
        if values[mid].time >= start_time then
            first_valid_index = mid
            right = mid - 1
        else
            left = mid + 1
        end
    end

    -- Early exit if we don't have enough valid values
    if first_valid_index >= #values then
        profiler.stop("get_damage_taken_per_second")
        return 0
    end

    -- Single pass for damage calculation
    local first_time = values[first_valid_index].time
    local last_time = values[#values].time
    local prev_health = values[first_valid_index].health
    local total_damage = 0
    local damage_events = 0
    local significant_damage = false

    for i = first_valid_index + 1, #values do
        local current_health = values[i].health
        local health_diff = prev_health - current_health
        
        if health_diff > 0 then
            total_damage = total_damage + health_diff
            damage_events = damage_events + 1
            if health_diff > unit:get_max_health() * 0.01 then
                significant_damage = true
            end
        end
        prev_health = current_health
    end

    -- Calculate DPS using the actual time span
    local time_span = (last_time - first_time) / 1000 -- Convert to seconds
    if time_span <= 0 then
        profiler.stop("get_damage_taken_per_second")
        return 0
    end
    
    local dps = total_damage / time_span

    -- Only log if debug logging is enabled and we detected significant damage AND DPS changed significantly
    if FS.modules.heal_engine.settings.logging.is_debug_enabled() and
       FS.modules.heal_engine.settings.logging.dps.should_show_windows() then
        local unit_key = tostring(unit) .. "_" .. last_x_seconds
        local last_dps = FS.modules.heal_engine.last_dps_values[unit_key] or 0
        local dps_change = math.abs(dps - last_dps)
        local dps_change_threshold = unit:get_max_health() * FS.modules.heal_engine.settings.logging.dps.get_threshold()

        if (last_x_seconds == 15 and significant_damage) or 
           (significant_damage and dps_change > dps_change_threshold) then
            core.log(string.format("DPS (%ds): %.0f damage over %.1f seconds = %.0f DPS (%d hits)", 
                last_x_seconds, total_damage, time_span, dps, damage_events))
            FS.modules.heal_engine.last_dps_values[unit_key] = dps
        end
    end

    profiler.stop("get_damage_taken_per_second")
    return dps
end
