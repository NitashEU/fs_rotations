-- Load core modules in proper order
require("core/api")
require("core/config")        -- Load centralized configuration first
require("core/humanizer")
require("core/menu")
require("core/settings")      -- Legacy settings system
require("core/variables")
require("core/error_handler")
require("core/validator")     -- Load validation library after error_handler
require("core/profiler")      -- Load performance metrics system
require("core/object_pool")   -- Load object pooling system for memory management
require("core/settings_manager")  -- Centralized settings manager
require("core/settings_interface") -- Interface between legacy and centralized settings
require("core/settings_validation") -- Validation for settings
require("core/settings_menu")      -- UI for centralized settings
require("core/module_interface")   -- Module interface standardization

-- Initialize settings system
FS.settings_manager:init()
FS.settings_interface:init()
FS.settings_validation:init()

-- Initialize modules table
FS.modules = {}
