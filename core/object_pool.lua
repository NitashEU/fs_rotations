---@class object_pool_options
---@field initial_size number Initial number of objects to pre-allocate
---@field max_size number|nil Maximum number of objects to keep in the pool (nil for unlimited)
---@field cleanup_interval number|nil How often to run cleanup (in seconds, nil to disable)
---@field min_recycle_rate number|nil Minimum recycle rate before cleanup triggers (0.0-1.0)
---@field object_type string The type of object for reporting
---@field estimate_size function|nil Function to estimate object memory usage
---@field on_create function|nil Called when a new object is created
---@field on_release function|nil Called when an object is released back to pool
---@field debug boolean Whether to enable detailed debug logging

---@class object_pool
---@field name string Name of this pool
---@field objects table[] Array of pooled objects
---@field created number Count of objects created
---@field acquired number Count of objects currently in use
---@field recycled number Count of objects recycled
---@field hits number Cache hits (object reused from pool)
---@field misses number Cache misses (new object created)
---@field last_cleanup number Timestamp of last cleanup
---@field estimated_memory number Estimated memory used by all created objects
---@field peak_usage number Peak number of objects in use at once
---@field options object_pool_options Options for this pool
---@field create_fn function Function to create a new object
---@field reset_fn function Function to reset an object before reuse
---@field acquire fun(self:object_pool):table Get an object from the pool
---@field release fun(self:object_pool, object:table) Return an object to the pool
---@field cleanup fun(self:object_pool) Clean up the pool
---@field get_stats fun(self:object_pool):table Get statistics about the pool

