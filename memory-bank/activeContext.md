# Enhanced Heal Engine Integration – Active Context

This document describes the enhancements implemented to our heal engine. These changes include:

1. **Data Smoothing with a Ring Buffer:**  
   We now store each unit’s health snapshots in a ring buffer. This approach limits the snapshots stored (to reduce memory usage) and automatically overwrites older entries when the buffer is full.

2. **Dynamic Snapshot Retention:**  
   The system now purges snapshots older than a configurable retention window (default 15 seconds). This keeps the data fresh and ensures that calculations are based on recent combat activity.

3. **Predictive Health Calculation:**  
   Using the smoothed damage and healing calculations (over a configurable 3‑second window), we generate a future health prediction for a unit over a given prediction delay (e.g., 2 seconds). This prediction is used by our healing logic.

---
## 1. Ring Buffer Implementation

**File:** `core/modules/heal_engine/ring_buffer.lua`

```lua:core/modules/heal_engine/ring_buffer.lua
---@class RingBuffer
local RingBuffer = {}
RingBuffer.__index = RingBuffer

--- Create a new ring buffer.
---@param size number
---@return RingBuffer
function RingBuffer:new(size)
    local obj = {
        buffer = {},
        size = size or 30,  -- default to 30 entries if not specified
        start = 1,
        count = 0
    }
    setmetatable(obj, self)
    return obj
end

--- Append an item to the ring buffer.
---@param item table
function RingBuffer:append(item)
    local pos = (self.start + self.count - 1) % self.size + 1
    self.buffer[pos] = item
    if self.count < self.size then
        self.count = self.count + 1
    else
        self.start = (self.start % self.size) + 1
    end
end

--- Purge items older than a retention threshold.
---@param current_time number
---@param retention_ms number
function RingBuffer:purge_old(current_time, retention_ms)
    while self.count > 0 do
        local oldest = self.buffer[self.start]
        if current_time - oldest.time >= retention_ms then
            self.start = (self.start % self.size) + 1
            self.count = self.count - 1
        else
            break
        end
    end
end

--- Convert the ring buffer to a chronological array.
---@return table
function RingBuffer:to_array()
    local result = {}
    for i = 0, self.count - 1 do
        local pos = ((self.start + i - 1) % self.size) + 1
        table.insert(result, self.buffer[pos])
    end
    return result
end

return RingBuffer
```

---
## 2. On-Update Modifications

**File:** `core/modules/heal_engine/on_update.lua`

```lua:core/modules/heal_engine/on_update.lua
local RingBuffer = require("core/modules/heal_engine/ring_buffer")

function FS.modules.heal_engine.on_fast_update()
    if not FS.modules.heal_engine.is_in_combat then
        return
    end

    local current_time = core.game_time()
    local retention_ms = FS.modules.heal_engine.retention_window_ms or 15000
    local buffer_size = FS.modules.heal_engine.buffer_size or 30

    -- For each unit, use a ring buffer for health snapshots.
    for _, unit in pairs(FS.modules.heal_engine.units) do
        if type(FS.modules.heal_engine.health_values[unit]) ~= "table" or not FS.modules.heal_engine.health_values[unit].append then
            FS.modules.heal_engine.health_values[unit] = RingBuffer:new(buffer_size)
        end
        local rb = FS.modules.heal_engine.health_values[unit]
        rb:purge_old(current_time, retention_ms)
    end

    -- Record the new snapshot for each unit.
    for _, unit in pairs(FS.modules.heal_engine.units) do
        local rb = FS.modules.heal_engine.health_values[unit]
        local snapshots = rb:to_array()
        local last_value = (#snapshots > 0 and snapshots[#snapshots]) or nil
        local new_value = {
            health = unit:get_health() + unit:get_total_shield(),
            max_health = unit:get_max_health(),
            health_percentage = (unit:get_health() + unit:get_total_shield()) / unit:get_max_health(),
            time = core.game_time()
        }
        if not last_value or last_value.health ~= new_value.health then
            rb:append(new_value)
            FS.modules.heal_engine.current_health_values[unit] = new_value
        end
    end
end
```

---
## 3. Damage Taken Calculation Using Ring Buffer

**File:** `core/modules/heal_engine/get_damage_taken_per_second.lua`

