---@type control_panel_helper
local control_panel_helper = require("common/utility/control_panel_helper")
---@type key_helper
local key_helper = require("common/utility/key_helper")
---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")

local tag = "fs_rotations_core_"

-- Initialize menu namespace
FS.menu = FS.menu or {}

-- Add window extensions for tooltip handling
---@param window window The window to extend
---@return window Extended window with additional methods
function FS.menu.extend_window(window)
    -- Add is_last_widget_hovered method
    window.is_last_widget_hovered = function(self)
        -- This is a simplification - ideally we would track the last widget bounds
        -- and check if the mouse is hovering over it
        return self:is_window_hovered() -- Fallback to window hover
    end
    
    -- Add begin_tooltip method
    window.begin_tooltip = function(self, callback)
        if callback then
            callback()
        end
    end
    
    return window
end

-- Extend combobox functionality
---@param combobox combobox The combobox to extend
---@return combobox Extended combobox with additional methods
function FS.menu.extend_combobox(combobox)
    local items = {}
    local selected_index = 1
    
    -- Add clear_items method
    combobox.clear_items = function(self)
        items = {}
        return self
    end
    
    -- Add add_item method
    combobox.add_item = function(self, item)
        table.insert(items, item)
        return self
    end
    
    -- Add get_selected_item method
    combobox.get_selected_item = function(self)
        local index = self:get()
        return items[index + 1] or ""
    end

    -- Save original render function
    local original_render = combobox.render
    
    -- Override render to use our items array
    combobox.render = function(self, label, tooltip)
        return original_render(self, label, items, tooltip)
    end
    
    return combobox
end

-- Extend base menu with core elements
FS.menu = FS.menu or {}
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
    },
    
    -- Add enhanced error handler menu elements
    error_handler = {
        tree = core.menu.tree_node(),
        show_errors = core.menu.checkbox(false, tag .. "show_errors"),
        show_stack_traces = core.menu.checkbox(false, tag .. "show_stack_traces"),
        clear_errors = core.menu.button(tag .. "clear_errors"),
        error_details = core.menu.tree_node(),
        max_errors_slider = core.menu.slider_int(1, 20, 5, tag .. "max_errors"),
        base_cooldown_slider = core.menu.slider_int(5, 60, 10, tag .. "base_cooldown"),
        max_cooldown_slider = core.menu.slider_int(60, 600, 300, tag .. "max_cooldown"),
        capture_state_checkbox = core.menu.checkbox(true, tag .. "capture_state"),
        selected_error = nil -- This will store the currently selected error for detailed view
    },
    
    -- Add performance metrics menu elements
    profiler = {
        tree = core.menu.tree_node(),
        enabled = core.menu.checkbox(true, tag .. "profiler_enabled"),
        show_metrics = core.menu.checkbox(false, tag .. "show_metrics"),
        clear_metrics = core.menu.button(tag .. "clear_metrics"),
        capture_memory = core.menu.button(tag .. "capture_memory"),
        
        -- Filter and sorting options
        category_filter = core.menu.combobox(0, tag .. "profiler_category"),
        sort_by = core.menu.combobox(2, tag .. "profiler_sort_by"), -- default to avg_time
        
        -- Configuration
        config_tree = core.menu.tree_node(),
        max_metrics = core.menu.slider_int(10, 200, 100, tag .. "profiler_max_metrics"),
        history_size = core.menu.slider_int(10, 120, 60, tag .. "profiler_history_size"),
        warning_threshold = core.menu.slider_int(10, 100, 50, tag .. "profiler_warning_threshold"),
        alert_threshold = core.menu.slider_int(50, 500, 100, tag .. "profiler_alert_threshold"),
        
        -- Visualization options
        show_charts = core.menu.checkbox(true, tag .. "profiler_show_charts"),
        selected_metric = nil -- This will store the currently selected metric for detailed view
    },
    
    -- Add memory management menu elements
    memory = {
        tree = core.menu.tree_node(),
        enabled = core.menu.checkbox(true, tag .. "memory_enabled"),
        show_pools = core.menu.checkbox(false, tag .. "show_pools"),
        check_leaks = core.menu.checkbox(true, tag .. "check_leaks"),
        clear_pools = core.menu.button(tag .. "clear_pools"),
        force_gc = core.menu.button(tag .. "force_gc"),
        
        -- Filter and sorting options
        sort_by = core.menu.combobox(0, tag .. "memory_sort_by"), -- default to name
        
        -- Configuration
        config_tree = core.menu.tree_node(),
        max_pool_size = core.menu.slider_int(50, 2000, 1000, tag .. "max_pool_size"),
        cleanup_interval = core.menu.slider_int(10, 300, 60, tag .. "cleanup_interval"),
        global_cleanup_interval = core.menu.slider_int(60, 600, 300, tag .. "global_cleanup_interval"),
        pre_allocation = core.menu.slider_int(5, 50, 10, tag .. "pre_allocation"),
        
        -- Debug options
        debug = core.menu.checkbox(false, tag .. "memory_debug"),
        
        -- Selected pool for detailed view
        selected_pool = nil
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
---@param sliders table Array of {slider = slider_object, label = string, tooltip = string}
function FS.menu.render_settings_section(window, title, sliders)
    FS.menu.render_header(window, title)
    for _, slider in ipairs(sliders) do
        slider.slider:render(slider.label, slider.tooltip)
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
