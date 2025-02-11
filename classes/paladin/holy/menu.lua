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
    show_settings = false,

    weights_window = FS.menu.window(tag .. "weights"),
    weights_button = FS.menu.button(tag .. "weights_button"),
    show_weights = false,

    -- Holy Shock settings
    hs_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "hs_hp_threshold_slider"),
    hs_last_charge_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "hs_last_charge_hp_threshold_slider"),
    hs_rising_sun_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "hs_rising_sun_hp_threshold_slider"),

    -- Word of Glory settings
    wog_header = FS.menu.header(),
    wog_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "wog_hp_threshold_slider"),
    wog_tank_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "wog_tank_hp_threshold_slider"),

    -- Divine Toll settings
    dt_header = FS.menu.header(),
    dt_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "dt_hp_threshold_slider"),
    dt_min_targets_slider = FS.menu.slider_int(1, 5, 3, tag .. "dt_min_targets_slider"),
    dt_weights_tree = FS.menu.tree_node(),
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

    -- Avenging Crusader settings
    ac_header = FS.menu.header(),
    ac_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "ac_hp_threshold_slider"),
    ac_min_targets_slider = FS.menu.slider_int(1, 10, 3, tag .. "ac_min_targets_slider"),

    -- Awakening settings
    awakening_header = FS.menu.header(),
    awakening_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "awakening_hp_threshold_slider"),
    awakening_min_targets_slider = FS.menu.slider_int(1, 10, 3, tag .. "awakening_min_targets_slider"),
}

-- Helper function to render weight sliders
local function render_weight_sliders(weights)
    weights.health:render("Health Priority", "Prioritize targets based on current health percentage")
    weights.damage:render("Damage Priority", "Prioritize targets based on incoming damage")
    weights.cluster:render("Cluster Priority", "Prioritize targets with more nearby injured allies")
    if weights.use_distance and weights.use_distance:get_state() then
        weights.distance:render("Distance Priority", "Prioritize targets based on distance from you")
    end
end

-- Render settings window content
local function render_settings_window()
    local menu = FS.paladin_holy.menu
    FS.menu.setup_window(menu.settings_window)

    menu.settings_window:begin(2, true, color.new(20, 20, 31, 200), color.new(255, 255, 255, 200), 0, function()
        local dynamic = menu.settings_window:get_current_context_dynamic_drawing_offset()
        menu.settings_window:set_current_context_dynamic_drawing_offset(vec2.new(dynamic.x, dynamic.y + 12))

        FS.menu.render_header(menu.settings_window, "Spell Settings")

        FS.menu.begin_columns(menu.settings_window,
            -- Left Column
            function()
                -- Holy Shock settings
                FS.menu.render_settings_section(menu.settings_window, "Holy Shock", {
                    { slider = menu.hs_hp_threshold_slider,             label = "Health Threshold",      tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.hs_last_charge_hp_threshold_slider, label = "Last Charge Threshold", tooltip = "Cast when target health falls below this percentage with one charge" },
                    { slider = menu.hs_rising_sun_hp_threshold_slider,  label = "Rising Sun Threshold",  tooltip = "Cast when target health falls below this percentage with Rising Sun" }
                })

                -- Word of Glory settings
                FS.menu.render_settings_section(menu.settings_window, "Word of Glory", {
                    { slider = menu.wog_hp_threshold_slider,      label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.wog_tank_hp_threshold_slider, label = "Tank Threshold",   tooltip = "Cast when tank health falls below this percentage" }
                })

                -- Avenging Crusader settings
                if FS.paladin_holy.talents.avenging_crusader then
                    FS.menu.render_settings_section(menu.settings_window, "Avenging Crusader", {
                        { slider = menu.ac_hp_threshold_slider, label = "Health Threshold", tooltip = "Use when group health falls below this percentage" },
                        { slider = menu.ac_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to activate" }
                    })
                end

                -- Awakening settings
                if FS.paladin_holy.talents.awakening then
                    FS.menu.render_settings_section(menu.settings_window, "Awakening", {
                        { slider = menu.awakening_hp_threshold_slider, label = "Health Threshold", tooltip = "Consider procs when group health falls below this percentage" },
                        { slider = menu.awakening_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets to optimize for procs" }
                    })
                end
            end,
            -- Right Column
            function()
                -- Divine Toll settings
                if FS.paladin_holy.talents.divine_toll then
                    FS.menu.render_settings_section(menu.settings_window, "Divine Toll", {
                        { slider = menu.dt_hp_threshold_slider, label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                        { slider = menu.dt_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to cast" }
                    })
                end

                -- Beacon of Virtue settings
                if FS.paladin_holy.talents.beacon_of_virtue then
                    FS.menu.render_settings_section(menu.settings_window, "Beacon of Virtue", {
                        { slider = menu.bov_hp_threshold_slider, label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                        { slider = menu.bov_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to cast" }
                    })
                end

                -- Holy Prism settings
                FS.menu.render_settings_section(menu.settings_window, "Holy Prism", {
                    { slider = menu.hp_hp_threshold_slider, label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.hp_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to cast" }
                })

                -- Light of Dawn settings
                FS.menu.render_settings_section(menu.settings_window, "Light of Dawn", {
                    { slider = menu.lod_hp_threshold_slider, label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.lod_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to cast" }
                })
            end
        )
    end)
end

-- Render weights window content
local function render_weights_window()
    local menu = FS.paladin_holy.menu
    FS.menu.setup_window(menu.weights_window)

    menu.weights_window:begin(2, true, color.new(20, 20, 31, 200), color.new(255, 255, 255, 200), 0, function()
        local dynamic = menu.weights_window:get_current_context_dynamic_drawing_offset()
        menu.weights_window:set_current_context_dynamic_drawing_offset(vec2.new(dynamic.x, dynamic.y + 12))

        FS.menu.render_header(menu.weights_window, "Target Priority Settings")

        FS.menu.begin_columns(menu.weights_window,
            -- Left Column
            function()
                if FS.paladin_holy.talents.divine_toll then
                    FS.menu.render_header(menu.weights_window, "Divine Toll")
                    render_weight_sliders(menu.dt_weights)
                end
            end,
            -- Right Column
            function()
                if FS.paladin_holy.talents.beacon_of_virtue then
                    FS.menu.render_header(menu.weights_window, "Beacon of Virtue")
                    render_weight_sliders(menu.bov_weights)
                end
            end
        )
    end)
end

---@type on_render_menu
function FS.paladin_holy.menu.on_render_menu()
    local menu = FS.paladin_holy.menu

    menu.main_tree:render("Holy Paladin", function()
        menu.enable_toggle:render("Enable Script")
        menu.settings_button:render("Open Settings")
        menu.weights_button:render("Open Weights")

        if menu.settings_button:is_clicked() then
            menu.show_settings = not menu.show_settings
            menu.settings_window:set_visibility(menu.show_settings)
        end

        if menu.weights_button:is_clicked() then
            menu.show_weights = not menu.show_weights
            menu.weights_window:set_visibility(menu.show_weights)
        end
    end)

    if menu.show_settings then
        render_settings_window()
    end

    if menu.show_weights then
        render_weights_window()
    end
end

---@type on_render_control_panel
function FS.paladin_holy.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy.menu.enable_toggle, name)
    return control_panel
end
