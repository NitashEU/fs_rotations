---@type control_panel_helper
local control_panel_helper = require("common/utility/control_panel_helper")
---@type key_helper
local key_helper = require("common/utility/key_helper")
---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")

local tag = "fs_rotations_core_"

FS.menu = {
    main_tree = core.menu.tree_node(),
    enable_script_check = core.menu.checkbox(false, tag .. "enable_script_check"),
    humanizer = core.menu.header(),
    min_delay = core.menu.slider_int(0, 1500, 125, tag .. "min_delay"),
    max_delay = core.menu.slider_int(1, 1500, 250, tag .. "max_delay"),

    -- Add humanizer jitter settings
    humanizer_jitter = {
        enable_jitter = core.menu.checkbox(true, tag .. "enable_jitter"),
        base_jitter = core.menu.slider_float(0.05, 0.30, 0.15, tag .. "base_jitter"),
        latency_jitter = core.menu.slider_float(0.01, 0.20, 0.05, tag .. "latency_jitter"),
        max_jitter = core.menu.slider_float(0.10, 0.50, 0.25, tag .. "max_jitter"),
    }
}

-- Default window style configuration
FS.menu.window_style = {
    background = {
        top_left = color.new(20, 20, 31, 255),
        top_right = color.new(31, 31, 46, 255),
        bottom_right = color.new(20, 20, 31, 255),
        bottom_left = color.new(31, 31, 46, 255)
    },
    size = vec2.new(800, 500),
    padding = vec2.new(15, 15),
    header_color = color.new(255, 255, 255, 255),
    header_spacing = 36,
    column_spacing = 400
}

-- Window helper functions
---Setup window with default styling
---@param window window The window to setup
function FS.menu.setup_window(window)
    window:set_background_multicolored(
        FS.menu.window_style.background.top_left,
        FS.menu.window_style.background.top_right,
        FS.menu.window_style.background.bottom_right,
        FS.menu.window_style.background.bottom_left
    )
    window:set_initial_size(FS.menu.window_style.size)
    window:set_next_window_padding(FS.menu.window_style.padding)
end

---Render a header with consistent styling
---@param window window The window to render in
---@param text string The header text
function FS.menu.render_header(window, text)
    local dynamic = window:get_current_context_dynamic_drawing_offset()
    window:render_text(1, vec2.new(dynamic.x, dynamic.y), FS.menu.window_style.header_color, text)
    window:set_current_context_dynamic_drawing_offset(
        vec2.new(dynamic.x, dynamic.y + FS.menu.window_style.header_spacing)
    )
end

---Begin a two-column layout section
---@param window window The window to render in
---@param left_content function Function to render left column content
---@param right_content function Function to render right column content
function FS.menu.begin_columns(window, left_content, right_content)
    local window_size = window:get_size()

    -- Left Column
    window:begin_group(function()
        window:set_next_window_padding(vec2.new((window_size.x - 625) / 2, 0))
        left_content()
    end)

    -- Right Column
    window:draw_next_dynamic_widget_on_same_line(FS.menu.window_style.column_spacing)
    window:begin_group(right_content)
end

---Render a settings section with header and sliders
---@param window window The window to render in
---@param title string Section title
---@param objects table Array of {slider = slider_object, label = string, tooltip = string}
function FS.menu.render_settings_section(window, title, objects)
    FS.menu.render_header(window, title)
    for _, obj in ipairs(objects) do
        if obj.slider then
            obj.slider:render(obj.label, obj.tooltip)
        elseif obj.checkbox then
            obj.checkbox:render(obj.label, obj.tooltip)
        elseif obj.keybind then
            obj.keybind:render(obj.label, obj.tooltip)
        end
    end
end

-- Existing menu functions
function FS.menu.insert_toggle(control_panel, keybind, name)
    control_panel_helper:insert_toggle(control_panel,
        {
            name = "[FS " .. name .. "] Enable (" ..
                key_helper:get_key_name(keybind:get_key_code()) .. ") ",
            keybind = keybind
        })
end

function FS.menu.register_menu()
    return core.menu.register_menu()
end

function FS.menu.tree_node()
    return core.menu.tree_node()
end

function FS.menu.checkbox(default_state, id)
    return core.menu.checkbox(default_state, "fs_rotations_" .. id)
end

function FS.menu.key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds, default_mode_state, id)
    return core.menu.key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds, default_mode_state,
        "fs_rotations_" .. id)
end

function FS.menu.slider_int(min_value, max_value, default_value, id)
    return core.menu.slider_int(min_value, max_value, default_value, "fs_rotations_" .. id)
end

function FS.menu.slider_float(min_value, max_value, default_value, id)
    return core.menu.slider_float(min_value, max_value, default_value, "fs_rotations_" .. id)
end

function FS.menu.combobox(default_index, id)
    return core.menu.combobox(default_index, "fs_rotations_" .. id)
end

function FS.menu.combobox_reorderable(default_index, id)
    return core.menu.combobox_reorderable(default_index, "fs_rotations_" .. id)
end

function FS.menu.keybind(default_value, initial_toggle_state, id)
    return core.menu.keybind(default_value, initial_toggle_state, "fs_rotations_" .. id)
end

function FS.menu.button(id)
    return core.menu.button("fs_rotations_" .. id)
end

function FS.menu.colorpicker(default_color, id)
    return core.menu.colorpicker(default_color, "fs_rotations_" .. id)
end

function FS.menu.header()
    return core.menu.header()
end

function FS.menu.text_input(id)
    return core.menu.text_input("fs_rotations_" .. id)
end

function FS.menu.window(window_id)
    return core.menu.window("fs_rotations_" .. window_id)
end
