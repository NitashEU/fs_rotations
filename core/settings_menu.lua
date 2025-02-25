-- Settings Menu for FS Rotations
-- Provides UI for centralized settings management

---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")

local tag = "fs_rotations_settings_"

-- Create settings menu objects with type annotations
---@type extended_window
local settings_window = FS.menu.extend_window(core.menu.window(tag .. "settings_window"))

---@type extended_combobox
local module_filter = FS.menu.extend_combobox(core.menu.combobox(0, tag .. "module_filter"))

-- Initialize settings menu structure
FS.settings_menu = {
    tree = core.menu.tree_node(),
    show_settings_window = core.menu.checkbox(false, tag .. "show_settings_window"),
    settings_button = core.menu.button(tag .. "settings_button"),
    
    -- Extended UI elements with custom methods
    settings_window = settings_window,
    module_filter = module_filter,
    
    -- Standard UI elements
    search_input = core.menu.text_input(tag .. "search"),
    
    -- Module tree nodes
    module_trees = {},
    
    -- State
    show_window = false,
    selected_setting = nil
}

---Format a value for display in the UI
---@param value any The value to format
---@param setting_type string The type of the setting
---@return string Formatted value
local function format_value(value, setting_type)
    if value == nil then
        return "nil"
    elseif type(value) == "boolean" then
        return value and "true" or "false"
    elseif setting_type == FS.settings_manager.TYPES.PERCENT then
        return string.format("%.1f%%", value * 100)
    elseif type(value) == "number" then
        if math.floor(value) == value then
            return tostring(value)
        else
            return string.format("%.2f", value)
        end
    else
        return tostring(value)
    end
end

---Render the settings window
---@return nil
local function render_settings_window()
    local menu = FS.settings_menu
    FS.menu.setup_window(menu.settings_window)
    
    menu.settings_window:begin(2, true, color.new(20, 20, 31, 200), color.new(255, 255, 255, 200), 0, function()
        local dynamic = menu.settings_window:get_current_context_dynamic_drawing_offset()
        menu.settings_window:set_current_context_dynamic_drawing_offset(vec2.new(dynamic.x, dynamic.y + 12))
        
        FS.menu.render_header(menu.settings_window, "Centralized Settings Manager")
        
        -- Filters
        menu.settings_window:begin_group(function()
            -- We need to pass an empty options table as the second parameter
            -- The options will be populated by clear_items/add_item
            menu.module_filter:render("Module", {}, "Filter settings by module")
            
            -- Add modules to filter
            menu.module_filter:clear_items()
            menu.module_filter:add_item("All Modules")
            
            -- Get unique modules
            local modules = {}
            for _, setting in ipairs(FS.settings_manager:list_settings()) do
                modules[setting.module] = true
            end
            
            -- Add to filter
            for module_name, _ in pairs(modules) do
                menu.module_filter:add_item(module_name)
            end
            
            -- Search box
            menu.search_input:render("Search", "Filter settings by name")
        end)
        
        -- Get filtered settings
        local settings = FS.settings_manager:list_settings()
        local filtered_settings = {}
        
        -- Apply module filter
        local selected_module = menu.module_filter:get_selected_item()
        if selected_module ~= "All Modules" and selected_module ~= "" then
            for _, setting in ipairs(settings) do
                if setting.module == selected_module then
                    table.insert(filtered_settings, setting)
                end
            end
        else
            filtered_settings = settings
        end
        
        -- Apply search filter
        local search_text = menu.search_input:get_text()
        if search_text ~= "" then
            local temp = {}
            for _, setting in ipairs(filtered_settings) do
                if setting.name:lower():find(search_text:lower()) then
                    table.insert(temp, setting)
                end
            end
            filtered_settings = temp
        end
        
        -- Group by module
        local by_module = {}
        for _, setting in ipairs(filtered_settings) do
            if not by_module[setting.module] then
                by_module[setting.module] = {}
            end
            table.insert(by_module[setting.module], setting)
        end
        
        -- Create tree nodes for each module
        for module_name, module_settings in pairs(by_module) do
            if not menu.module_trees[module_name] then
                menu.module_trees[module_name] = core.menu.tree_node()
            end
            
            -- Render module tree
            menu.module_trees[module_name]:render(module_name, function()
                -- Render settings in this module
                for _, setting in ipairs(module_settings) do
                    -- Get current value
                    local value = FS.settings_manager:get(setting.module, setting.name)
                    local formatted_value = format_value(value, setting.type)
                    
                    -- Render setting
                    menu.settings_window:begin_group(function()
                        menu.settings_window:render_text(0, vec2.new(0, 0), color.new(255, 255, 255, 255), 
                            setting.name .. ": " .. formatted_value)
                    end)
                    
                    -- Show tooltip with details
                    if menu.settings_window:is_last_widget_hovered() then
                        menu.settings_window:begin_tooltip(function()
                            menu.settings_window:render_text(0, vec2.new(0, 0), color.new(255, 255, 255, 255),
                                "Module: " .. setting.module)
                            menu.settings_window:render_text(0, vec2.new(0, 20), color.new(255, 255, 255, 255),
                                "Type: " .. setting.type)
                            
                            if setting.default ~= nil then
                                local formatted_default = format_value(setting.default, setting.type)
                                menu.settings_window:render_text(0, vec2.new(0, 40), color.new(255, 255, 255, 255),
                                    "Default: " .. formatted_default)
                            end
                            
                            if setting.options then
                                local y = 60
                                for option_name, option_value in pairs(setting.options) do
                                    menu.settings_window:render_text(0, vec2.new(0, y), color.new(255, 255, 255, 255),
                                        option_name .. ": " .. tostring(option_value))
                                    y = y + 20
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end)
end

---Render the settings menu in the main menu
---@param parent_tree any The parent tree node
---@return nil
function FS.settings_menu.render_in_menu(parent_tree)
    parent_tree:render("Settings Manager", function()
        FS.settings_menu.settings_button:render("Open Settings Manager")
        FS.settings_menu.show_settings_window:render("Always Show Settings Manager")
        
        -- Handle button click
        if FS.settings_menu.settings_button:is_clicked() then
            FS.settings_menu.show_window = not FS.settings_menu.show_window
            FS.settings_menu.settings_window:set_visibility(FS.settings_menu.show_window)
        end
        
        -- Handle checkbox
        if FS.settings_menu.show_settings_window:get_state() then
            FS.settings_menu.show_window = true
            FS.settings_menu.settings_window:set_visibility(true)
        end
    end)
    
    -- Render window if visible
    if FS.settings_menu.show_window then
        render_settings_window()
    end
end

-- Hook into the main menu
local original_on_render_menu = FS.menu.on_render_menu

---@type on_render_menu
function FS.menu.on_render_menu()
    -- Call original function if it exists
    if original_on_render_menu then
        original_on_render_menu()
    end
    
    -- Render settings menu in the main tree
    FS.settings_menu.render_in_menu(FS.menu.main_tree)
end

-- Return the module for proper loading
return FS.settings_menu