```lua:core/modules/heal_engine/get_damage_taken_per_second.lua
---@param unit game_object
---@param last_x_seconds number
---@return number
function FS.modules.heal_engine.get_damage_taken_per_second(unit, last_x_seconds)
    local total_damage = 0
    local start_time = core.game_time() - last_x_seconds * 1000
    local rb = FS.modules.heal_engine.health_values[unit]
    local snapshots = (rb and rb.to_array and rb:to_array()) or (FS.modules.heal_engine.health_values[unit] or {})

    local valid_values = {}
    for _, value in ipairs(snapshots) do
        if value.time >= start_time then
            table.insert(valid_values, value)
        end
    end

    for i = 2, #valid_values do
        local current_health = valid_values[i].health
        local previous_health = valid_values[i - 1].health
        local missing_health = previous_health - current_health
        if missing_health > 0 then
            total_damage = total_damage + missing_health
        end
    end

    if #valid_values > 1 then
        local time_diff = valid_values[#valid_values].time - valid_values[1].time
        return total_damage / (time_diff / 1000)
    elseif #valid_values == 1 then
        return total_damage
    else
        return 0
    end
end
```

---
## 4. Healing Received Calculation Using Ring Buffer

**File:** `core/modules/heal_engine/get_healing_received_per_second.lua`

```lua:core/modules/heal_engine/get_healing_received_per_second.lua
---@param unit game_object
---@param last_x_seconds number
---@return number
function FS.modules.heal_engine.get_healing_received_per_second(unit, last_x_seconds)
    local total_healing = 0
    local start_time = core.game_time() - last_x_seconds * 1000
    local rb = FS.modules.heal_engine.health_values[unit]
    local snapshots = (rb and rb.to_array and rb:to_array()) or (FS.modules.heal_engine.health_values[unit] or {})

    local valid_values = {}
    for _, value in ipairs(snapshots) do
        if value.time >= start_time then
            table.insert(valid_values, value)
        end
    end

    for i = 2, #valid_values do
        local current_health = valid_values[i].health
        local previous_health = valid_values[i - 1].health
        local gained_health = current_health - previous_health
        if gained_health > 0 then
            total_healing = total_healing + gained_health
        end
    end

    if #valid_values > 1 then
        local time_diff = valid_values[#valid_values].time - valid_values[1].time
        return total_healing / (time_diff / 1000)
    elseif #valid_values == 1 then
        return total_healing
    else
        return 0
    end
end
```

---
## 5. Predictive Health Calculation

**File:** `core/modules/heal_engine/predicted_health.lua`

```lua:core/modules/heal_engine/predicted_health.lua
--- Predicts a unit’s future health and health percentage after a given delay.
---@param unit game_object
---@param prediction_delay_seconds number
---@return number predictedHealth, number predictedPercentage
function FS.modules.heal_engine.get_predicted_health(unit, prediction_delay_seconds)
    local current = FS.modules.heal_engine.current_health_values[unit]
    if not current then
        return nil
    end

    -- Calculate damage and healing rates using a 3-second window.
    local damage_per_sec = FS.modules.heal_engine.get_damage_taken_per_second(unit, 3)
    local healing_per_sec = FS.modules.heal_engine.get_healing_received_per_second(unit, 3)
    local net_change_per_sec = healing_per_sec - damage_per_sec

    local predictedHealth = current.health + (net_change_per_sec * prediction_delay_seconds)
    if predictedHealth > current.max_health then
        predictedHealth = current.max_health
    elseif predictedHealth < 0 then
        predictedHealth = 0
    end

    local predictedPercentage = predictedHealth / current.max_health
    return predictedHealth, predictedPercentage
end

return FS.modules.heal_engine.get_predicted_health
```

---
## 6. Heal Engine Main Index Integration

**File:** `core/modules/heal_engine/index.lua`

```lua:core/modules/heal_engine/index.lua
---@class HealthValue
---@field public health number
---@field public max_health number
---@field public health_percentage number
---@field public time number

FS.modules.heal_engine = {
    is_in_combat = false,
    ---@type game_object[]
    units = {},
    ---@type game_object[]
    tanks = {},
    ---@type game_object[]
    healers = {},
    ---@type game_object[]
    damagers = {},
    ---@type table<game_object, HealthValue[]|any>  -- ring buffers will be stored here
    health_values = {},
    ---@type table<game_object, HealthValue>
    current_health_values = {},
    ---@type table<game_object, number>
    damage_taken_per_second = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_5_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_10_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_15_seconds = {},
    -- Configuration options
    retention_window_ms = 15000,  -- snapshot retention window (15 seconds)
    buffer_size = 30              -- maximum snapshot entries per unit
}

require("core/modules/heal_engine/get_damage_taken_per_second")
require("core/modules/heal_engine/get_healing_received_per_second")
require("core/modules/heal_engine/on_update")
require("core/modules/heal_engine/reset")
require("core/modules/heal_engine/start")
require("core/modules/heal_engine/predicted_health")

return {
    on_update = FS.modules.heal_engine.on_update,
    on_fast_update = FS.modules.heal_engine.on_fast_update
}
```
