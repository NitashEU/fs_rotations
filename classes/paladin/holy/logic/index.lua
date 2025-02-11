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
end
