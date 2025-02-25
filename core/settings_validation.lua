-- Settings Validation for FS Rotations
-- Provides real-time validation for menu element changes

---@class SettingsValidation
---@field validation_hooks table Table of validation hooks
FS.settings_validation = {
    validation_hooks = {}
}

---Register a validation hook for a menu element
---@param menu_elem table The menu element to validate
---@param module_name string The module name
---@param setting_name string The setting name
---@param validator function|nil Custom validator function (defaults to settings_manager)
---@return boolean Success of registration
function FS.settings_validation:register_hook(menu_elem, module_name, setting_name, validator)
    local component = "settings_validation.register_hook"
    
    -- Validate inputs
    if not FS.validator.check_table(menu_elem, "menu_elem", component) then return false end
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then return false end
    
    -- Create unique ID for this hook
    local hook_id = module_name .. "." .. setting_name
    
    -- Store original set function for slider and checkbox elements
    if menu_elem.set then
        local original_set = menu_elem.set
        menu_elem.set = function(value)
            -- Validate using the settings manager
            local is_valid = true
            
            if validator then
                -- Use custom validator if provided
                is_valid = validator(value)
            else
                -- Use settings manager validator
                is_valid = FS.settings_manager:validate(module_name, setting_name, value)
            end
            
            -- Only set if valid
            if is_valid then
                return original_set(value)
            else
                -- Log validation error
                FS.error_handler:record(component, 
                    "Invalid value for " .. module_name .. "." .. setting_name .. ": " .. tostring(value))
                return false
            end
        end
    end
    
    -- Store the hook
    self.validation_hooks[hook_id] = {
        menu_elem = menu_elem,
        module = module_name,
        setting = setting_name,
        validator = validator
    }
    
    return true
end

---Register validation hooks for all settings in a module
---@param module_name string The module name
---@param menu_table table The menu table containing UI elements
---@param mappings table Mappings of setting names to menu elements
---@return boolean Success of registration
function FS.settings_validation:register_module_hooks(module_name, menu_table, mappings)
    local component = "settings_validation.register_module_hooks"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_table(menu_table, "menu_table", component) then return false end
    if not FS.validator.check_table(mappings, "mappings", component) then return false end
    
    local success = true
    
    -- Register each mapping
    for setting_name, menu_path in pairs(mappings) do
        -- Resolve menu element from path
        local menu_elem = menu_table
        for part in menu_path:gmatch("[^%.]+") do
            menu_elem = menu_elem[part]
            if not menu_elem then break end
        end
        
        -- Register hook if element exists
        if menu_elem then
            success = success and self:register_hook(menu_elem, module_name, setting_name)
        end
    end
    
    return success
end

---Generate mappings for core settings
---@return table Mappings of setting names to menu paths
function FS.settings_validation:generate_core_mappings()
    return {
        ["is_enabled"] = "enable_script_check",
        ["min_delay"] = "min_delay",
        ["max_delay"] = "max_delay",
        ["jitter.is_enabled"] = "humanizer_jitter.enable_jitter",
        ["jitter.base_jitter"] = "humanizer_jitter.base_jitter",
        ["jitter.latency_jitter"] = "humanizer_jitter.latency_jitter",
        ["jitter.max_jitter"] = "humanizer_jitter.max_jitter"
    }
end