-- Object pooling system for efficient memory management
-- Creates reusable object pools to reduce garbage collection pressure
FS.object_pool = {
    -- Registry of all pools for global management
    pools = {}, -- [pool_name] = pool_object
    
    -- Global settings
    config = {
        enabled = FS.config:get("core.object_pool.enabled", true),
        default_max_size = FS.config:get("core.object_pool.default_max_size", 1000),
        default_cleanup_interval = FS.config:get("core.object_pool.default_cleanup_interval", 60), -- seconds
        global_cleanup_interval = FS.config:get("core.object_pool.global_cleanup_interval", 300), -- seconds
        check_leaks = FS.config:get("core.object_pool.check_leaks", true),
        debug = FS.config:get("core.object_pool.debug", false)
    },
    
    -- Internal state
    last_global_cleanup = 0,
    current_time = 0,
    
    ---Create a new object pool
    ---@param name string Unique name for the pool
    ---@param create_fn function Function to create a new object
    ---@param reset_fn function|nil Function to reset an object for reuse
    ---@param options object_pool_options|nil Pool configuration options
    ---@return object_pool The new object pool
    create = function(self, name, create_fn, reset_fn, options)
        -- Create default options if not provided
        options = options or {}
        options.initial_size = options.initial_size or 10
        options.max_size = options.max_size or self.config.default_max_size
        options.cleanup_interval = options.cleanup_interval or self.config.default_cleanup_interval
        options.min_recycle_rate = options.min_recycle_rate or 0.7
        options.object_type = options.object_type or "object"
        options.debug = options.debug or self.config.debug
        
        -- Create the pool object
        local pool = {
            name = name,
            objects = {},
            created = 0,
            acquired = 0,
            recycled = 0,
            hits = 0,
            misses = 0,
            last_cleanup = 0,
            estimated_memory = 0,
            peak_usage = 0,
            options = options,
            create_fn = create_fn,
            reset_fn = reset_fn or function(obj) 
                -- Default reset function clears all fields
                for k in pairs(obj) do obj[k] = nil end
            end,
            
            -- Object acquisition (get from pool or create new)
            acquire = function(self)
                -- Skip pooling if disabled
                if not FS.object_pool.config.enabled then
                    local obj = self.create_fn()
                    self.created = self.created + 1
                    self.acquired = self.acquired + 1
                    self.peak_usage = math.max(self.peak_usage, self.acquired)
                    
                    -- Track memory if estimator is available
                    if self.options.estimate_size then
                        self.estimated_memory = self.estimated_memory + self.options.estimate_size(obj)
                    end
                    
                    -- Call on_create handler if provided
                    if self.options.on_create then
                        self.options.on_create(obj)
                    end
                    
                    return obj
                end
                
                -- Try to get from pool first
                local obj = table.remove(self.objects)
                
                if obj then
                    -- Hit - reusing an object from the pool
                    self.hits = self.hits + 1
                    self.acquired = self.acquired + 1
                    
                    -- Track peak usage
                    self.peak_usage = math.max(self.peak_usage, self.acquired)
                    
                    -- Debug logging
                    if self.options.debug then
                        core.log_debug(string.format(
                            "POOL[%s] HIT - Reusing object #%d (in use: %d, pool: %d, recycled: %d)",
                            self.name, self.created, self.acquired, #self.objects, self.recycled
                        ))
                    end
                    
                    return obj
                else
                    -- Miss - need to create a new object
                    self.misses = self.misses + 1
                    self.created = self.created + 1
                    self.acquired = self.acquired + 1
                    
                    -- Create new object
                    obj = self.create_fn()
                    
                    -- Track peak usage
                    self.peak_usage = math.max(self.peak_usage, self.acquired)
                    
                    -- Track memory if estimator is available
                    if self.options.estimate_size then
                        self.estimated_memory = self.estimated_memory + self.options.estimate_size(obj)
                    end
                    
                    -- Call on_create handler if provided
                    if self.options.on_create then
                        self.options.on_create(obj)
                    end
                    
                    -- Debug logging
                    if self.options.debug then
                        core.log_debug(string.format(
                            "POOL[%s] MISS - Created new object #%d (in use: %d, pool: %d, recycled: %d)",
                            self.name, self.created, self.acquired, #self.objects, self.recycled
                        ))
                    end
                    
                    return obj
                end
            end,
            
            -- Object release (return to pool)
            release = function(self, obj)
                if not obj then return end
                
                -- Skip pooling if disabled
                if not FS.object_pool.config.enabled then
                    self.acquired = math.max(0, self.acquired - 1)
                    return
                end
                
                -- Reset the object
                self:reset_fn(obj)
                
                -- Check if we should add to pool or discard
                local current_pool_size = #self.objects
                if not self.options.max_size or current_pool_size < self.options.max_size then
                    -- Add to pool
                    table.insert(self.objects, obj)
                else
                    -- Pool is full, discard the object
                    if self.options.debug then
                        core.log_debug(string.format(
                            "POOL[%s] DISCARD - Pool full, discarding object (max_size: %d)",
                            self.name, self.options.max_size
                        ))
                    end
                end
                
                -- Update stats
                self.recycled = self.recycled + 1
                self.acquired = math.max(0, self.acquired - 1)
                
                -- Call on_release handler if provided
                if self.options.on_release then
                    self.options.on_release(obj)
                end
                
                -- Debug logging
                if self.options.debug then
                    core.log_debug(string.format(
                        "POOL[%s] RELEASE - Object released (in use: %d, pool: %d, recycled: %d)",
                        self.name, self.acquired, #self.objects, self.recycled
                    ))
                end
                
                -- Check if we should cleanup
                if self.options.cleanup_interval and
                   FS.object_pool.current_time - self.last_cleanup > self.options.cleanup_interval * 1000 then
                    -- Only cleanup if our recycle rate is below threshold
                    local recycle_rate = self:get_recycle_rate()
                    if recycle_rate < self.options.min_recycle_rate then
                        self:cleanup()
                    end
                end
            end,
            
            -- Clean up excess objects in the pool
            cleanup = function(self)
                -- Skip if pool is empty or disabled
                if #self.objects == 0 or not FS.object_pool.config.enabled then
                    return
                end
                
                local current_pool_size = #self.objects
                local target_size = math.min(self.options.initial_size, current_pool_size)
                
                if current_pool_size > target_size then
                    -- Remove excess objects
                    local to_remove = current_pool_size - target_size
                    for i = 1, to_remove do
                        table.remove(self.objects)
                    end
                    
                    if self.options.debug then
                        core.log_debug(string.format(
                            "POOL[%s] CLEANUP - Removed %d excess objects (new size: %d)",
                            self.name, to_remove, #self.objects
                        ))
                    end
                end
                
                self.last_cleanup = FS.object_pool.current_time
            end,
            
            -- Get pool recycle rate (0.0-1.0, higher is better)
            get_recycle_rate = function(self)
                local total = self.hits + self.misses
                if total == 0 then return 1.0 end
                return self.hits / total
            end,
            
            -- Get pool stats
            get_stats = function(self)
                local recycle_rate = self:get_recycle_rate()
                local efficiency_score
                
                if self.created == 0 then
                    efficiency_score = 1.0 -- No objects created yet
                else
                    -- Calculate how many objects we've avoided creating
                    efficiency_score = self.recycled / (self.created + self.recycled)
                end
                
                local stats = {
                    name = self.name,
                    object_type = self.options.object_type,
                    pool_size = #self.objects,
                    created = self.created,
                    acquired = self.acquired,
                    recycled = self.recycled,
                    hits = self.hits,
                    misses = self.misses,
                    recycle_rate = recycle_rate,
                    efficiency_score = efficiency_score,
                    peak_usage = self.peak_usage,
                    estimated_memory = self.estimated_memory,
                    last_cleanup = self.last_cleanup,
                    health = self:get_health_status()
                }
                
                return stats
            end,
            
            -- Get health status (for UI)
            get_health_status = function(self)
                local recycle_rate = self:get_recycle_rate()
                
                -- Check for potential leaks
                if FS.object_pool.config.check_leaks and 
                   self.acquired > 0 and 
                   self.acquired > self.peak_usage * 0.5 then
                    return "warning" -- Possible leak detected
                end
                
                -- Check recycle rate
                if recycle_rate < 0.5 then
                    return "poor"
                elseif recycle_rate < 0.8 then
                    return "average"
                else
                    return "good"
                end
            end
        }
        
        -- Pre-allocate initial objects
        for i = 1, options.initial_size do
            local obj = create_fn()
            table.insert(pool.objects, obj)
            pool.created = pool.created + 1
            
            -- Track memory if estimator is available
            if options.estimate_size then
                pool.estimated_memory = pool.estimated_memory + options.estimate_size(obj)
            end
        end
        
        -- Register in pools registry
        self.pools[name] = pool
        
        -- Debug logging
        if options.debug then
            core.log_debug(string.format(
                "POOL[%s] CREATED - %d objects pre-allocated",
                name, options.initial_size
            ))
        end
        
        return pool
    end,
    
    ---Get an existing pool by name
    ---@param name string Pool name
    ---@return object_pool|nil The pool object or nil if not found
    get_pool = function(self, name)
        return self.pools[name]
    end,
    
    ---Update all pools
    ---@param current_time number Current game time
    update = function(self, current_time)
        self.current_time = current_time
        
        -- Only run global cleanup periodically
        if current_time - self.last_global_cleanup > self.config.global_cleanup_interval * 1000 then
            self:global_cleanup()
            self.last_global_cleanup = current_time
        end
    end,
    
    ---Clean up all pools
    global_cleanup = function(self)
        -- Skip if disabled
        if not self.config.enabled then
            return
        end
        
        -- Clean up each pool
        for name, pool in pairs(self.pools) do
            pool:cleanup()
        end
        
        -- Force garbage collection
        collectgarbage("collect")
        
        if self.config.debug then
            core.log_debug("POOL[GLOBAL] CLEANUP - All pools cleaned up")
        end
    end,
    
    ---Reset statistics for all pools
    reset_stats = function(self)
        for name, pool in pairs(self.pools) do
            pool.hits = 0
            pool.misses = 0
            pool.recycled = 0
            pool.peak_usage = pool.acquired
        end
    end,
    
    ---Get stats for all pools
    ---@param sort_by string|nil Field to sort by 
    ---@return table[] Array of pool stats
    get_all_stats = function(self, sort_by)
        local stats = {}
        
        -- Collect stats from all pools
        for name, pool in pairs(self.pools) do
            table.insert(stats, pool:get_stats())
        end
        
        -- Sort if requested
        if sort_by then
            table.sort(stats, function(a, b)
                if sort_by == "memory" then
                    return a.estimated_memory > b.estimated_memory
                elseif sort_by == "size" then
                    return a.created > b.created
                elseif sort_by == "efficiency" then
                    return a.efficiency_score < b.efficiency_score
                else
                    return a.name < b.name
                end
            end)
        end
        
        return stats
    end,
    
    ---Get total memory estimation across all pools
    ---@return number Estimated memory usage in bytes
    get_total_memory = function(self)
        local total = 0
        for name, pool in pairs(self.pools) do
            total = total + pool.estimated_memory
        end
        return total
    end,
    
    ---Check for potential memory leaks
    ---@return table[] Array of pools with potential leaks
    check_leaks = function(self)
        if not self.config.check_leaks then
            return {}
        end
        
        local leaks = {}
        
        for name, pool in pairs(self.pools) do
            -- Check for high unreleased object count
            if pool.acquired > 10 and pool.acquired > pool.peak_usage * 0.5 then
                table.insert(leaks, {
                    pool = name,
                    acquired = pool.acquired,
                    peak = pool.peak_usage,
                    created = pool.created,
                    risk = "high"
                })
            end
        end
        
        return leaks
    end,
    
    ---Estimate the size of a Lua value in bytes
    ---@param value any The value to estimate size for
    ---@param visited table|nil Table to track visited objects
    ---@return number Estimated size in bytes
    estimate_size = function(self, value, visited)
        -- Initialize visited table on first call
        visited = visited or {}
        
        -- Calculate size based on type
        local size = 0
        local t = type(value)
        
        if t == "nil" then
            size = 0
        elseif t == "boolean" then
            size = 4
        elseif t == "number" then
            size = 8
        elseif t == "string" then
            size = string.len(value) + 24  -- String header + data
        elseif t == "function" then
            size = 40  -- Approximate function size
        elseif t == "table" then
            -- Check if we've already visited this table (avoid cycles)
            if visited[value] then
                return 0
            end
            
            -- Mark as visited
            visited[value] = true
            
            -- Base table overhead
            size = 40  -- Table header
            
            -- Add size of all keys and values
            for k, v in pairs(value) do
                size = size + self:estimate_size(k, visited)
                size = size + self:estimate_size(v, visited)
            end
        end
        
        return size
    end
}

return FS.object_pool