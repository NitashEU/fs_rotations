---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")

local tag = "paladin_holy_herald_"
local name = "Holy Paladin (Herald of the Sun)"

FS.paladin_holy_herald.menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind(999, false, tag .. "enable_toggle"),
    settings_window = FS.menu.window(tag .. "settings"),
    settings_button = FS.menu.button(tag .. "settings_button"),
    show_settings = false,

    -- Holy Shock settings
    hs_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "hs_hp_threshold_slider"),
    hs_last_charge_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "hs_last_charge_hp_threshold_slider"),
    hs_rising_sun_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "hs_rising_sun_hp_threshold_slider"),

    -- Eternal Flame settings
    ef_header = FS.menu.header(),
    ef_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "ef_hp_threshold_slider"),
    ef_tank_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "ef_tank_hp_threshold_slider"),
    ef_critical_hp_threshold_slider = FS.menu.slider_int(1, 100, 50, tag .. "ef_critical_hp_threshold_slider"),

    -- Divine Toll settings
    dt_header = FS.menu.header(),
    dt_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "dt_hp_threshold_slider"),
    dt_min_targets_slider = FS.menu.slider_int(1, 5, 3, tag .. "dt_min_targets_slider"),
    dt_force_on_aw = FS.menu.checkbox(false, tag .. "dt_force_on_aw"),
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
    hp_save_for_aw = FS.menu.checkbox(true, tag .. "hp_save_for_aw"),

    -- Light of Dawn settings
    lod_header = FS.menu.header(),
    lod_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "lod_hp_threshold_slider"),
    lod_min_targets_slider = FS.menu.slider_int(1, 6, 3, tag .. "lod_min_targets_slider"),

    -- Awakening settings
    awakening_header = FS.menu.header(),
    awakening_hp_threshold_slider = FS.menu.slider_int(1, 100, 80, tag .. "awakening_hp_threshold_slider"),
    awakening_min_targets_slider = FS.menu.slider_int(1, 10, 3, tag .. "awakening_min_targets_slider"),

    -- Cooldown Management settings
    cooldown_header = FS.menu.header(),
    -- Avenging Wrath cooldown settings
    aw_auto_use_check = FS.menu.keybind(999, false, tag .. "aw_auto_use_check"),
    aw_min_targets_slider = FS.menu.slider_int(1, 10, 3, tag .. "aw_min_targets_slider"),
    aw_hp_threshold_slider = FS.menu.slider_int(1, 100, 75, tag .. "aw_hp_threshold_slider"),

    -- Flash of Light settings
    fol_header = FS.menu.header(),
    fol_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "fol_hp_threshold_slider"),
    fol_infusion_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "fol_infusion_hp_threshold_slider"),

    -- Holy Light settings
    hl_header = FS.menu.header(),
    hl_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, tag .. "hl_hp_threshold_slider"),
    hl_infusion_hp_threshold_slider = FS.menu.slider_int(1, 100, 90, tag .. "hl_infusion_hp_threshold_slider"),
}