---Generate mappings for paladin holy settings
---@return table Mappings of setting names to menu paths
function FS.settings_validation:generate_paladin_holy_mappings()
    return {
        -- Core settings
        ["is_enabled"] = "enable_toggle",
        
        -- Holy Shock settings
        ["hs_hp_threshold"] = "hs_hp_threshold_slider",
        ["hs_last_charge_hp_threshold"] = "hs_last_charge_hp_threshold_slider",
        ["hs_rising_sun_hp_threshold"] = "hs_rising_sun_hp_threshold_slider",
        
        -- Word of Glory settings
        ["wog_hp_threshold"] = "wog_hp_threshold_slider",
        ["wog_tank_hp_threshold"] = "wog_tank_hp_threshold_slider",
        
        -- Divine Toll settings
        ["dt_hp_threshold"] = "dt_hp_threshold_slider",
        ["dt_min_targets"] = "dt_min_targets_slider",
        
        -- Divine Toll weights
        ["dt_health_weight"] = "dt_weights.health",
        ["dt_damage_weight"] = "dt_weights.damage",
        ["dt_cluster_weight"] = "dt_weights.cluster",
        
        -- Beacon of Virtue settings
        ["bov_hp_threshold"] = "bov_hp_threshold_slider",
        ["bov_min_targets"] = "bov_min_targets_slider",
        ["bov_use_distance"] = "bov_weights.use_distance",
        
        -- Beacon of Virtue weights
        ["bov_health_weight"] = "bov_weights.health",
        ["bov_damage_weight"] = "bov_weights.damage",
        ["bov_cluster_weight"] = "bov_weights.cluster",
        ["bov_distance_weight"] = "bov_weights.distance",
        
        -- Holy Prism settings
        ["hp_hp_threshold"] = "hp_hp_threshold_slider",
        ["hp_min_targets"] = "hp_min_targets_slider",
        
        -- Light of Dawn settings
        ["lod_hp_threshold"] = "lod_hp_threshold_slider",
        ["lod_min_targets"] = "lod_min_targets_slider",
        
        -- Avenging Crusader settings
        ["ac_hp_threshold"] = "ac_hp_threshold_slider",
        ["ac_min_targets"] = "ac_min_targets_slider",
        
        -- Flash of Light settings
        ["fol_hp_threshold"] = "fol_hp_threshold_slider",
        ["fol_infusion_hp_threshold"] = "fol_infusion_hp_threshold_slider",
        
        -- Holy Light settings
        ["hl_hp_threshold"] = "hl_hp_threshold_slider",
        ["hl_infusion_hp_threshold"] = "hl_infusion_hp_threshold_slider"
    }
end

---Generate mappings for heal engine settings
---@return table Mappings of setting names to menu paths
function FS.settings_validation:generate_heal_engine_mappings()
    return {
        -- Logging settings
        ["logging.is_debug_enabled"] = "logging.enable_debug",
        ["logging.health.get_threshold"] = "logging.health.threshold",
        ["logging.health.should_show_cleanup"] = "logging.health.show_cleanup",
        ["logging.dps.get_threshold"] = "logging.dps.threshold",
        ["logging.dps.should_show_fight"] = "logging.dps.show_fight",
        ["logging.dps.should_show_windows"] = "logging.dps.show_windows",
        
        -- Tracking settings
        ["tracking.windows.is_1s_enabled"] = "tracking.windows.enable_1s",
        ["tracking.windows.is_5s_enabled"] = "tracking.windows.enable_5s",
        ["tracking.windows.is_10s_enabled"] = "tracking.windows.enable_10s",
        ["tracking.windows.is_15s_enabled"] = "tracking.windows.enable_15s"
    }
end

---Initialize the settings validation
---@return nil
function FS.settings_validation:init()
    -- Register validation hooks for core settings
    if FS.menu then
        local core_mappings = self:generate_core_mappings()
        self:register_module_hooks("core", FS.menu, core_mappings)
    end
    
    -- Register validation hooks for paladin holy settings
    if FS.paladin_holy and FS.paladin_holy.menu then
        local paladin_mappings = self:generate_paladin_holy_mappings()
        self:register_module_hooks("paladin_holy", FS.paladin_holy.menu, paladin_mappings)
    end
    
    -- Register validation hooks for heal engine settings
    if FS.modules and FS.modules.heal_engine and FS.modules.heal_engine.menu then
        local heal_engine_mappings = self:generate_heal_engine_mappings()
        self:register_module_hooks("heal_engine", FS.modules.heal_engine.menu, heal_engine_mappings)
    end
end

-- Return the module for proper loading
return FS.settings_validation