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

    -- Beacon of Virtue weights
    bov_weights = {
        health = FS.menu.slider_float(0.1, 1.0, 0.4, tag .. "bov_weight_health"),
        damage = FS.menu.slider_float(0.1, 1.0, 0.3, tag .. "bov_weight_damage"),
        cluster = FS.menu.slider_float(0.1, 1.0, 0.2, tag .. "bov_weight_cluster"),
        use_distance = FS.menu.checkbox(true, tag .. "bov_use_distance_weight"),
        distance = FS.menu.slider_float(0.1, 1.0, 0.1, tag .. "bov_weight_distance"),
    },

    -- Holy Prism settings
    hp_header = FS.menu.header(),
    hp_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "hp_hp_threshold_slider"),
    hp_min_targets_slider = FS.menu.slider_int(1, 5, 3, tag .. "hp_min_targets_slider"),
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

            -- Beacon of Virtue weights
            FS.menu.tree_node():render("Target Selection Weights", function()
                FS.paladin_holy.menu.bov_weights.health:render("Health Weight",
                    "Weight for target's health in scoring (higher = more important)")
                FS.paladin_holy.menu.bov_weights.damage:render("Damage Weight",
                    "Weight for target's incoming damage in scoring (higher = more important)")
                FS.paladin_holy.menu.bov_weights.cluster:render("Cluster Weight",
                    "Weight for number of nearby targets in scoring (higher = more important)")
                FS.paladin_holy.menu.bov_weights.use_distance:render("Use Distance Weighting",
                    "Enable distance-based target weighting")

                -- Only show distance weight if distance weighting is enabled
                if FS.paladin_holy.menu.bov_weights.use_distance:get_state() then
                    FS.paladin_holy.menu.bov_weights.distance:render("Distance Weight",
                        "Weight for target's distance in scoring (higher = prioritizes closer targets)")
                end
            end)
        end

        -- Holy Prism settings
        if FS.paladin_holy.talents.holy_prism then
            FS.paladin_holy.menu.hp_header:render("Holy Prism Settings", color.white())
            FS.paladin_holy.menu.hp_hp_threshold_slider:render("HP HP", "HP % threshold for Holy Prism healing")
            FS.paladin_holy.menu.hp_min_targets_slider:render("HP Min Targets",
                "Minimum targets for Holy Prism (cast on enemy)")
        end
    end)
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
