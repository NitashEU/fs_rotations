---@type control_panel_helper
local control_panel_helper = require("common/utility/control_panel_helper")
---@type key_helper
local key_helper = require("common/utility/key_helper")

local tag = "fs_rotations_core_"

FS.menu = {
    main_tree = core.menu.tree_node(),
    enable_script_check = core.menu.checkbox(false, tag .. "enable_script_check"),
    --enable_bitch_mode = core.menu.keybind(999, false, tag .. "enable_bitch_mode"),
    --enable_cd_manager = core.menu.keybind(999, false, tag .. "enable_cd_manager"),
    humanizer = core.menu.header(),
    min_delay = core.menu.slider_int(0, 1500, 125, tag .. "min_delay"),
    max_delay = core.menu.slider_int(1, 1500, 250, tag .. "max_delay"),
}

--- Inserts a toggle into the control panel table.
---@param control_panel table
---@param keybind keybind
---@param name string
function FS.menu.insert_toggle(control_panel, keybind, name)
    control_panel_helper:insert_toggle(control_panel,
        {
            name = "[FS " .. name .. "] Enable (" ..
                key_helper:get_key_name(keybind:get_key_code()) .. ") ",
            keybind = keybind
        })
end

--- Registers the menu for interaction.
function FS.menu.register_menu()
    return core.menu.register_menu()
end

--- Creates a new tree node instance
---@return tree_node
function FS.menu.tree_node()
    return core.menu.tree_node()
end

--- Creates a new checkbox instance.
---@param default_state boolean The default state of the checkbox.
---@param id string The unique identifier for the checkbox.
---@return checkbox
function FS.menu.checkbox(default_state, id)
    return core.menu.checkbox(default_state, "fs_rotations_" .. id)
end

--- Creates a new checkbox instance.
---@param default_key integer The default state of the checkbox.
---@param initial_toggle_state boolean The initial toggle state of the keybind
---@param default_state boolean The default state of the checkbox
---@param show_in_binds boolean The default show in binds state of the checkbox
---@param default_mode_state integer The default show in binds state of the checkbox  -> 0 is hold, 1 is toggle, 2 is always
---@param id string The unique identifier for the checkbox.
---@return key_checkbox
function FS.menu.key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds, default_mode_state, id)
    return core.menu.key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds, default_mode_state,
        "fs_rotations_" .. id)
end

--- Creates a new slider with integer values.
---@param min_value number The minimum value of the slider.
---@param max_value number The maximum value of the slider.
---@param default_value number The default value of the slider.
---@param id string The unique identifier for the slider.
---@return slider_int
function FS.menu.slider_int(min_value, max_value, default_value, id)
    return core.menu.slider_int(min_value, max_value, default_value, "fs_rotations_" .. id)
end

--- Creates a new slider with floating-point values.
---@param min_value number The minimum value of the slider.
---@param max_value number The maximum value of the slider.
---@param default_value number The default value of the slider.
---@param id string The unique identifier for the slider.
---@return slider_float
function FS.menu.slider_float(min_value, max_value, default_value, id)
    return core.menu.slider_float(min_value, max_value, default_value, "fs_rotations_" .. id)
end

--- Creates a new combobox.
---@param default_index number The default index of the combobox options (1-based).
---@param id string The unique identifier for the combobox.
---@return combobox
function FS.menu.combobox(default_index, id)
    return core.menu.combobox(default_index, "fs_rotations_" .. id)
end

--- Creates a new combobox_reorderable.
---@param default_index number The default index of the combobox options (1-based).
---@param id string The unique identifier for the combobox.
---@return combobox_reorderable
function FS.menu.combobox_reorderable(default_index, id)
    return core.menu.combobox_reorderable(default_index, "fs_rotations_" .. id)
end

--- Creates a new keybind.
---@param default_value number The default value for the keybind.
---@param initial_toggle_state boolean The initial toggle state for the keybind.
---@param id string The unique identifier for the keybind.
---@return keybind
function FS.menu.keybind(default_value, initial_toggle_state, id)
    return core.menu.keybind(default_value, initial_toggle_state, "fs_rotations_" .. id)
end

--- Creates a new button.
---@return button
---@param id string The unique identifier for the button.
function FS.menu.button(id)
    return core.menu.button("fs_rotations_" .. id)
end

--- Creates a new color picker.
---@param default_color color The default color value.
---@param id string The unique identifier for the color picker.
---@return color_picker
function FS.menu.colorpicker(default_color, id)
    return core.menu.colorpicker(default_color, "fs_rotations_" .. id)
end

--- Creates a new header
---@return header
function FS.menu.header()
    return core.menu.header()
end

--- Creates a new text input
---@return text_input
function FS.menu.text_input(id)
    return core.menu.text_input("fs_rotations_" .. id)
end

--- Creates a new window
---@return window
function FS.menu.window(window_id)
    return core.menu.window("fs_rotations_" .. window_id)
end
