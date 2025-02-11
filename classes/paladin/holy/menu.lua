---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")

local tag = "paladin_holy_"
local name = "Holy Paladin"

FS.paladin_holy.menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind(999, false, tag .. "enable_toggle"),
    settings_window = FS.menu.window(tag .. "settings"),
    settings_button = FS.menu.button(tag .. "settings_button"),
    show_settings = false, -- Track window visibility state

    -- Keep existing sliders
    hs_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "hs_hp_threshold_slider"),
    hs_last_charge_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "hs_last_charge_hp_threshold_slider"),
    hs_rising_sun_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "hs_rising_sun_hp_threshold_slider"),
    wog_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "wog_hp_threshold_slider"),
    wog_tank_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "wog_tank_hp_threshold_slider"),
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
        FS.paladin_holy.menu.settings_button:render("Open Settings")

        if FS.paladin_holy.menu.settings_button:is_clicked() then
            FS.paladin_holy.menu.show_settings = not FS.paladin_holy.menu.show_settings
            FS.paladin_holy.menu.settings_window:set_visibility(FS.paladin_holy.menu.show_settings)
        end
    end)

    if not FS.paladin_holy.menu.show_settings then
        return
    end

    -- Set solid background with gradient
    FS.paladin_holy.menu.settings_window:set_background_multicolored(
        color.new(20, 20, 31, 255), -- Top left: darker
        color.new(31, 31, 46, 255), -- Top right: slightly lighter
        color.new(20, 20, 31, 255), -- Bottom right: darker
        color.new(31, 31, 46, 255)  -- Bottom left: slightly lighter
    )
    FS.paladin_holy.menu.settings_window:set_initial_size(vec2.new(800, 500))
    -- Render settings window
    FS.paladin_holy.menu.settings_window:begin(2, true, color.new(20, 20, 31, 200), color.new(255, 255, 255, 200), 0,
        function()
            -- Set window properties


            local dynamic = FS.paladin_holy.menu.settings_window:get_current_context_dynamic_drawing_offset()
            FS.paladin_holy.menu.settings_window:set_current_context_dynamic_drawing_offset(
                vec2.new(dynamic.x, dynamic.y + 12))
            -- Add separator after headers
            local function render_header(text)
                dynamic = FS.paladin_holy.menu.settings_window:get_current_context_dynamic_drawing_offset()
                FS.paladin_holy.menu.settings_window:render_text(1, vec2.new(dynamic.x, dynamic.y),
                    color.new(255, 255, 255, 255), text)
                FS.paladin_holy.menu.settings_window:set_current_context_dynamic_drawing_offset(
                    vec2.new(dynamic.x, dynamic.y + 36))
            end

            render_header("General Settings")
            local window_size = FS.paladin_holy.menu.settings_window:get_size()

            local line_count_left = {}
            local line_count_right = {}

            FS.paladin_holy.menu.settings_window:begin_group(function()
                -- Holy Shock settings
                render_header("Holy Shock Settings")
                FS.paladin_holy.menu.settings_window:set_next_window_padding(vec2.new((window_size.x - 625) / 2, 0))
                FS.paladin_holy.menu.hs_hp_threshold_slider:render("Base HP %", "HP % to cast Holy Shock at")
                FS.paladin_holy.menu.hs_last_charge_hp_threshold_slider:render("Last Charge HP %",
                    "HP % to cast Holy Shock when only 1 charge remains")
                FS.paladin_holy.menu.hs_rising_sun_hp_threshold_slider:render("Rising Sunlight HP %",
                    "HP % to cast Holy Shock when Rising Sunlight buff is active")
                table.insert(line_count_left, 4)

                -- Word of Glory settings
                render_header("Word of Glory Settings")
                FS.paladin_holy.menu.wog_hp_threshold_slider:render("Base HP %",
                    "HP % threshold for Word of Glory healing")
                FS.paladin_holy.menu.wog_tank_hp_threshold_slider:render("Tank HP %",
                    "HP % threshold for Word of Glory tank healing")

                table.insert(line_count_left, 2)
            end)

            FS.paladin_holy.menu.settings_window:draw_next_dynamic_widget_on_same_line(FS.paladin_holy.menu
                .hs_hp_threshold_slider:get_widget_bounds().max.x - FS.paladin_holy.menu
                .hs_hp_threshold_slider:get_widget_bounds().min.x + 36)


            FS.paladin_holy.menu.settings_window:begin_group(function()
                local i_right = 0
                -- Divine Toll settings
                if FS.paladin_holy.talents.divine_toll then
                    render_header("Divine Toll Settings")
                    FS.paladin_holy.menu.settings_window:set_next_window_padding(vec2.new((window_size.x - 625) / 2, 0))
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
                    i_right = i_right + 1
                end

                -- Beacon of Virtue settings
                if FS.paladin_holy.talents.beacon_of_virtue then
                    local lines_left = line_count_left[i_right]
                    FS.paladin_holy.menu.settings_window:add_artificial_item_bounds(vec2.new(0, 36 * lines_left - 2),
                        vec2.new(0, 0))
                    render_header("Beacon of Virtue Settings")
                    FS.paladin_holy.menu.bov_hp_threshold_slider:render("BoV HP",
                        "HP % threshold for Beacon of Virtue healing")
                    FS.paladin_holy.menu.bov_min_targets_slider:render("BoV Min Targets",
                        "Minimum targets for Beacon of Virtue")

                    -- Beacon of Virtue weights
                    FS.paladin_holy.menu.bov_weights_tree:render("BoV Weights", function()
                        FS.paladin_holy.menu.bov_weights.health:render("Health Weight",
                            "Weight for target's health in scoring (higher = more important)")
                        FS.paladin_holy.menu.bov_weights.damage:render("Damage Weight",
                            "Weight for target's incoming damage in scoring (higher = more important)")
                        FS.paladin_holy.menu.bov_weights.cluster:render("Cluster Weight",
                            "Weight for number of nearby targets in scoring (higher = more important)")

                        if FS.paladin_holy.menu.bov_weights.use_distance:get_state() then
                            FS.paladin_holy.menu.bov_weights.distance:render("Distance Weight",
                                "Weight for target's distance in scoring (higher = prioritizes closer targets)")
                        end
                    end)
                    i_right = i_right + 1
                end
            end)
        end)
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
