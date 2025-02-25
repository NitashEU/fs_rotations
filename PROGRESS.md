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
- [ ] Add stack trace capture to error_handler.record
- [ ] Implement progressive backoff for circuit breaker
- [ ] Create basic error visualization in menu
- [ ] Add component status indicators

### 3. Performance Metrics
- [ ] Create performance tracking module
- [ ] Add instrumentation to critical paths
- [ ] Implement configurable logging thresholds
- [ ] Add visualization for performance metrics

## Phase 2: Core System Improvements (2-3 weeks)

### 1. Memory Management Enhancements
- [ ] Add memory tracking to object pools
- [ ] Implement selective cache invalidation
- [ ] Create memory usage visualization
- [ ] Add thresholds for adaptive object pooling

### 2. Centralized Settings System
- [ ] Design unified settings interface
- [ ] Implement setting change notifications
- [ ] Add validation for all settings
- [ ] Create migration system for legacy settings

### 3. Module Interface Standardization
- [ ] Define required interfaces for all module types
- [ ] Create validation for module interfaces
- [ ] Document interface requirements
- [ ] Update module loading to use interface validation

## Phase 3: Advanced Architecture (3-4 weeks)

### 1. Event System
- [ ] Design publish/subscribe system
- [ ] Implement event bus
- [ ] Create debugging tools for event tracing
- [ ] Convert critical components to use events

```lua
-- Example event system implementation
FS.events = {
    listeners = {},
    
    on = function(self, event_name, callback)
        self.listeners[event_name] = self.listeners[event_name] or {}
        table.insert(self.listeners[event_name], callback)
        return function() -- Return unsubscribe function
            self:off(event_name, callback)
        end
    end,
    
    off = function(self, event_name, callback)
        if not self.listeners[event_name] then return end
        for i, cb in ipairs(self.listeners[event_name]) do
            if cb == callback then
                table.remove(self.listeners[event_name], i)
                break
            end
        end
    end,
    
    emit = function(self, event_name, data)
        if not self.listeners[event_name] then return end
        for _, callback in ipairs(self.listeners[event_name]) do
            FS.error_handler:safe_execute(callback, data)
        end
    end,
    
    debug = {
        enabled = false,
        log = function(event_name, data)
            -- Log events when debugging is enabled
        end
    }
}
```

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