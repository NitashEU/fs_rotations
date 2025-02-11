---@type color
local color = require("common/color")

local tag = "paladin_holy_"
local name = "Holy Paladin"

FS.paladin_holy.menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind(999, false, tag .. "enable_toggle"),
    hs_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, "hs_hp_threshold_slider"),
    ac_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "ac_hp_threshold_slider"),
    ac_min_targets_slider = FS.menu.slider_int(1, 10, 3, tag .. "ac_min_targets_slider"),

    -- Beacon of Virtue settings
    bov_header = FS.menu.header(),
    bov_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "bov_hp_threshold_slider"),
    bov_min_targets_slider = FS.menu.slider_int(1, 5, 3, tag .. "bov_min_targets_slider"),
    bov_prioritize_distance = FS.menu.checkbox(true, tag .. "bov_prioritize_distance"),
}

---@type on_render_menu
function FS.paladin_holy.menu.on_render_menu()
    FS.paladin_holy.menu.main_tree:render("Holy Paladin", function()
        FS.paladin_holy.menu.enable_toggle:render("Enable Script")
        FS.paladin_holy.menu.hs_hp_threshold_slider:render("HS HP", "HP % to cast Holy Shock at.")
        FS.paladin_holy.menu.ac_hp_threshold_slider:render("AC HP", "HP % threshold for Avenging Crusader healing")
        FS.paladin_holy.menu.ac_min_targets_slider:render("AC Targets", "Minimum targets for Avenging Crusader healing")

        -- Beacon of Virtue settings
        if FS.paladin_holy.talents.beacon_of_virtue then
            FS.paladin_holy.menu.bov_header:render("Beacon of Virtue Settings", color.white())
            FS.paladin_holy.menu.bov_hp_threshold_slider:render("BoV HP", "HP % threshold for Beacon of Virtue healing")
            FS.paladin_holy.menu.bov_min_targets_slider:render("BoV Min Targets", "Minimum targets for Beacon of Virtue")
            FS.paladin_holy.menu.bov_prioritize_distance:render("Prioritize Close Targets",
                "Prioritize targets closer to you")
        end
    end)
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
