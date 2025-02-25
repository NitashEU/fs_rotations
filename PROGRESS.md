# FS Rotations Implementation Roadmap

This document outlines a phased approach to implementing the improvements identified in FINDINGS.md.

## Phase 1: Foundation Improvements (1-2 weeks)

### 1. Standardized Validation Library

- [x] Create centralized validation module with common functions
  - Created core/validator.lua with comprehensive validation functions
  - Implemented component auto-detection for better error reporting
  - Added special validation functions for WoW-specific concepts (game objects, percent thresholds)
- [x] Add comprehensive documentation for all validation functions
  - Added detailed docs/fs-rotations/api/validation.md with examples and best practices
  - Included thorough inline documentation for each function
- [x] Integrate with error_handler
  - All validation functions automatically report errors to error_handler
  - Used consistent component naming convention for better error tracking
- [x] Apply to heal_engine components first
  - Refactored heal_engine.get_single_target to use the validation library
  - Updated holy_shock.lua to demonstrate class implementation usage

```lua
-- Example implementation sketch
FS.validator = {
    check_number = function(value, name, min, max)
        if type(value) ~= "number" then
            return false, name .. " must be a number"
        end
        if min and value < min then
            return false, name .. " must be at least " .. min
        end
        if max and value > max then
            return false, name .. " must be at most " .. max
        end
        return true
    end,

    check_string = function(value, name, allowed_values)
        if type(value) ~= "string" then
            return false, name .. " must be a string"
        end
        if allowed_values then
            local found = false
            for _, allowed in ipairs(allowed_values) do
                if value == allowed then
                    found = true
                    break
                end
            end
            if not found then
                return false, name .. " must be one of: " .. table.concat(allowed_values, ", ")
            end
        end
        return true
    end,

    check_table = function(value, name)
        if type(value) ~= "table" then
            return false, name .. " must be a table"
        end
        return true
    end,

    check_function = function(value, name)
        if type(value) ~= "function" then
            return false, name .. " must be a function"
        end
        return true
    end,

    check_boolean = function(value, name)
        if type(value) ~= "boolean" and value ~= nil then
            return false, name .. " must be a boolean or nil"
        end
        return true
    end,

    validate_params = function(params, validations)
        for name, validation in pairs(validations) do
            local success, error_message = validation(params[name], name)
            if not success then
                return false, error_message
            end
        end
        return true
    end
}
```

### 2. Enhanced Error Handling

- [x] Add stack trace capture to error_handler.record
  - Added detailed stack trace capture using debug.traceback
  - Created structured error_instance class with message, stack, timestamp, and game state
  - Implemented filtering to remove internal error handling lines from stack trace
- [x] Implement progressive backoff for circuit breaker
  - Added exponential backoff based on error frequency
  - Created configurable base and maximum cooldown parameters
  - Implemented formula: base_cooldown \* 2^(excess_errors)
- [x] Create advanced error visualization in menu
  - Designed color-coded error list with status indicators
  - Added detailed error view with timestamp, message, and stack trace
  - Implemented game state context display (player, target, combat status)
  - Created clickable error entries for easy navigation
- [x] Add component status indicators
  - Added ⚠️ for active errors and ⛔ for disabled components
  - Included time-ago display for error occurrence
  - Added status indicators showing remaining disable time
  - Created comprehensive documentation in docs/fs-rotations/api/error-handler.md

### 3. Performance Metrics

- [x] Create performance tracking module
  - Developed comprehensive `core/profiler.lua` with LuaDoc annotations
  - Implemented function timing with category support
  - Added memory usage tracking and object counting
  - Created history tracking for trend analysis
  - Maintained backward compatibility with external profiler
- [x] Add instrumentation to critical paths
  - Added profiling to heal_engine on_update and on_fast_update
  - Profiled individual components like cache management and health data collection
  - Implemented automated periodic memory snapshots
  - Used both direct profiling and wrapper-based profiling approaches
- [x] Implement configurable logging thresholds
  - Added warning and alert thresholds for execution times
  - Implemented configurable history size and cleanup intervals
  - Created selective metric tracking to manage memory usage
  - Added auto-cleanup for old metrics to prevent unbounded growth
- [x] Add visualization for performance metrics
  - Created comprehensive UI with filtering and sorting options
  - Implemented color-coded metrics table for quick assessment
  - Added detailed metric view with statistics
  - Created interactive charts for execution time and memory usage
  - Implemented memory trend analysis with growth rate calculation

## Phase 2: Core System Improvements (2-3 weeks)

### 1. Memory Management Enhancements

- [x] Add memory tracking to object pools
  - Developed comprehensive `core/object_pool.lua` module
  - Implemented memory usage estimation for different object types
  - Added tracking for creation, acquisition, and recycling of objects
  - Created object lifecycle tracking with hit/miss metrics
  - Built memory leak detection functionality
- [x] Implement selective cache invalidation
  - Added configurable cache lifetime settings
  - Implemented adaptive cleanup based on recycle rates
  - Created smart cache eviction for efficiency
  - Added pool-specific cleanup intervals
  - Built global cleanup system for coordinated memory management
