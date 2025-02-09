local tag = "paladin_holy_"
local name = "Holy Paladin"

FS.paladin_holy.menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind(999, false, tag .. "enable_toggle"),
}

---@type on_render_menu
function FS.paladin_holy.menu.on_render_menu()
    FS.paladin_holy.menu.main_tree:render("Holy Paladin", function()
        FS.paladin_holy.menu.enable_toggle:render("Enable Script")
    end)
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
