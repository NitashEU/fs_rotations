--- Heal Engine Core Module
--- Provides central module interface and core functionality

-- Export core module functions and properties
local core = {
    ---@type game_object[]
    units = {},
    ---@type game_object[]
    tanks = {},
    ---@type game_object[]
    healers = {},
    ---@type game_object[]
    damagers = {},
    ---@type table<game_object, { records: table, next_index: number, count: number, capacity: number }>
    health_values = {},
    ---@type table<game_object, { health: number, max_health: number, health_percentage: number, time: number }>
    current_health_values = {}
}

--- Initialize the heal engine module
function core.initialize()
    -- Log initialization
    core.log("Initializing heal engine module")
    
    -- Initialize module
    FS.modules.heal_engine = {
        --- Core functionality
        -- Re-export core interface
        units = core.units,
        tanks = core.tanks,
        healers = core.healers,
        damagers = core.damagers,
        health_values = core.health_values,
        current_health_values = core.current_health_values
    }
    
    -- Load module components
    -- Data management
    require("core/modules/heal_engine/data/storage")
    require("core/modules/heal_engine/data/cache")
    require("core/modules/heal_engine/data/collector")
    
    -- Analysis components
    require("core/modules/heal_engine/analysis/damage")
    
    -- Logging
    require("core/modules/heal_engine/logging/health")
    
    -- Combat state
    require("core/modules/heal_engine/core/state")
    
    -- Required original files
    require("core/modules/heal_engine/menu")
    require("core/modules/heal_engine/settings")
    require("core/modules/heal_engine/start")
    require("core/modules/heal_engine/reset")
    require("core/modules/heal_engine/target_selections/index")
    require("core/modules/heal_engine/on_update")
    
    -- Initialize object pools
    FS.modules.heal_engine.storage.initialize_pools()
    
    -- Log completion
    core.log("Heal engine module initialized successfully")
end

--- Log message with heal engine prefix
---@param message string Message to log
function core.log(message)
    if not message then return end
    core.log_debug("[Heal Engine] " .. tostring(message))
end

--- Log debug message if debug is enabled
---@param message string Debug message
function core.log_debug(message)
    if not message then return end
    if FS.modules.heal_engine.settings and FS.modules.heal_engine.settings.logging.is_debug_enabled() then
        core.log(message)
    end
end

-- Auto-initialize the module
core.initialize()

-- Return the core interface
return core