---@class RingBuffer
---@field buffer table  -- the internal storage
---@field size number   -- max entries in the buffer
---@field start number  -- index of the oldest entry
---@field count number  -- current number of entries
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
--- The new item is added to the correct position based on start and count.
---@param item table
function RingBuffer:append(item)
    -- Fix the index calculation.
    local pos = ((self.start - 1 + self.count) % self.size) + 1
    self.buffer[pos] = item
    if self.count < self.size then
        self.count = self.count + 1
    else
        -- If the buffer is full, overwrite the oldest element and update start.
        self.start = (self.start % self.size) + 1
    end
end

--- Purge items older than a given retention threshold.
--- Only items with a valid `time` field will be purged.
---@param current_time number
---@param retention_ms number
function RingBuffer:purge_old(current_time, retention_ms)
    while self.count > 0 do
        local oldest = self.buffer[self.start]
        -- Ensure we have an item and that it has a time field.
        if oldest and oldest.time and (current_time - oldest.time >= retention_ms) then
            self.buffer[self.start] = nil  -- Optional: clear out the reference.
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
    -- Fix the index arithmetic to match the position of the oldest element.
    for i = 0, self.count - 1 do
        local pos = ((self.start - 1 + i) % self.size) + 1
        table.insert(result, self.buffer[pos])
    end
    return result
end

return RingBuffer 