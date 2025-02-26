--- Heal Engine Module
--- This is the main entry point for the heal engine module.
--- This updated version uses a domain-oriented structure for better separation of concerns.

-- Load the core module first - this initializes the module structure
require("core/modules/heal_engine/core/index")

-- Export module interface
---@type ModuleConfig
return {
    on_update = FS.modules.heal_engine.on_update,
    on_fast_update = FS.modules.heal_engine.on_fast_update,
    on_render_menu = FS.modules.heal_engine.menu.on_render_menu,
    on_render = function() end,
}
