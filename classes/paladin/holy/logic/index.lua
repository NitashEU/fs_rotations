---@type spell_helper
local spell_helper = require("common/utility/spell_helper")

FS.paladin_holy.logic = {}

require("classes/paladin/holy/logic/rotations/index")
require("classes/paladin/holy/logic/spells/index")

---@type on_update
function FS.paladin_holy.logic.on_update()
    if not FS.paladin_holy.settings.is_enabled() then
        return
    end
    if FS.paladin_holy.logic.rotations.avenging_crusader() then
        return
    end
    if FS.paladin_holy.logic.rotations.healing() then
        return
    end
    if FS.paladin_holy.logic.rotations.damage() then
        return
    end

    core.log(tostring(spell_helper:is_spell_queueable(FS.paladin_holy.spells.blessing_of_the_seasons, FS.variables.me,
        FS.variables.me, false, false)))
end
