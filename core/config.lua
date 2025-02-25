--- Centralized configuration module for FS Rotations
--- This module provides a single source of truth for all configuration values
--- Used to centralize magic numbers, constants, and default settings
---
--- Features:
--- - Organizes configuration by module/feature
--- - Integrates with Sylvanas menu system for persistence
--- - Provides menu element lookup by configuration path
--- - Makes tuning and performance optimization easier

-- Mapping of config paths to menu element getters
-- This connects configuration paths to actual menu UI elements
local menu_mapping = {
    -- Core humanizer settings
    ["core.humanizer.min_delay"] = function() return FS.menu.min_delay:get() end,
    ["core.humanizer.max_delay"] = function() return FS.menu.max_delay:get() end,
    ["core.humanizer.jitter.enabled"] = function() return FS.menu.humanizer_jitter.enable_jitter:get_state() end,
    ["core.humanizer.jitter.base"] = function() return FS.menu.humanizer_jitter.base_jitter:get() end,
    ["core.humanizer.jitter.latency"] = function() return FS.menu.humanizer_jitter.latency_jitter:get() end,
    ["core.humanizer.jitter.max"] = function() return FS.menu.humanizer_jitter.max_jitter:get() end,
    
    -- Error handler settings
    ["core.error_handler.max_errors"] = function() return FS.menu.error_handler.max_errors_slider:get() end,
    ["core.error_handler.cooldown_period"] = function() return FS.menu.error_handler.cooldown_slider:get() end,
    
    -- Heal engine settings
    ["heal_engine.logging.debug_enabled"] = function() 
        return FS.modules.heal_engine and FS.modules.heal_engine.menu and 
               FS.modules.heal_engine.menu.logging.enable_debug:get_state() 
    end,
    
    ["heal_engine.logging.health.threshold"] = function() 
        return FS.modules.heal_engine and FS.modules.heal_engine.menu and 
               FS.modules.heal_engine.menu.logging.health.threshold:get() 
    end,
    
    ["heal_engine.logging.dps.threshold"] = function() 
        return FS.modules.heal_engine and FS.modules.heal_engine.menu and 
               FS.modules.heal_engine.menu.logging.dps.threshold:get() 
    end,
    
    -- More mappings would be added as needed for other configuration paths
}

-- Default configuration values (used as fallbacks when menu elements are unavailable)
local default_config = {
    -- Core settings
    core = {
        humanizer = {
            min_delay = 50,            -- Default minimum delay in ms
            max_delay = 150,           -- Default maximum delay in ms
            latency_factor = 1.5,      -- Multiplier for network latency
            latency_cap = 200,         -- Maximum latency to consider in ms
            jitter = {
                enabled = true,        -- Enable humanizer jitter by default
                base = 0.1,            -- Base jitter factor (10%)
                latency = 0.2,         -- Latency-based jitter factor (20%)
                max = 0.3              -- Maximum jitter factor (30%)
            },
        },
        error_handler = {
            max_errors = 5,            -- Maximum errors before disabling a component
            cooldown_period = 60,      -- Seconds to disable after repeated errors
            error_window = 300,        -- Time window (seconds) for error counting
        },
    },
    
    -- Heal engine settings
    heal_engine = {
        history = {
            max_records = 100,         -- Maximum health records per unit
            record_interval = 250,     -- Minimum time between records in ms
            significant_change = 0.01,  -- Health change threshold (1% of max health)
        },
        tracking = {
            windows = {
                short = 1,             -- Short tracking window in seconds
                medium = 5,            -- Medium tracking window in seconds
                long = 10,             -- Long tracking window in seconds
                extended = 15,         -- Extended tracking window in seconds
            }
        },
        caching = {
            lifetime = 2000,           -- Cache lifetime in ms
            cleanup_interval = 5000,   -- Cleanup interval in ms
        },
        logging = {
            debug_enabled = false,     -- Debug logging disabled by default
            health = {
                threshold = 0.05,      -- Health change logging threshold (5%)
                show_cleanup = false   -- Don't show cleanup messages by default
            },
            dps = {
                threshold = 0.05,      -- DPS change logging threshold (5%)
                show_fight = false,    -- Don't show fight DPS by default
                show_windows = false   -- Don't show window DPS by default
            }
        },
        pooling = {
            initial_size = 100,        -- Initial pool size for health records
            expected_units = 40,       -- Maximum expected raid size
        }
    }
}

-- Helper function to split path string into components
---@param path string The dot-separated path
---@return string[] Array of path components
local function split_path(path)
    local parts = {}
    for part in string.gmatch(path, "[^%.]+") do
        table.insert(parts, part)
    end
    return parts
end

-- Helper function to get nested table value by path
---@param tbl table The table to search in
---@param path string[] Array of keys forming the path
---@return any value The value at the specified path or nil if not found
local function get_nested(tbl, path)
    local current = tbl
    for _, key in ipairs(path) do
        if type(current) ~= "table" then
            return nil
        end
        current = current[key]
        if current == nil then
            return nil
        end
    end
    return current
end

-- Configuration module interface
local config = {
    -- Get a configuration value by path with optional default
    -- First tries to get the value from a mapped menu element
    -- Falls back to default config if no menu element is found
    -- @param path string Dot-notation path (e.g. "heal_engine.history.max_records")
    -- @param default any Optional default value if not found
    -- @return any The configuration value
    get = function(self, path, default)
        -- First try to get the value from the menu system
        local getter = menu_mapping[path]
        if getter then
            -- Menu element found, use its value
            local success, result = pcall(getter)
            if success and result ~= nil then
                return result
            end
        end
        
        -- If no menu element or an error occurred, fall back to default config
        local parts = split_path(path)
        local result = get_nested(default_config, parts)
        
        -- Return the provided default if still not found
        return result or default
    end,
    
    -- Register a new menu mapping
    -- @param path string Configuration path
    -- @param getter function Function that returns the menu element's value
    -- @return boolean Success
    register_menu_mapping = function(self, path, getter)
        if type(path) == "string" and type(getter) == "function" then
            menu_mapping[path] = getter
            return true
        end
        return false
    end,
    
    -- Check if a path has a menu mapping
    -- @param path string Configuration path
    -- @return boolean Has mapping
    has_menu_mapping = function(self, path)
        return menu_mapping[path] ~= nil
    end,
    
    -- Get default value
    -- @param path string Configuration path
    -- @param default any Optional default if not found in defaults
    -- @return any Default value
    get_default = function(self, path, default)
        local parts = split_path(path)
        local result = get_nested(default_config, parts)
        return result or default
    end,
    
    -- Get all menu mappings
    -- @return table Menu mappings
    get_menu_mappings = function(self)
        local result = {}
        for path, _ in pairs(menu_mapping) do
            table.insert(result, path)
        end
        return result
    end,
    
    -- Register multiple menu mappings at once
    -- @param mappings table Table of path to getter mappings
    -- @return number Number of successful registrations
    register_many = function(self, mappings)
        local count = 0
        for path, getter in pairs(mappings) do
            if self:register_menu_mapping(path, getter) then
                count = count + 1
            end
        end
        return count
    end
}

-- Expose the configuration module
FS.config = config

return config