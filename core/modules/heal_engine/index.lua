---@class HealthValue
---@field public health number
---@field public max_health number
---@field public health_percentage number
---@field public time number

-- Initialize heal engine module
FS.modules.heal_engine = {
    is_in_combat = false,
    ---@type game_object[]
    units = {},
    ---@type game_object[]
    tanks = {},
    ---@type game_object[]
    healers = {},
    ---@type game_object[]
    damagers = {},
    ---@type table<game_object, { health: number, max_health: number, health_percentage: number, time: number }[]>
    health_values = {},
    ---@type table<game_object, { health: number, max_health: number, health_percentage: number, time: number }>
    current_health_values = {},
    ---@type table<game_object, number>
    damage_taken_per_second = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_5_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_10_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_15_seconds = {},
    ---@type table<game_object, number>
    last_dps_values = {},
    ---@type table<game_object, number>
    fight_start_health = {},
    ---@type table<game_object, number>
    fight_total_damage = {},
    ---@type number
    fight_start_time = nil,
    ---@type table<game_object, {last_update: number, values: table<number, number>}>
    dps_cache = {} -- Add cache table
}

-- Load module files
require("core/modules/heal_engine/menu")
require("core/modules/heal_engine/settings")
require("core/modules/heal_engine/start")
require("core/modules/heal_engine/reset")
require("core/modules/heal_engine/get_damage_taken_per_second")
require("core/modules/heal_engine/target_selections/index")
require("core/modules/heal_engine/on_update")

-- Export module interface
---@type ModuleConfig
return {
    on_update = FS.modules.heal_engine.on_update,
    on_fast_update = FS.modules.heal_engine.on_fast_update,
    on_render_menu = FS.modules.heal_engine.menu.on_render_menu
}
