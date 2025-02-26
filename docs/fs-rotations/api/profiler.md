# Performance Metrics System

The FS Rotations performance metrics system provides comprehensive tracking, analysis, and visualization of function execution times and memory usage. It helps identify performance bottlenecks, memory leaks, and other performance issues.

## Basic Usage

```lua
-- Start timing an operation
FS.profiler:start("my_operation", "my_category")

-- Perform the operation
local result = do_something()

-- Stop timing and record
FS.profiler:stop("my_operation", "my_category")

-- Profile a function and get its result in one step
local success, result = FS.profiler:profile_function(function()
    return do_something_complex()
end, "complex_operation", "my_category")

-- Take a memory snapshot
FS.profiler:capture_memory_snapshot()

-- Reset all metrics
FS.profiler:reset()
```

## Key Features

### Performance Timing and Analysis

- Track function execution times with microsecond precision
- Categorize metrics for easier analysis
- Calculate min/max/avg execution times
- Maintain historical data for trend analysis
- Set thresholds for warning and alert conditions

### Memory Usage Tracking

- Monitor memory consumption over time
- Track memory allocation trends
- Identify potential memory leaks
- View object counts by type
- Visualize memory usage patterns

### Visualization and Reporting

- Color-coded metrics table based on thresholds
- Interactive metric selection for detailed analysis
- Line charts for execution time history
- Memory usage trend visualization
- Configurable filters and sorting options

### Memory Management

- Auto-cleanup of old metrics
- Configurable history size
- Light memory footprint with efficient storage
- Selective metric tracking based on importance

## Core Functions

### Performance Timing

```lua
---Start timing a specific operation
---@param name string Metric name
---@param category string|nil Category (defaults to "general")
FS.profiler:start(name, category)

---End timing for an operation and record the result
---@param name string Metric name
---@param category string|nil Category (defaults to "general")
---@param success boolean|nil Was the operation successful (defaults to true)
---@return number Duration in milliseconds
FS.profiler:stop(name, category, success)

---Profile a function execution and return its result
---@param func function Function to profile
---@param name string Metric name
---@param category string|nil Category (defaults to "general")
---@param ... any Arguments to pass to the function
---@return boolean, any Whether the function executed successfully, and the result
FS.profiler:profile_function(func, name, category, ...)
```

### Memory Tracking

```lua
---Take a snapshot of current memory usage
---@return memory_snapshot Snapshot of memory state
FS.profiler:capture_memory_snapshot()

---Get memory statistics for display
---@return table Memory statistics including current usage and trends
FS.profiler:get_memory_stats()
```

### Data Access and Management

```lua
---Get metrics for display, filtered and sorted
---@param category string|nil Filter by category
---@param sort_by string|nil Sort by field (count, total_time, avg_time, max_time)
---@param limit number|nil Maximum number of results
---@return table Metrics for display
FS.profiler:get_metrics_for_display(category, sort_by, limit)

---Set custom thresholds for a metric
---@param name string Metric name
---@param category string|nil Category (defaults to "general")
---@param warning_threshold number|nil Warning threshold in ms
---@param alert_threshold number|nil Alert threshold in ms
FS.profiler:set_thresholds(name, category, warning_threshold, alert_threshold)

---Reset all metrics
FS.profiler:reset()
```

## Configuration Options

The profiler has several configurable parameters:

| Setting | Description | Default |
|---------|-------------|---------|
| enabled | Enable or disable profiling | true |
| max_metrics | Maximum metrics to store | 100 |
| history_size | Number of historical points to keep | 60 |
| auto_clean_interval | Seconds between auto-cleanup | 300 |
| default_alert_threshold | Default alert threshold (ms) | 100 |
| default_warning_threshold | Default warning threshold (ms) | 50 |

These can be configured through the UI or directly in code:

```lua
FS.profiler.config.max_metrics = 200
FS.profiler.config.history_size = 120
```

## Data Structures

```lua
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
```

## Best Practices

1. **Use Meaningful Categories**
   ```lua
   -- Group related functions under common categories
   FS.profiler:start("get_single_target", "heal_engine.target_selection")
   FS.profiler:start("get_tank_target", "heal_engine.target_selection")
   ```

2. **Profile Critical Paths**
   ```lua
   -- Focus on performance-critical or frequently called functions
   FS.profiler:start("damage_calculation", "combat")
   ```

3. **Set Custom Thresholds for Important Operations**
   ```lua
   -- Set stricter thresholds for time-sensitive operations
   FS.profiler:set_thresholds("spell_queue", "core", 5, 20) -- warning at 5ms, alert at 20ms
   ```

4. **Take Regular Memory Snapshots**
   ```lua
   -- Capture before and after major operations to detect leaks
   FS.profiler:capture_memory_snapshot()
   ```

5. **Disable in Production if Needed**
   ```lua
   -- Disable for performance-critical scenarios
   FS.profiler.config.enabled = false
   ```

## UI Integration

The profiler UI provides:

1. **Settings Panel**
   - Enable/disable profiling
   - Configure storage limits and thresholds
   - Trigger manual memory snapshots
   - Reset all metrics

2. **Metrics Table**
   - Color-coded by execution time
   - Sortable by various metrics
   - Filterable by category
   - Selectable for detailed view

3. **Detailed Metric View**
   - Comprehensive statistics
   - Execution time history chart
   - Min/max/avg time analysis
   - Last execution details

4. **Memory Analysis**
   - Current memory usage
   - Memory consumption trend
   - Growth/shrink rate
   - Historical memory usage chart

## Compatibility with External Profiler

For backward compatibility with code using the external profiler module:

```lua
---@type profiler
local profiler = require("common/modules/profiler")

-- Still works with FS.profiler in the background
profiler.start("my_operation")
profiler.stop("my_operation")
```