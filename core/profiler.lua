---@class perf_metric
---@field name string Name of the metric
---@field category string Category of the metric (e.g., "heal_engine", "spell_logic")
---@field count number Number of times the metric has been recorded
---@field total_time number Total time spent in milliseconds
---@field min_time number Minimum execution time in milliseconds
---@field max_time number Maximum execution time in milliseconds
---@field last_time number Most recent execution time in milliseconds
---@field last_timestamp number Timestamp of the last execution
---@field created_at number Timestamp when metric was first created
---@field alert_threshold number|nil Threshold in ms for alert highlighting
---@field warning_threshold number|nil Threshold in ms for warning highlighting

---@class memory_snapshot
---@field timestamp number When the snapshot was taken
---@field total_memory number Total memory in use (bytes)
---@field object_counts table<string, number> Count of each type of object

-- Performance metrics tracking system
FS.profiler = {
    -- Configuration options
    config = {
        enabled = FS.config:get("core.profiler.enabled", true),
        max_metrics = FS.config:get("core.profiler.max_metrics", 100),
        history_size = FS.config:get("core.profiler.history_size", 60),
        auto_clean_interval = FS.config:get("core.profiler.auto_clean_interval", 300), -- seconds
        default_alert_threshold = FS.config:get("core.profiler.default_alert_threshold", 100), -- ms
        default_warning_threshold = FS.config:get("core.profiler.default_warning_threshold", 50) -- ms
    },
    
    -- Metrics storage
    ---@type table<string, perf_metric>
    metrics = {},
    
    -- Metrics in progress
    ---@type table<string, number>
    active_metrics = {},
    
    -- History for charts
    ---@type table<string, number[]>
    history = {},
    
    -- Memory snapshots
    ---@type memory_snapshot[]
    memory_snapshots = {},
    
    -- Internal state
    last_cleanup_time = 0,
    num_metrics = 0,
    
    ---Start timing a specific operation
    ---@param name string Metric name
    ---@param category string|nil Category (defaults to "general")
    start = function(self, name, category)
        if not self.config.enabled then return end
        
        category = category or "general"
        local key = category .. "." .. name
        
        -- Record start time
        self.active_metrics[key] = core.game_time()
        
        -- Initialize metric if it doesn't exist
        if not self.metrics[key] then
            self:_create_metric(key, name, category)
        end
    end,
    
    ---End timing for an operation and record the result
    ---@param name string Metric name
    ---@param category string|nil Category (defaults to "general")
    ---@param success boolean|nil Was the operation successful (defaults to true)
    stop = function(self, name, category, success)
        if not self.config.enabled then return 0 end
        
        category = category or "general"
        local key = category .. "." .. name
        success = success ~= false -- default to true if nil
        
        -- Get start time
        local start_time = self.active_metrics[key]
        if not start_time then
            -- If no start time found, can't calculate duration
            return 0
        end
        
        -- Calculate duration
        local end_time = core.game_time()
        local duration = end_time - start_time
        self.active_metrics[key] = nil
        
        -- Update metrics
        self:_update_metric(key, duration, success, end_time)
        
        -- Periodic cleanup
        if end_time - self.last_cleanup_time > self.config.auto_clean_interval * 1000 then
            self:_cleanup_metrics()
            self.last_cleanup_time = end_time
        end
        
        return duration
    end,
    
    ---Take a snapshot of current memory usage
    capture_memory_snapshot = function(self)
        if not self.config.enabled then return end
        
        -- Basic memory statistics
        local snapshot = {
            timestamp = core.game_time(),
            total_memory = collectgarbage("count") * 1024, -- Convert KB to bytes
            object_counts = {}
        }
        
        -- Try to count objects by type (basic approach)
        local counts = {}
        local success, result = pcall(function()
            for k, v in pairs(_G) do
                local t = type(v)
                counts[t] = (counts[t] or 0) + 1
            end
            
            -- Count known FS objects
            if FS and type(FS) == "table" then
                for module_name, module in pairs(FS) do
                    if type(module) == "table" then
                        counts["FS." .. module_name] = FS.api.table_util.count(module)
                    end
                end
            end
            
            return counts
        end)
        
        if success then
            snapshot.object_counts = result
        end
        
        -- Add to snapshots, maintaining history size
        table.insert(self.memory_snapshots, 1, snapshot)
        if #self.memory_snapshots > self.config.history_size then
            table.remove(self.memory_snapshots)
        end
        
        return snapshot
    end,
    
    ---Set custom thresholds for a metric
    ---@param name string Metric name
    ---@param category string|nil Category (defaults to "general")
    ---@param warning_threshold number|nil Warning threshold in ms
    ---@param alert_threshold number|nil Alert threshold in ms
    set_thresholds = function(self, name, category, warning_threshold, alert_threshold)
        category = category or "general"
        local key = category .. "." .. name
        
        -- Create metric if it doesn't exist
        if not self.metrics[key] then
            self:_create_metric(key, name, category)
        end
        
        self.metrics[key].warning_threshold = warning_threshold
        self.metrics[key].alert_threshold = alert_threshold
    end,
    
    ---Get metrics for display, filtered and sorted
    ---@param category string|nil Filter by category
    ---@param sort_by string|nil Sort by field (count, total_time, avg_time, max_time)
    ---@param limit number|nil Maximum number of results
    ---@return table Metrics for display
    get_metrics_for_display = function(self, category, sort_by, limit)
        local result = {}
        limit = limit or self.config.max_metrics
        sort_by = sort_by or "total_time"
        
        -- Collect metrics
        for key, metric in pairs(self.metrics) do
            if not category or metric.category == category then
                -- Calculate average time
                local avg_time = metric.count > 0 and metric.total_time / metric.count or 0
                
                -- Create display object
                table.insert(result, {
                    key = key,
                    name = metric.name,
                    category = metric.category,
                    count = metric.count,
                    total_time = metric.total_time,
                    avg_time = avg_time,
                    min_time = metric.min_time,
                    max_time = metric.max_time,
                    last_time = metric.last_time,
                    last_timestamp = metric.last_timestamp,
                    age = (core.game_time() - metric.created_at) / 1000, -- in seconds
                    warning_threshold = metric.warning_threshold,
                    alert_threshold = metric.alert_threshold
                })
            end
        end
        
        -- Sort results based on sort_by field
        table.sort(result, function(a, b)
            if sort_by == "count" then
                return a.count > b.count
            elseif sort_by == "avg_time" then
                return a.avg_time > b.avg_time
            elseif sort_by == "max_time" then
                return a.max_time > b.max_time
            elseif sort_by == "last_time" then
                return a.last_time > b.last_time
            else -- default to total_time
                return a.total_time > b.total_time
            end
        end)
        
        -- Limit results
        if #result > limit then
            local tmp = {}
            for i = 1, limit do
                tmp[i] = result[i]
            end
            result = tmp
        end
        
        return result
    end,
    
    ---Get memory statistics for display
    ---@return table Memory statistics
    get_memory_stats = function(self)
        local current_memory = collectgarbage("count") * 1024 -- KB to bytes
        
        -- Calculate trends if we have snapshots
        local memory_change = 0
        local change_rate = 0
        
        if #self.memory_snapshots > 1 then
            local newest = self.memory_snapshots[1]
            local oldest = self.memory_snapshots[#self.memory_snapshots]
            
            memory_change = newest.total_memory - oldest.total_memory
            local time_diff = (newest.timestamp - oldest.timestamp) / 1000 -- seconds
            if time_diff > 0 then
                change_rate = memory_change / time_diff -- bytes per second
            end
        end
        
        -- Prepare memory history for chart
        local memory_history = {}
        for i = #self.memory_snapshots, 1, -1 do -- Oldest to newest
            table.insert(memory_history, self.memory_snapshots[i].total_memory / 1024 / 1024) -- Convert to MB
        end
        
        return {
            current_memory = current_memory,
            memory_mb = current_memory / 1024 / 1024, -- Convert to MB
            snapshots = self.memory_snapshots,
            memory_change = memory_change,
            change_rate = change_rate,
            memory_history = memory_history
        }
    end,
    
    ---Reset all metrics
    reset = function(self)
        self.metrics = {}
        self.active_metrics = {}
        self.history = {}
        self.memory_snapshots = {}
        self.num_metrics = 0
        self.last_cleanup_time = core.game_time()
        
        -- Force immediate garbage collection
        collectgarbage("collect")
    end,
    
    ---Profile a function execution and return its result
    ---@param func function Function to profile
    ---@param name string Metric name
    ---@param category string|nil Category (defaults to "general")
    ---@param ... any Arguments to pass to the function
    ---@return boolean, any Whether the function executed successfully, and the result
    profile_function = function(self, func, name, category, ...)
        if not self.config.enabled then
            -- Execute function without profiling
            return FS.error_handler:safe_execute(func, category .. "." .. name, ...)
        end
        
        -- Start timing
        self:start(name, category)
        
        -- Execute function with error handling
        local success, result = FS.error_handler:safe_execute(func, category .. "." .. name, ...)
        
        -- Stop timing
        self:stop(name, category, success)
        
        return success, result
    end,
    
    -- Internal: Create a new metric
    ---@private
    _create_metric = function(self, key, name, category)
        self.metrics[key] = {
            name = name,
            category = category,
            count = 0,
            total_time = 0,
            min_time = math.huge,
            max_time = 0,
            last_time = 0,
            last_timestamp = 0,
            created_at = core.game_time(),
            warning_threshold = self.config.default_warning_threshold,
            alert_threshold = self.config.default_alert_threshold
        }
        
        -- Initialize history for this metric
        self.history[key] = {}
        
        -- Increment metric count
        self.num_metrics = self.num_metrics + 1
    end,
    
    -- Internal: Update metric with new measurement
    ---@private
    _update_metric = function(self, key, duration, success, timestamp)
        local metric = self.metrics[key]
        if not metric then return end
        
        -- Update metrics
        metric.count = metric.count + 1
        metric.total_time = metric.total_time + duration
        metric.min_time = math.min(metric.min_time, duration)
        metric.max_time = math.max(metric.max_time, duration)
        metric.last_time = duration
        metric.last_timestamp = timestamp
        
        -- Update history
        local history = self.history[key]
        table.insert(history, 1, duration) -- Add at beginning for newest first
        
        -- Limit history size
        if #history > self.config.history_size then
            table.remove(history)
        end
    end,
    
    -- Internal: Cleanup old or unused metrics
    ---@private
    _cleanup_metrics = function(self)
        -- Only clean if we have too many metrics
        if self.num_metrics <= self.config.max_metrics then
            return
        end
        
        -- Get current time
        local current_time = core.game_time()
        
        -- Find metrics to remove (oldest and least used)
        local metrics_to_check = {}
        for key, metric in pairs(self.metrics) do
            table.insert(metrics_to_check, {
                key = key,
                age = current_time - metric.created_at,
                last_used = current_time - metric.last_timestamp,
                count = metric.count
            })
        end
        
        -- Sort by least recently used
        table.sort(metrics_to_check, function(a, b)
            return a.last_used > b.last_used
        end)
        
        -- Remove oldest until we're back under the limit
        local num_to_remove = self.num_metrics - self.config.max_metrics
        for i = 1, num_to_remove do
            local metric_info = metrics_to_check[i]
            if metric_info then
                self.metrics[metric_info.key] = nil
                self.history[metric_info.key] = nil
            end
        end
        
        -- Update count
        self.num_metrics = self.num_metrics - num_to_remove
    end
}

-- Backward compatibility with external profiler
---@type profiler
local external_profiler_compat = {
    start = function(key)
        FS.profiler:start(key, "external")
    end,
    
    stop = function(key, is_failed)
        FS.profiler:stop(key, "external", not is_failed)
    end
}

-- Return profiler compatibility layer
return external_profiler_compat