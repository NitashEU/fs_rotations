# Core Modules Implementation Guidelines

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
- Cache frequently accessed values
- Use appropriate data structures for lookups
- Avoid unnecessary computations in time-critical paths
- Implement cleanup procedures to prevent memory leaks

## Error Handling
- Validate all input parameters
- Provide descriptive error messages
- Implement graceful fallbacks
- Log errors through appropriate channels

## Integration Standards
- Avoid direct dependencies where possible
- Use interfaces for component communication
- Document all dependencies
- Provide version compatibility information