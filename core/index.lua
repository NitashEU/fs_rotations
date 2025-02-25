-- Load core modules in proper order
require("core/api")
require("core/config")        -- Load centralized configuration first
require("core/humanizer")
require("core/menu")
require("core/settings")
require("core/variables")
require("core/error_handler")
require("core/validator")     -- Load validation library after error_handler
require("core/profiler")      -- Load performance metrics system
require("core/object_pool")   -- Load object pooling system for memory management

-- Initialize modules table
FS.modules = {}
