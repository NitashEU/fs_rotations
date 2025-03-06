FS.paladin_holy_herald = {}

require("classes/paladin/holy_herald/index")

-- Register the Herald of the Sun specialization with the correct class and spec IDs
-- Class ID 2 = Paladin, Spec ID 65 = Holy
---@type SpecConfig
return {
    spec_id = 65, -- Holy Paladin spec ID
    class_id = 2, -- Paladin class ID
    on_update = FS.paladin_holy_herald.logic.on_update,
    on_render = function() end,
    on_render_menu = FS.paladin_holy_herald.menu.on_render_menu,
    on_render_control_panel = FS.paladin_holy_herald.menu.on_render_control_panel
}
