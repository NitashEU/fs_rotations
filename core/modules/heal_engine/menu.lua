local tag = "heal_engine_"
local name = "Heal Engine"

---@type color
local color = require("common/color")

FS.modules.heal_engine.menu = {
    main_tree = FS.menu.tree_node(),
    
    -- Logging settings
    logging = {
        tree = FS.menu.tree_node(),
        enable_debug = FS.menu.checkbox(false, tag .. "enable_debug"),
        health = {
            tree = FS.menu.tree_node(),
            threshold = FS.menu.slider_float(0.01, 0.1, 0.01, tag .. "log_health_threshold"),
            show_cleanup = FS.menu.checkbox(true, tag .. "log_cleanup"),
        },
        dps = {
            tree = FS.menu.tree_node(),
            threshold = FS.menu.slider_float(0.02, 0.1, 0.02, tag .. "log_dps_threshold"),
            show_fight = FS.menu.checkbox(true, tag .. "log_fight_dps"),
            show_windows = FS.menu.checkbox(true, tag .. "log_window_dps"),
        }
    },
    
    -- DPS tracking settings
    tracking = {
        tree = FS.menu.tree_node(),
        windows = {
            tree = FS.menu.tree_node(),
            enable_1s = FS.menu.checkbox(true, tag .. "enable_1s_window"),
            enable_5s = FS.menu.checkbox(true, tag .. "enable_5s_window"),
            enable_10s = FS.menu.checkbox(true, tag .. "enable_10s_window"),
            enable_15s = FS.menu.checkbox(true, tag .. "enable_15s_window"),
        }
    }
}

-- Render sub-menus
local function render_health_logging()
    FS.modules.heal_engine.menu.logging.health.tree:render("Health Changes", function()
        FS.modules.heal_engine.menu.logging.health.threshold:render("Threshold (%)", 
            "Only log health changes greater than this % of max health")
        FS.modules.heal_engine.menu.logging.health.show_cleanup:render("Show Cleanup Operations", 
            "Log when old health values are cleaned up")
    end)
end

local function render_dps_logging()
    FS.modules.heal_engine.menu.logging.dps.tree:render("DPS Updates", function()
        FS.modules.heal_engine.menu.logging.dps.threshold:render("Threshold (%)",
            "Only log DPS changes greater than this % of max health per second")
        FS.modules.heal_engine.menu.logging.dps.show_fight:render("Show Fight-Wide DPS",
            "Log total fight damage and DPS")
        FS.modules.heal_engine.menu.logging.dps.show_windows:render("Show Window DPS",
            "Log DPS for configured time windows")
    end)
end

local function render_dps_windows()
    FS.modules.heal_engine.menu.tracking.windows.tree:render("Time Windows", function()
        FS.modules.heal_engine.menu.tracking.windows.enable_1s:render("1 Second Window",
            "Track damage over the last 1 second")
        FS.modules.heal_engine.menu.tracking.windows.enable_5s:render("5 Second Window",
            "Track damage over the last 5 seconds")
        FS.modules.heal_engine.menu.tracking.windows.enable_10s:render("10 Second Window",
            "Track damage over the last 10 seconds")
        FS.modules.heal_engine.menu.tracking.windows.enable_15s:render("15 Second Window",
            "Track damage over the last 15 seconds")
    end)
end

---@type on_render_menu
function FS.modules.heal_engine.menu.on_render_menu()
    FS.modules.heal_engine.menu.main_tree:render(name, function()
        -- Logging settings
        FS.modules.heal_engine.menu.logging.tree:render("Logging", function()
            FS.modules.heal_engine.menu.logging.enable_debug:render("Enable Debug Logging",
                "Show detailed debug information")
            render_health_logging()
            render_dps_logging()
        end)
        
        -- DPS tracking settings
        FS.modules.heal_engine.menu.tracking.tree:render("DPS Tracking", function()
            render_dps_windows()
        end)
    end)
end
