FS.paladin_holy_herald.logic = {}

require("classes/paladin/holy_herald/logic/rotations/index")
require("classes/paladin/holy_herald/logic/spells/index")

---@type on_update
function FS.paladin_holy_herald.logic.on_update()
    if not FS.paladin_holy_herald.settings.is_enabled() then
        return
    end
    
    -- Check if in Avenging Wrath window for Herald of the Sun specific handling
    if FS.paladin_holy_herald.logic.rotations.avenging_wrath() then
        return
    end
    
    -- Standard healing and damage rotations
    if FS.paladin_holy_herald.logic.rotations.healing() then
        return
    end
    
    if FS.paladin_holy_herald.logic.rotations.damage() then
        return
    end
end
