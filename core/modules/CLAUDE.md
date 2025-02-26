# Core Modules Implementation Guidelines

## Implementation Constraints
- Shares memory with WoW client and other plugins - memory management is critical
- No automated testing - validate through manual testing and user feedback
- Performance-critical code that runs in game loop - optimize accordingly
- Maintain compatibility with _api interfaces (do not modify these)

## Module Structure
- Implement `index.lua` as the main entry point
- Expose a consistent interface for all modules
- Document public API with type annotations
- Provide clear error handling and feedback

## Interface Requirements
```lua
---@class base_module
---@field on_update function() Update callback
---@field on_fast_update function()? Optional high-frequency update
---@field on_render function()? Optional render callback
---@field on_render_menu function()? Optional menu render callback
```

## Performance Guidelines
- Optimize update frequencies based on operation type
- Cache frequently accessed values (positions, distances, etc.)
- Use appropriate data structures for lookups
- Avoid unnecessary computations in time-critical paths
- Implement object pooling for frequently created/destroyed objects
- Implement cleanup procedures to prevent memory leaks
- Set appropriate cache lifetimes based on data volatility (e.g., 200ms for positions)
- Refresh caches at regular intervals or when data changes

## Error Handling and Validation
- Use FS.validator for ALL input parameter validation
- Document ALL functions with LuaDoc annotations (---@param and ---@return)
- Use clear component names for all error reporting
- Follow the validation order pattern:
  1. Required parameters first
  2. Type and range validation
  3. Default values for optional parameters
  4. Validation of optional parameters
- Provide meaningful fallback behavior for error cases
- Log errors through the error_handler system
- Include early exit conditions for invalid states

## Integration Standards
- Avoid direct dependencies where possible
- Use interfaces for component communication
- Document all dependencies
- Provide version compatibility information