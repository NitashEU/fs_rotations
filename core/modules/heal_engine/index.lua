---@class HealthValue
---@field public health number
---@field public max_health number
---@field public health_percentage number
---@field public time number

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
    ---@type table<game_object, HealthValue[]>
    health_values = {},
    ---@type table<game_object, HealthValue>
    current_health_values = {},
    ---@type table<game_object, number>
    damage_taken_per_second = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_5_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_10_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_15_seconds = {},
}

require("core/modules/heal_engine/get_damage_taken_per_second")
require("core/modules/heal_engine/on_update")
require("core/modules/heal_engine/reset")
require("core/modules/heal_engine/start")

return {
    on_update = FS.modules.heal_engine.on_update,
    on_fast_update = FS.modules.heal_engine.on_fast_update
}
