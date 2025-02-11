# Entry System

The entry system is the core initialization mechanism for FS Rotations. It handles module loading, spec validation, and initialization flow through a structured approach.

## Plugin Header

The plugin starts with `header.lua` which defines basic plugin information and initializes the global `FS` table:

```lua
FS = {
    ---@type SpecConfig
    spec_config = nil,
    ---@type ModuleConfig[]
    loaded_modules = {}
}

-- Initialize entry helper system
require("entry/index")

local plugin = {
    name = "FS Rotations",
    version = "1.0.0",
    author = "FS",
    load = true
}
```

## Initialization Flow

### 1. Entry Helper System

The entry system is organized through the entry helper module, which handles:

- Spec validation
- Required module loading
- Spec module loading
- Callback registration

### 2. Spec Validation

```lua
function FS.entry_helper.check_spec(player_class, player_spec_id)
    local spec_enum = enums.class_spec_id.get_specialization_enum(player_class, player_spec_id)
    if not FS.entry_helper.allowed_specs[spec_enum] then
        return false
    end

    FS.spec_config = {
        class_id = player_class,
        spec_id = player_spec_id,
        on_update = function() end,
        on_render = function() end,
        on_render_menu = function() end,
        on_render_control_panel = function(_) return _ end
    }
    return true
end
```

### 3. Required Module Loading

```lua
function FS.entry_helper.load_required_modules()
    require("core/index")
    for _, module_path in ipairs(required_modules) do
        local success, module = pcall(require, module_path)
        if success then
            table.insert(FS.loaded_modules, module)
        else
            core.log("Failed to load required module: " .. module_path)
            return false
        end
    end
    return true
end
```

### 4. Spec Module Loading

```lua
function FS.entry_helper.load_spec_module()
    local success, module = pcall(require,
        "classes/" ..
        FS.entry_helper.class_spec_map
        [enums.class_spec_id.get_specialization_enum(FS.spec_config.class_id, FS.spec_config.spec_id)] ..
        "/bootstrap")
    if success then
        FS.spec_config = module
        return true
    end
    core.log("Failed to load spec module: " .. module)
    return false
end
```

## Callback System

The entry system registers several callback types:

### Update Callback

```lua
function FS.entry_helper.on_update()
    if not FS.settings.is_enabled() then
        return
    end

    -- Fast update for modules
    for _, module in pairs(FS.loaded_modules) do
        if module.on_fast_update then
            module.on_fast_update()
        end
    end

    -- Regular update cycle
    if not FS.humanizer.can_run() then
        return
    end

    -- Update modules
    for _, module in pairs(FS.loaded_modules) do
        if module.on_update then
            module.on_update()
        end
    end

    -- Update spec
    if FS.spec_config.on_update then
        FS.spec_config.on_update()
    end
end
```

### Menu Callback

```lua
function FS.entry_helper.on_render_menu()
    FS.menu.main_tree:render("FS Rotations", function()
        FS.menu.enable_script_check:render("Enable Script")
        if not FS.settings.is_enabled() then return end

        -- Render module menus
        -- Render spec menus
    end)
end
```

## Module Configuration Interface

Modules must implement the `ModuleConfig` interface:

```lua
---@class ModuleConfig
---@field on_update fun() Called on each update cycle
---@field on_fast_update fun() Called on each fast update cycle
---@field on_render fun() Called when rendering the module's visuals
---@field on_render_menu fun() Called when rendering the module's menu
```

## Best Practices

1. **Module Loading**

   - Use `pcall` for safe module loading
   - Log meaningful error messages
   - Maintain clear module dependencies

2. **Spec Loading**

   - Use the class/spec map for dynamic spec loading
   - Implement all required callback functions
   - Initialize spec-specific settings properly

3. **Error Handling**

   - Log errors using `core.log()`
   - Fail gracefully when modules can't be loaded
   - Provide clear error messages for debugging

4. **Performance**
   - Use fast updates only when necessary
   - Respect humanizer delays
   - Initialize variables outside update loops
