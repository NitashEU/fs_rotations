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
}

require("core/modules/heal_engine/on_update")
require("core/modules/heal_engine/reset")
require("core/modules/heal_engine/start")

core.log("yo")

return {
    on_update = FS.modules.heal_engine.on_update,
}