- [x] Create memory usage visualization
  - Implemented sortable pool list with health indicators
  - Created detailed pool statistics views
  - Added memory leak detection indicators
  - Implemented memory efficiency metrics
  - Designed color-coded health indicators for quick assessment
- [x] Add thresholds for adaptive object pooling
  - Created configurable max pool sizes
  - Implemented minimum recycle rate thresholds
  - Added smart pre-allocation settings
  - Developed dynamic pool size adjustment
  - Built efficiency tracking for adaptive cleanup

### 2. Centralized Settings System

- [x] Design unified settings interface
  - Created `core/settings_manager.lua` with comprehensive settings registry
  - Implemented type validation, change notifications, and default values
  - Built extensible design with support for multiple setting types
  - Added documentation in `docs/fs-rotations/api/settings-manager.md`
- [x] Implement setting change notifications
  - Added observer pattern for setting changes
  - Created callback registry for change listeners
  - Implemented notification system with error handling
  - Built timer-based change detection for menu elements
- [x] Add validation for all settings
  - Integrated with existing validator library
  - Added type-specific validation rules
  - Created real-time validation for menu elements
  - Built UI for visualizing settings and validation status
  - Maintained backward compatibility with existing settings system

### 3. Module Interface Standardization

- [x] Define required interfaces for all module types
  - Created core_module, spec_module, ui_module, and data_module interfaces
  - Implemented comprehensive validation for each interface type
  - Added support for required and optional fields with specific validation rules
  - Built validation system using FS.validator for consistent error reporting
- [x] Create validation for module interfaces
  - Implemented field-level validation with proper error messages
  - Added support for different validation types (function, table, number)
  - Added special handling for deprecated fields with warnings
  - Created automatic documentation generation for interfaces
- [x] Document interface requirements
  - Added comprehensive docs/fs-rotations/plugin/architecture/module-interfaces.md
  - Included examples for each interface type
  - Added best practices and extension guidelines
  - Created detailed API documentation for validation system
- [x] Update module loading to use interface validation
  - Enhanced spec_module_registry.lua with interface validation
  - Updated load_required_modules.lua to validate core modules
  - Improved error reporting with component context
  - Maintained backward compatibility with existing modules
  - Fixed type annotations for proper diagnostics integration

## Phase 3: Advanced Architecture (3-4 weeks)

### 1. Event System

- [x] Design publish/subscribe system
  - Created comprehensive event system with type-safe interfaces
  - Implemented hierarchical event patterns using dot notation
  - Added support for prioritized event handlers
  - Designed clear event data structure with consistent fields
  - Created one-time event subscription capability
- [x] Implement event bus
  - Developed core/events.lua with full pub/sub implementation
  - Added error handling via error_handler integration
  - Implemented proper listener management with unique IDs
  - Created source tracking for event emission
  - Added safety mechanisms for callback execution
- [x] Create debugging tools for event tracing
  - Implemented comprehensive events_debug.lua debug UI
  - Created event history tracking with timestamp and source information
  - Added test event generation capabilities
  - Built interactive UI for event monitoring and listener inspection
  - Integrated with settings system for enabling/disabling debugging
- [x] Convert critical components to use events
  - Updated on_update.lua to emit standard events
  - Integrated events with module loading for load notifications
  - Added combat state change detection with event emission
  - Created render events in on_render.lua
  - Documented standard event types and naming conventions

### 2. Dependency Injection

- [ ] Create dependency container
- [ ] Implement module factory system
- [ ] Add dependency resolution
- [ ] Convert existing modules to use DI

### 3. Consolidated Module Registration

- [ ] Merge spec registration systems
- [ ] Implement dependency-aware loading
- [ ] Add proper error reporting
- [ ] Create visualization for module dependencies

## Phase 4: Specialization Improvements (4-6 weeks)

### 1. Apply Patterns to Holy Paladin

- [ ] Update spell implementations with validation
- [ ] Convert to use events for communication
- [ ] Implement memory optimization patterns
- [ ] Add comprehensive documentation

### 2. Create Template for New Specializations

- [ ] Design modular architecture for class implementations
- [ ] Create documentation for new specialization development
- [ ] Implement automatic validation for new specializations
- [ ] Develop testing framework for new specs

### 3. Unified Settings UI

- [ ] Standardize menu rendering
- [ ] Add tooltips and help text
- [ ] Implement settings search
- [ ] Create visual themes for menus

## Future Considerations

### 1. Testing Framework

- Investigate options for simulating WoW environment
- Create unit testing framework for core components
- Implement integration testing for specializations

### 2. Profiling Tools

- Develop in-game profiling visualization
- Create memory usage tracking tools
- Implement automatic performance optimization suggestions

### 3. Migration to Object-Oriented Structure

- Investigate feasibility of full OO refactoring
- Create proof of concept for high-performance OO design
- Develop migration plan for existing components
