---@type enums
local enums = require("common/enums")

FS.paladin_holy.variables = {
    holy_power = function() return FS.variables.resource(enums.power_type.HOLYPOWER) end,
    avenging_crusader_up = function() return FS.variables.buff_up(FS.paladin_holy.auras.avenging_crusader) end,
    awakening_max_remains = function() return FS.variables.buff_remains(FS.paladin_holy.auras.awakening_max) end,
    blessed_assurance_up = function() return FS.variables.buff_up(FS.paladin_holy.auras.blessed_assurance) end,
    holy_armament_override_up = function() return FS.variables.aura_up(FS.paladin_holy.auras.holy_armament_override) end
}
