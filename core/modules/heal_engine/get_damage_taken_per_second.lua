local profiler = require("common/modules/profiler")

-- Store last DPS values to detect significant changes
FS.modules.heal_engine.last_dps_values = FS.modules.heal_engine.last_dps_values or {}

-- Check if a record's timestamp is within our time window
---@param record HealthValue The health record to check
---@param start_time number The minimum timestamp to consider
---@return boolean Whether the record is within our time window
local function is_record_within_window(record, start_time)
    return record and record.time >= start_time
end

-- Iterate through health records in a circular buffer
---@param buffer table The circular buffer containing health records
---@param start_time number The starting timestamp to consider
---@param callback function Function to call for each valid record
local function iterate_health_records(buffer, start_time, callback)
    if not buffer or buffer.count == 0 then
        return
    end
    
    local records = buffer.records
    local count = buffer.count
    local capacity = buffer.capacity
    local current_idx = buffer.next_index - 1
    if current_idx == 0 then current_idx = capacity end
    
    local records_processed = 0
    local prev_record = nil
    
    -- Iterate from newest to oldest
    while records_processed < count do
        local record = records[current_idx]
        
        -- If we found a record and it's still within our time window
        if record and record.time >= start_time then
            callback(record, records_processed + 1)
            prev_record = record
        elseif record and record.time < start_time then
            -- We've gone past our time window, but we'll include one more record
            -- to establish the baseline health at the start of our window
            if prev_record then
                callback(record, records_processed + 1)
            end
            break
        end
        
        -- Move to previous record (handle circular wrap)
        current_idx = current_idx - 1
        if current_idx == 0 then current_idx = capacity end
        
        records_processed = records_processed + 1
    end
end

---Calculate the damage taken per second for a unit over a specified time period
---@param unit game_object The unit to calculate damage for
---@param last_x_seconds number The number of seconds to look back
---@return number The calculated damage per second
function FS.modules.heal_engine.get_damage_taken_per_second(unit, last_x_seconds)
    -- Check cache first
    local unit_key = tostring(unit) .. "_" .. last_x_seconds
    local cache_entry = FS.modules.heal_engine.dps_cache[unit_key]
    local current_time = core.game_time()
    
    -- If we have a recent enough cached value, use it
    if cache_entry and current_time - cache_entry.last_update < 500 then
        return cache_entry.value
    end
    
    -- Get buffer for this unit
    local buffer = FS.modules.heal_engine.health_values[unit]
    if not buffer or buffer.count < 2 then
        return 0
    end
    
    -- Start profiling
    profiler.start("get_damage_taken_per_second")
    
    -- Calculate start time
    local start_time = current_time - last_x_seconds * 1000
    
    -- Collect relevant health records
    local relevant_records = FS.modules.heal_engine.get_array()
    iterate_health_records(buffer, start_time, function(record)
        table.insert(relevant_records, record)
    end)
    
    -- Early exit if we don't have enough valid values
    if #relevant_records < 2 then
        FS.modules.heal_engine.release_array(relevant_records)
        profiler.stop("get_damage_taken_per_second")
        return 0
    end
    
    -- Sort records by time (oldest first)
    table.sort(relevant_records, function(a, b) return a.time < b.time end)
    
    -- Get first and last records
    local first_record = relevant_records[1]
    local last_record = relevant_records[#relevant_records]
    
    -- Single pass for damage calculation
    local prev_health = first_record.health
    local total_damage = 0
    local damage_events = 0
    local significant_damage = false
    
    for i = 2, #relevant_records do
        local current_health = relevant_records[i].health
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
    local time_span = (last_record.time - first_record.time) / 1000 -- Convert to seconds
    if time_span <= 0 then
        FS.modules.heal_engine.release_array(relevant_records)
        profiler.stop("get_damage_taken_per_second")
        return 0
    end
    
    local dps = total_damage / time_span
    
    -- Store in cache
    FS.modules.heal_engine.dps_cache[unit_key] = {
        value = dps,
        last_update = current_time
    }
    
    -- Only log if debug logging is enabled and we detected significant damage AND DPS changed significantly
    if FS.modules.heal_engine.settings.logging.is_debug_enabled() and
        FS.modules.heal_engine.settings.logging.dps.should_show_windows() then
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
    
    -- Clean up
    FS.modules.heal_engine.release_array(relevant_records)
    
    profiler.stop("get_damage_taken_per_second")
    return dps
end
