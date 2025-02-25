-- Load core modules in proper order
require("core/api")
require("core/config")        -- Load centralized configuration first
require("core/humanizer")
require("core/menu")
require("core/settings")
require("core/variables")
require("core/error_handler")

-- Initialize modules table
FS.modules = {}
