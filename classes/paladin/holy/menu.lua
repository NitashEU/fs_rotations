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

    -- Word of Glory settings
    wog_header = FS.menu.header(),
    wog_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "wog_hp_threshold_slider"),
    wog_tank_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "wog_tank_hp_threshold_slider"),

    -- Divine Toll settings
    dt_header = FS.menu.header(),
    dt_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "dt_hp_threshold_slider"),
    dt_min_targets_slider = FS.menu.slider_int(1, 5, 3, tag .. "dt_min_targets_slider"),
    dt_weights_tree = FS.menu.tree_node(),

    -- Divine Toll weights
    dt_weights = {
        health = FS.menu.slider_float(0.1, 1.0, 0.4, tag .. "dt_weight_health"),
        damage = FS.menu.slider_float(0.1, 1.0, 0.3, tag .. "dt_weight_damage"),
        cluster = FS.menu.slider_float(0.1, 1.0, 0.2, tag .. "dt_weight_cluster")
    },

    -- Beacon of Virtue settings
    bov_header = FS.menu.header(),
    bov_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "bov_hp_threshold_slider"),
    bov_min_targets_slider = FS.menu.slider_int(1, 5, 3, tag .. "bov_min_targets_slider"),
    bov_weights_tree = FS.menu.tree_node(),
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

    -- Light of Dawn settings
    lod_header = FS.menu.header(),
    lod_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "lod_hp_threshold_slider"),
    lod_min_targets_slider = FS.menu.slider_int(1, 6, 3, tag .. "lod_min_targets_slider"),
}

---@type on_render_menu
function FS.paladin_holy.menu.on_render_menu()
    FS.paladin_holy.menu.main_tree:render("Holy Paladin", function()
        FS.paladin_holy.menu.enable_toggle:render("Enable Script")
        FS.paladin_holy.menu.hs_hp_threshold_slider:render("HS HP", "HP % to cast Holy Shock at.")
        FS.paladin_holy.menu.ac_hp_threshold_slider:render("AC HP", "HP % threshold for Avenging Crusader healing")
        FS.paladin_holy.menu.ac_min_targets_slider:render("AC Targets", "Minimum targets for Avenging Crusader healing")

        -- Word of Glory settings
        FS.paladin_holy.menu.wog_header:render("Word of Glory Settings", color.white())
        FS.paladin_holy.menu.wog_hp_threshold_slider:render("WoG HP", "HP % threshold for Word of Glory healing")
        FS.paladin_holy.menu.wog_tank_hp_threshold_slider:render("WoG Tank HP",
            "HP % threshold for Word of Glory tank healing")

        -- Divine Toll settings
        if FS.paladin_holy.talents.divine_toll then
            FS.paladin_holy.menu.dt_header:render("Divine Toll Settings", color.white())
            FS.paladin_holy.menu.dt_hp_threshold_slider:render("DT HP", "HP % threshold for Divine Toll healing")
            FS.paladin_holy.menu.dt_min_targets_slider:render("DT Min Targets", "Minimum targets for Divine Toll")

            -- Divine Toll weights
            FS.paladin_holy.menu.dt_weights_tree:render("DT Weights", function()
                FS.paladin_holy.menu.dt_weights.health:render("Health Weight",
                    "Weight for target's health in scoring (higher = more important)")
                FS.paladin_holy.menu.dt_weights.damage:render("Damage Weight",
                    "Weight for target's incoming damage in scoring (higher = more important)")
                FS.paladin_holy.menu.dt_weights.cluster:render("Cluster Weight",
                    "Weight for number of nearby targets in scoring (higher = more important)")
            end)
        end

        -- Beacon of Virtue settings
        if FS.paladin_holy.talents.beacon_of_virtue then
            FS.paladin_holy.menu.bov_header:render("Beacon of Virtue Settings", color.white())
            FS.paladin_holy.menu.bov_hp_threshold_slider:render("BoV HP", "HP % threshold for Beacon of Virtue healing")
            FS.paladin_holy.menu.bov_min_targets_slider:render("BoV Min Targets", "Minimum targets for Beacon of Virtue")

            -- Beacon of Virtue weights
            FS.paladin_holy.menu.bov_weights_tree:render("BoV Weights", function()
                FS.paladin_holy.menu.bov_weights.health:render("Health Weight",
                    "Weight for target's health in scoring (higher = more important)")
                FS.paladin_holy.menu.bov_weights.damage:render("Damage Weight",
                    "Weight for target's incoming damage in scoring (higher = more important)")
                FS.paladin_holy.menu.bov_weights.cluster:render("Cluster Weight",
                    "Weight for number of nearby targets in scoring (higher = more important)")

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

        -- Light of Dawn settings
        FS.paladin_holy.menu.lod_header:render("Light of Dawn Settings", color.white())
        FS.paladin_holy.menu.lod_hp_threshold_slider:render("LoD HP", "HP % threshold for Light of Dawn healing")
        FS.paladin_holy.menu.lod_min_targets_slider:render("LoD Min Targets", "Minimum targets for Light of Dawn")
    end)
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