-- Render settings window content
local function render_settings_window()
    local menu = FS.paladin_holy_herald.menu
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
                    { slider = menu.hs_rising_sun_hp_threshold_slider,  label = "Rising Sun Threshold",  tooltip = "Cast when target health falls below this percentage with Rising Sun" },
                    { slider = menu.hs_critical_priority_slider,        label = "Critical Priority",     tooltip = "Prioritize Holy Shock when target health falls below this percentage" },
                    { checkbox = menu.hs_predictive_healing_check,      label = "Predictive Healing",    tooltip = "Use predictive healing to anticipate incoming damage" }
                })

                -- Word of Glory settings
                FS.menu.render_settings_section(menu.settings_window, "Eternal Flame", {
                    { slider = menu.ef_hp_threshold_slider,          label = "Health Threshold",   tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.ef_tank_hp_threshold_slider,     label = "Tank Threshold",     tooltip = "Cast when tank health falls below this percentage" },
                    { slider = menu.ef_critical_hp_threshold_slider, label = "Critical Threshold", tooltip = "Cast at 3 Holy Power when target health falls below this percentage" }
                })

                -- Awakening settings
                if FS.paladin_holy_herald.talents.awakening then
                    FS.menu.render_settings_section(menu.settings_window, "Awakening", {
                        { slider = menu.awakening_hp_threshold_slider,  label = "Health Threshold",       tooltip = "Consider procs when group health falls below this percentage" },
                        { slider = menu.awakening_min_targets_slider,   label = "Minimum Targets",        tooltip = "Minimum injured targets to optimize for procs" },
                        { checkbox = menu.show_awakening_tracker_check, label = "Show Awakening Tracker", tooltip = "Display visual indicator showing Awakening stack progress" }
                    })
                end

                -- Flash of Light settings
                FS.menu.render_settings_section(menu.settings_window, "Flash of Light", {
                    { slider = menu.fol_hp_threshold_slider,          label = "Health Threshold",   tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.fol_infusion_hp_threshold_slider, label = "Infusion Threshold", tooltip = "Cast when target health falls below this percentage with Infusion of Light" }
                })

                -- Holy Light settings
                FS.menu.render_settings_section(menu.settings_window, "Holy Light", {
                    { slider = menu.hl_hp_threshold_slider,          label = "Health Threshold",   tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.hl_infusion_hp_threshold_slider, label = "Infusion Threshold", tooltip = "Cast when target health falls below this percentage with Infusion of Light" }
                })
            end,
            -- Right Column
            function()
                -- Cooldown Management settings
                FS.menu.render_settings_section(menu.settings_window, "Cooldown Management", {
                    -- Avenging Wrath cooldown settings
                    { checkbox = menu.aw_auto_use_check,    label = "Auto-use Avenging Wrath", tooltip = "Automatically use Avenging Wrath when conditions are met" },
                    { slider = menu.aw_min_targets_slider,  label = "AW Minimum Targets",      tooltip = "Minimum number of injured targets to use Avenging Wrath" },
                    { slider = menu.aw_hp_threshold_slider, label = "AW Health Threshold",     tooltip = "Group health threshold to use Avenging Wrath" },
                })
                -- Divine Toll settings
                if FS.paladin_holy_herald.talents.divine_toll then
                    FS.menu.render_settings_section(menu.settings_window, "Divine Toll", {
                        { slider = menu.dt_hp_threshold_slider, label = "Health Threshold",           tooltip = "Cast when target health falls below this percentage" },
                        { slider = menu.dt_min_targets_slider,  label = "Minimum Targets",            tooltip = "Minimum injured targets required to cast" },
                        { checkbox = menu.dt_force_on_aw,       label = "Force DT on Avenging Wrath", tooltip = "Force Divine Toll on Avenging Wrath" },
                    })
                end

                -- Beacon of Virtue settings
                if FS.paladin_holy_herald.talents.beacon_of_virtue then
                    FS.menu.render_settings_section(menu.settings_window, "Beacon of Virtue", {
                        { slider = menu.bov_hp_threshold_slider, label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                        { slider = menu.bov_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to cast" }
                    })
                end

                -- Holy Prism settings
                FS.menu.render_settings_section(menu.settings_window, "Holy Prism", {
                    { slider = menu.hp_hp_threshold_slider, label = "Health Threshold",           tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.hp_min_targets_slider,  label = "Minimum Targets",            tooltip = "Minimum injured targets required to cast" },
                    { checkbox = menu.hp_save_for_aw,       label = "Save HP for Avenging Wrath", tooltip = "Save Holy Prism for Avenging Wrath" },
                })

                -- Light of Dawn settings
                FS.menu.render_settings_section(menu.settings_window, "Light of Dawn", {
                    { slider = menu.lod_hp_threshold_slider, label = "Health Threshold", tooltip = "Cast when target health falls below this percentage" },
                    { slider = menu.lod_min_targets_slider,  label = "Minimum Targets",  tooltip = "Minimum injured targets required to cast" }
                })

                -- Herald of the Sun specific settings
                FS.menu.render_settings_section(menu.settings_window, "Herald of the Sun", {
                    { checkbox = menu.optimize_beams_check,            label = "Optimize Beams",            tooltip = "Optimize player position for maximum beam intersections during Avenging Wrath" },
                    { checkbox = menu.save_holy_prism_check,           label = "Save Holy Prism",           tooltip = "Save Holy Prism for Avenging Wrath or Awakening proc" },
                    { checkbox = menu.prioritize_self_dawnlight_check, label = "Prioritize Self Dawnlight", tooltip = "Prioritize applying Dawnlight to yourself for better beam control" }
                })
            end
        )
    end)
end

---@type on_render_menu
function FS.paladin_holy_herald.menu.on_render_menu()
    local menu = FS.paladin_holy_herald.menu

    menu.main_tree:render("Holy Paladin", function()
        menu.enable_toggle:render("Enable Script")
        menu.settings_button:render("Open Settings")

        if menu.settings_button:is_clicked() then
            menu.show_settings = not menu.show_settings
            menu.settings_window:set_visibility(menu.show_settings)
        end
    end)

    if menu.show_settings then
        render_settings_window()
    end
end

---@type on_render_control_panel
function FS.paladin_holy_herald.menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy_herald.menu.enable_toggle, name)
    FS.menu.insert_toggle(control_panel, FS.paladin_holy_herald.menu.aw_auto_use_check, "Auto Use Avenging Wrath")
    return control_panel
end
