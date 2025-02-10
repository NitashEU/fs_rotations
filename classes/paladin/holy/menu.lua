local tag = "paladin_holy_"
local name = "Holy Paladin"

FS.paladin_holy.menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind(999, false, tag .. "enable_toggle"),
    hs_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, "hs_hp_threshold_slider"),
    ac_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "ac_hp_threshold_slider"),
    ac_min_targets_slider = FS.menu.slider_int(1, 10, 3, tag .. "ac_min_targets_slider"),
}

---@type on_render_menu
function FS.paladin_holy.menu.on_render_menu()
    FS.paladin_holy.menu.main_tree:render("Holy Paladin", function()
        FS.paladin_holy.menu.enable_toggle:render("Enable Script")
        FS.paladin_holy.menu.hs_hp_threshold_slider:render("HS HP", "HP % to cast Holy Shock at.")
        FS.paladin_holy.menu.ac_hp_threshold_slider:render("AC HP", "HP % threshold for Avenging Crusader healing")
        FS.paladin_holy.menu.ac_min_targets_slider:render("AC Targets", "Minimum targets for Avenging Crusader healing")
    end)
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
