# Entry System Implementation Guidelines

## Implementation Constraints
- Shares memory with WoW client and other system components
- No automated testing - validate through manual testing and user feedback
- Performance optimization is critical for entry points and callbacks
- Maintain compatibility with _api interfaces (do not modify these)

## Callback Structure
- Register callbacks through appropriate entry points
- Implement all required callbacks in spec modules:
  - `on_update` - Main rotation logic
  - `on_render_menu` - Settings UI rendering
  - `on_render` - Visual elements display
- Check for callback existence before invocation
- Maintain performance through callback optimization

## Module Loading
- Use `load_spec_module.lua` for specialization loading
- Validate module configuration before loading
- Implement graceful error handling for invalid modules
- Document required interfaces for new modules

## Configuration Interfaces
- Implement module_config.lua interface for core modules
- Implement spec_config.lua interface for specializations
- Use strong type checking for all interfaces
- Document all required fields

## Error Handling and Validation
- Use FS.validator for ALL input parameter validation
- Document ALL functions with LuaDoc annotations (---@param and ---@return)
- Validate spec availability before loading
- Check for required modules and dependencies
- Provide clear error messages with specific component names
- Implement fallback behavior when appropriate
- Follow the standard validation pattern:
  1. Required parameter validation first
  2. Type and range validation next
  3. Set defaults for optional parameters
  4. Validate optional parameters

## Development Guidelines
- Test new modules in isolation before integration
- Maintain backward compatibility with existing modules
- Document all changes to interface contracts
- Follow established naming conventions for consistency