---
description: Guidelines and best practices for building FS Rotations projects, including module organization, spell rotation logic, and real-world examples.
globs: **/*.{lua}
---

# FS Rotations Guidelines

## Module Organization
### Class and Spec Modules
- **File Structure**: Use the `classes/[class]/[spec]/bootstrap.lua` pattern to initialize class/spec modules.
- **Example**:
  ```lua
  -- classes/paladin/holy/bootstrap.lua
  FS.paladin_holy = {}
  require("classes/paladin/holy/index")
  return {
      spec_id = 0,
      class_id = 0,
      on_update = FS.paladin_holy.logic.on_update,
      on_render = FS.paladin_holy.drawing.on_render,
      on_render_menu = FS.paladin_holy.menu.on_render_menu,
      on_render_control_panel = FS.paladin_holy.menu.on_render_control_panel
  }
  ```
Core Modules
File Structure: Place core functionality in core/[module_name].lua.
Example:
```lua
-- core/humanizer.lua
FS.humanizer = {
    next_run = 0,
}
```
Spell Rotation Logic
Priority System
Implementation: Define priority checks in on_update functions.
Example:
```lua
-- classes/paladin/holy/logic/index.lua
function FS.paladin_holy.logic.on_update()
    if not FS.paladin_holy.settings.is_enabled() then return end
    if FS.paladin_holy.logic.rotations.avenging_crusader() then return end
    if FS.paladin_holy.logic.rotations.healing() then return end
    if FS.paladin_holy.logic.rotations.damage() then return end
end
```
Spell Casting
Function Guidelines: Use FS.api.spell_queue:queue_spell_target for spell casting.
Example:
```lua
-- classes/paladin/holy/logic/spells/judgment.lua
function FS.paladin_holy.logic.spells.judgment()
    local target = FS.variables.enemy_target()
    if not target then return false end
    FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.judgment, target, 1)
    return true
end
```
Menu System
Menu Configuration
File Structure: Define menu elements in menu.lua.
Example:
```lua
-- classes/paladin/holy/menu.lua
FS.paladin_holy.menu = {
    enable_toggle = FS.menu.keybind(999, false, "paladin_holy_enable_toggle"),
    settings_window = FS.menu.window("paladin_holy_settings"),
}
```
Settings UI
Implementation: Create sliders and checkboxes for configurable settings.
Example:
```lua
-- classes/paladin/holy/menu.lua
FS.paladin_holy.menu.hs_hp_threshold_slider = FS.menu.slider_int(1, 100, 85, "paladin_holy_hs_hp_threshold_slider")
```
Utility Modules
Cooldown Tracker
Usage: Use cooldown_tracker.lua to track spell cooldowns.
Example:
```lua
-- core/modules/cooldown_tracker.lua
function cooldown_tracker:has_any_relevant_defensive_up(unit)
    -- Check defensive cooldowns
end
```
Spell Helper
Usage: Use spell_helper.lua for spell validation and casting.
Example:
```lua
-- core/api.lua
FS.api.spell_helper = require("common/utility/spell_helper")
```
Example: Paladin Holy Rotation
Healing Rotation
Implementation: Define healing logic in rotations/healing.lua.
Example:
```lua
-- classes/paladin/holy/logic/rotations/healing.lua
function FS.paladin_holy.logic.rotations.healing()
    if FS.paladin_holy.logic.spells.avenging_crusader() then return true end
    if FS.paladin_holy.logic.spells.divine_toll() then return true end
    if FS.paladin_holy.logic.spells.beacon_of_virtue() then return true end
    if FS.paladin_holy.logic.spells.holy_prism() then return true end
    if FS.paladin_holy.logic.spells.holy_arnament() then return true end
    if FS.paladin_holy.logic.spells.spend_holy_power(true) then return true end
    if FS.paladin_holy.logic.spells.judgment() then return true end
    if FS.paladin_holy.logic.spells.holy_shock() then return true end
    if FS.paladin_holy.logic.spells.crusader_strike() then return true end
    if FS.paladin_holy.logic.spells.hammer_of_wrath() then return true end
    if FS.paladin_holy.logic.spells.consecration() then return true end
    return false
end
```
Damage Rotation
Implementation: Define damage logic in rotations/damage.lua.
Example:
```lua
-- classes/paladin/holy/logic/rotations/damage.lua
function FS.paladin_holy.logic.rotations.damage()
    if FS.paladin_holy.logic.spells.judgment() then return true end
    if FS.paladin_holy.logic.spells.crusader_strike() then return true end
    if FS.paladin_holy.logic.spells.hammer_of_wrath() then return true end
    if FS.paladin_holy.logic.spells.consecration() then return true end
    return false
end
```