---@type enums
local enums = require("common/enums")

FS.paladin_holy.variables = {
    holy_power = function() return FS.variables.resource(enums.power_type.HOLYPOWER) end,
    avenging_crusader_up = function() return FS.variables.buff_up(FS.paladin_holy.auras.avenging_crusader) end,
    awakening_max_remains = function() return FS.variables.buff_remains(FS.paladin_holy.auras.awakening_max) end,
    blessed_assurance_up = function() return FS.variables.buff_up(FS.paladin_holy.auras.blessed_assurance) end,
    holy_armament_override_up = function() return FS.variables.aura_up(FS.paladin_holy.auras.holy_armament_override) end,
    rising_sunlight_up = function() return FS.variables.buff_up(FS.paladin_holy.auras.rising_sunlight) end,
    holy_shock_charges = function()
        local charges = core.spell_book.get_spell_charge(FS.paladin_holy.spells.holy_shock)
        local max_charges = core.spell_book.get_spell_charge_max(FS.paladin_holy.spells.holy_shock)

        if charges == max_charges then
            return charges
        end

        local cooldown = FS.api.spell_helper:get_remaining_charge_cooldown(FS.paladin_holy.spells.holy_shock)
        local recharge_mod = 1 -- TODO: Add haste/CDR modifiers if needed
        local recharge = cooldown / core.spell_book.get_spell_charge_cooldown_duration(FS.paladin_holy.spells.holy_shock)

        return charges + ((recharge_mod - recharge) / recharge_mod)
    end
}
