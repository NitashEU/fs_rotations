# Error Handling System

The FS Rotations error handling system provides comprehensive error tracking, reporting, and recovery mechanisms. It captures contextual information about errors, implements progressive backoff for problematic components, and provides a user interface for error diagnosis.

## Basic Usage

```lua
-- Record an error
FS.error_handler:record("my_component.function_name", "Error message")

-- Check if a component is allowed to run
if FS.error_handler:can_run("my_component.function_name") then
    -- Component is allowed to run
end

-- Safe execution with automatic error handling
local success, result = FS.error_handler:safe_execute(function()
    -- Your code here
    return "result"
end, "my_component.function_name")

if success then
    -- Use result
else
    -- Handle failure
end
```

## Key Features

### Error Recording with Context

Each error is recorded with:
- Component name and error message
- Stack trace for detailed debugging
- Timestamp for chronological tracking
- Game state context (player, target, combat status)

### Progressive Backoff Circuit Breaker

The system disables problematic components with progressive backoff:
- Initial cooldown period based on base_cooldown setting
- Exponential increase for frequent errors
- Cap at max_cooldown setting

### Error Visualization

The UI provides:
- Color-coded error list with status indicators
- Detailed view of selected errors
- Stack trace examination
- Game state context display

### Performance Optimizations

- Cached disabled component list for fast lookups
- Selective recording of game state
- Limit on stored error instances
- Occasional cleanup of disabled components cache

## Core Functions

### Error Recording

```lua
---Record an error and determine if component should be disabled
---@param component string Name of the component (module/function)
---@param error_msg string Error message
---@param stack_level number|nil Stack level for trace capture (default: 3)
---@return boolean If false, component should be temporarily disabled
FS.error_handler:record(component, error_msg, stack_level)
```

### Component Status Check

```lua
---Check if component is allowed to run
---@param component string Name of the component
---@return boolean True if allowed to run
FS.error_handler:can_run(component)
```

### Safe Execution

```lua
---Safe execute function with error handling
---@param func function Function to execute
---@param component string Component name for error reporting
---@param ... any Arguments to pass to the function
---@return boolean success Whether the function executed successfully
---@return any result The result from the function if successful
FS.error_handler:safe_execute(func, component, ...)
```

### Error Reporting

```lua
---Get active errors for UI display
---@param max_count number|nil Maximum number of errors to return
---@return table[] List of errors for display
FS.error_handler:get_errors_for_display(max_count)

---Get detailed error information for a component
---@param component string Component name
---@return error_data|nil Error data or nil if not found
FS.error_handler:get_error_details(component)
```

## Configuration Options

The error handler has several configurable parameters:

| Setting | Description | Default |
|---------|-------------|---------|
| max_errors | Maximum errors before disabling a component | 5 |
| base_cooldown | Base seconds to disable a component | 10 |
| max_cooldown | Maximum cooldown in seconds | 300 |
| error_window | Time window for counting errors (seconds) | 300 |
| max_stored_instances | Maximum stored instances per component | 50 |
| capture_state | Whether to capture game state on error | true |

These can be configured through the UI or directly in code:

```lua
FS.error_handler.max_errors = 3
FS.error_handler.base_cooldown = 5
```

## Error Data Structure

```lua
---@class error_instance
---@field message string Error message
---@field stack string Stack trace
---@field timestamp number When the error occurred
---@field game_state table|nil Captured game state at error time

---@class error_data
---@field instances error_instance[] List of error instances
---@field component string Component that generated the error
---@field disabled_until number Timestamp until which the component is disabled
---@field last_reported number When the error was last reported to the user
```

## Best Practices

1. **Use safe_execute for Critical Operations**
   ```lua
   local success, player = FS.error_handler:safe_execute(function()
       return core.object_manager.get_local_player()
   end, "core.get_local_player")
   
   if not success or not player then
       -- Handle failure
   end
   ```

2. **Provide Meaningful Component Names**
   - Use dot notation to represent hierarchy: "module.submodule.function"
   - Be consistent with naming to enable proper parent-child error propagation

3. **Check Component Status Before Expensive Operations**
   ```lua
   if FS.error_handler:can_run("my_component.expensive_operation") then
       -- Perform expensive operation
   end
   ```

4. **Implement Fallback Behavior**
   ```lua
   local success, result = FS.error_handler:safe_execute(function()
       -- Attempt optimal implementation
   end, "component.optimal")
   
   if not success then
       -- Use fallback implementation
   end
   ```

5. **Reset for Testing**
   ```lua
   -- During development/testing
   FS.error_handler:reset()  -- Clear all error history
   ```

## UI Integration

The error handling UI provides:

1. **Settings Panel**
   - Configure max errors threshold
   - Set base and max cooldown periods
   - Toggle game state capture
   - Control stack trace visibility

2. **Error List**
   - Color-coded status indicators (⚠️ for active, ⛔ for disabled)
   - Error counts and timestamps
   - Clickable entries for detailed view

3. **Detail View**
   - Error message and timestamp
   - Stack trace examination (when enabled)
   - Game state context (player, target, combat status)