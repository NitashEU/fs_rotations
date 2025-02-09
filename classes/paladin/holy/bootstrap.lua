FS.paladin_holy = {}

require("classes/paladin/holy/index")

---@type SpecConfig
return {
    spec_id = 0,
    class_id = 0,
    on_update = FS.paladin_holy.logic.on_update,
    on_render = FS.paladin_holy.drawing.on_render,
    on_render_menu = FS.paladin_holy.menu.on_render_menu,
    on_render_control_panel = FS.paladin_holy.menu.on_render_control_panel
}
