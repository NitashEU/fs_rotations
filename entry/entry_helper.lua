---@type enums
local enums = require("common/enums")

-- Entry helper provides utility functions for module loading and initialization
FS.entry_helper = {
    -- This table is deprecated in favor of the spec_module_registry.lua implementation
    -- It's kept for backward compatibility during the transition
    -- @deprecated Use spec_module_registry.lua instead
    class_spec_map = {
        [enums.class_spec_id.spec_enum.ARMS_WARRIOR] = "warrior/arms",
        [enums.class_spec_id.spec_enum.FURY_WARRIOR] = "warrior/fury",
        [enums.class_spec_id.spec_enum.PROTECTION_WARRIOR] = "warrior/protection",
        [enums.class_spec_id.spec_enum.HOLY_PALADIN] = "paladin/holy",
        [enums.class_spec_id.spec_enum.PROTECTION_PALADIN] = "paladin/protection",
        [enums.class_spec_id.spec_enum.RETRIBUTION_PALADIN] = "paladin/retribution",
        [enums.class_spec_id.spec_enum.BEAST_MASTERY_HUNTER] = "hunter/beast_mastery",
        [enums.class_spec_id.spec_enum.MARKSMANSHIP_HUNTER] = "hunter/marksmanship",
        [enums.class_spec_id.spec_enum.SURVIVAL_HUNTER] = "hunter/survival",
        [enums.class_spec_id.spec_enum.ASSASSINATION_ROGUE] = "rogue/assassination",
        [enums.class_spec_id.spec_enum.OUTLAW_ROGUE] = "rogue/outlaw",
        [enums.class_spec_id.spec_enum.SUBTLETY_ROGUE] = "rogue/subtlety",
        [enums.class_spec_id.spec_enum.DISCIPLINE_PRIEST] = "priest/discipline",
        [enums.class_spec_id.spec_enum.HOLY_PRIEST] = "priest/holy",
        [enums.class_spec_id.spec_enum.SHADOW_PRIEST] = "priest/shadow",
        [enums.class_spec_id.spec_enum.BLOOD_DEATHKNIGHT] = "deathknight/blood",
        [enums.class_spec_id.spec_enum.FROST_DEATHKNIGHT] = "deathknight/frost",
        [enums.class_spec_id.spec_enum.UNHOLY_DEATHKNIGHT] = "deathknight/unholy",
        [enums.class_spec_id.spec_enum.ELEMENTAL_SHAMAN] = "shaman/elemental",
        [enums.class_spec_id.spec_enum.ENHANCEMENT_SHAMAN] = "shaman/enhancement",
        [enums.class_spec_id.spec_enum.RESTORATION_SHAMAN] = "shaman/restoration",
        [enums.class_spec_id.spec_enum.ARCANE_MAGE] = "arcane",
        [enums.class_spec_id.spec_enum.FIRE_MAGE] = "fire",
        [enums.class_spec_id.spec_enum.FROST_MAGE] = "frost",
        [enums.class_spec_id.spec_enum.AFFLICTION_WARLOCK] = "affliction",
    },
    
    -- This table is deprecated in favor of the spec_module_registry.lua implementation
    -- @deprecated Use FS.is_spec_supported() instead
    allowed_specs = {
        [enums.class_spec_id.spec_enum.HOLY_PALADIN] = true,
    }
}
