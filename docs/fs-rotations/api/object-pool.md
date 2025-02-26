# Object Pooling System

The object pooling system provides efficient memory management by reusing objects rather than creating and destroying them repeatedly. This reduces garbage collection pressure and improves performance in the WoW environment where memory is shared between processes.

## Basic Usage

```lua
-- Create a pool for health value objects
local health_pool = FS.object_pool:create("health_values", 
    function() return {} end,  -- Create function
    function(obj) for k in pairs(obj) do obj[k] = nil end end, -- Reset function
    { 
        initial_size = 50,
        object_type = "health_value" 
    }
)

-- Get an object from the pool
local health_obj = health_pool:acquire()
health_obj.health = 100
health_obj.max_health = 100
health_obj.time = core.game_time()

-- Use the object...

-- Return it to the pool when done
health_pool:release(health_obj)
```

## Key Features

### Object Lifecycle Management

- Pre-allocation of objects to reduce allocation during gameplay
- Automatic recycling of objects when they're no longer needed
- Efficient object reuse with customizable reset functions
- Automatic pool size management based on usage patterns

### Memory Usage Tracking

- Track memory usage of pooled objects
- Detect potential memory leaks
- Monitor object creation and recycling rates
- Visualize memory consumption patterns

### Performance Optimization

- Configurable pool sizes based on expected usage
- Automatic cleanup of unused objects
- Hit rate tracking for pool efficiency
- Responsive to memory pressure

### Leak Detection

- Identify objects that are acquired but never released
- Track peak usage versus current acquired objects
- Monitor unusual object acquisition patterns
- Alert on potential memory leaks

## Core Functions

### Pool Creation and Management

```lua
---Create a new object pool
---@param name string Unique name for the pool
---@param create_fn function Function to create a new object
---@param reset_fn function|nil Function to reset an object for reuse
---@param options object_pool_options|nil Pool configuration options
---@return object_pool The new object pool
FS.object_pool:create(name, create_fn, reset_fn, options)

---Get an existing pool by name
---@param name string Pool name
---@return object_pool|nil The pool object or nil if not found
FS.object_pool:get_pool(name)

---Update all pools
---@param current_time number Current game time
FS.object_pool:update(current_time)

---Clean up all pools
FS.object_pool:global_cleanup()
```

### Object Acquisition and Release

```lua
-- Instance methods on object_pool

---Get an object from the pool
---@return table An object (either from pool or newly created)
pool:acquire()

---Return an object to the pool
---@param obj table The object to return to the pool
pool:release(obj)

---Clean up excess objects in the pool
pool:cleanup()
```

### Statistics and Memory Analysis

```lua
---Get stats for all pools
---@param sort_by string|nil Field to sort by 
---@return table[] Array of pool stats
FS.object_pool:get_all_stats(sort_by)

---Get total memory estimation across all pools
---@return number Estimated memory usage in bytes
FS.object_pool:get_total_memory()

---Check for potential memory leaks
---@return table[] Array of pools with potential leaks
FS.object_pool:check_leaks()

---Estimate the size of a Lua value in bytes
---@param value any The value to estimate size for
---@param visited table|nil Table to track visited objects
---@return number Estimated size in bytes
FS.object_pool:estimate_size(value, visited)
```

## Configuration Options

The object pool system has several configurable parameters:

| Setting | Description | Default |
|---------|-------------|---------|
| enabled | Enable or disable pooling | true |
| default_max_size | Maximum objects per pool | 1000 |
| default_cleanup_interval | Seconds between cleanups | 60 |
| global_cleanup_interval | Seconds between global cleanups | 300 |
| check_leaks | Enable leak detection | true |
| debug | Enable debug logging | false |

Each pool can also be configured with its own options:

```lua
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
```

These can be configured through the UI or directly in code:

```lua
FS.object_pool.config.default_max_size = 500
FS.object_pool.config.check_leaks = true
```

## Object Pool Interface

```lua
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
```

## Best Practices

1. **Pre-allocate Appropriately**
   ```lua
   -- Pre-allocate based on expected peak usage
   local options = {
       initial_size = 50, -- Pre-create 50 objects
       max_size = 200     -- Keep up to 200 in the pool
   }
   ```

2. **Use Proper Reset Functions**
   ```lua
   -- Ensure objects are properly cleared before reuse
   local reset_fn = function(obj)
       -- Clear all fields
       for k in pairs(obj) do obj[k] = nil end
       -- Reset any non-table members
       obj.initialized = false
       obj.last_access = 0
   end
   ```

3. **Estimate Memory Usage**
   ```lua
   -- Provide custom memory estimation for complex objects
   local estimate_fn = function(obj)
       -- Base size + estimate of contained data
       return 40 + (obj.data and #obj.data * 8 or 0)
   end
   ```

4. **Monitor for Leaks**
   ```lua
   -- Check for leaks periodically
   local leaks = FS.object_pool:check_leaks()
   if #leaks > 0 then
       core.log_warning("Potential memory leaks detected")
       for _, leak in ipairs(leaks) do
           core.log_warning(leak.pool .. ": " .. leak.acquired .. " objects not released")
       end
   end
   ```

5. **Organize Pools by Object Type**
   ```lua
   -- Create separate pools for different object types
   local health_pool = FS.object_pool:create("health_values", create_health_fn)
   local position_pool = FS.object_pool:create("position_cache", create_position_fn)
   ```

## UI Integration

The object pool UI provides:

1. **Global Settings**
   - Enable/disable object pooling
   - Configure leak detection
   - Set global cleanup intervals
   - Force garbage collection

2. **Pool List**
   - Color-coded by health status
   - Sortable by various metrics
   - Memory usage display
   - Reuse efficiency metrics

3. **Detailed Pool View**
   - Usage statistics
   - Memory consumption
   - Efficiency metrics
   - Object lifecycle tracking

4. **Leak Detection**
   - Warning indicators for potential leaks
   - Object acquisition statistics
   - Peak usage comparison