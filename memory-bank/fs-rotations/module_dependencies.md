# Module Dependencies

## header.lua

*   Requires: `entry/index`

## entry/check_spec.lua

*   Requires: `common/enums`

## entry/load_spec_module.lua

*   Requires: `common/enums`

## entry/load_required_modules.lua

*   Requires: `core/index`

## entry/callbacks/index.lua

*   Requires: `entry/callbacks/on_render_control_panel`
*   Requires: `entry/callbacks/on_render_menu`
*   Requires: `entry/callbacks/on_render`
*   Requires: `entry/callbacks/on_update`

## entry/index.lua

*   Requires: `entry/entry_helper`
*   Requires: `entry/check_spec`
*   Requires: `entry/init`
*   Requires: `entry/load_required_modules`
*   Requires: `entry/load_spec_module`
*   Requires: `entry/callbacks/index`

## entry/entry_helper.lua

*   Requires: `common/enums`

## core/index.lua

*   Requires: `core/api`
*   Requires: `core/humanizer`
*   Requires: `core/menu`
*   Requires: `core/settings`
*   Requires: `core/variables`

## core/api.lua

*   Requires: `common/modules/buff_manager`
*   Requires: `common/modules/combat_forecast`
*   Requires: `common/modules/health_prediction`
*   Requires: `common/utility/spell_helper`
*   Requires: `common/modules/spell_queue`
*   Requires: `common/utility/unit_helper`
*   Requires: `common/modules/target_selector`
*   Requires: `common/utility/plugin_helper`
*   Requires: `common/utility/control_panel_helper`
*   Requires: `common/utility/key_helper`

## classes/paladin/holy/bootstrap.lua

*   Requires: `classes/paladin/holy/index`

## entry/callbacks/on_render_menu.lua

*   Requires: `common/color`

## classes/paladin/holy/index.lua

*   Requires: `classes/paladin/holy/drawing`
*   Requires: `classes/paladin/holy/menu`
*   Requires: `classes/paladin/holy/settings`
*   Requires: `classes/paladin/holy/variables`
*   Requires: `classes/paladin/holy/ids/index`
*   Requires: `classes/paladin/holy/logic/index`

## core/settings.lua

*   Requires: `common/utility/plugin_helper`

## core/variables.lua

*   Requires: `common/enums`
*   Requires: `common/modules/buff_manager`

## classes/paladin/holy/logic/index.lua

*   Requires: `common/utility/spell_helper`
*   Requires: `classes/paladin/holy/logic/rotations/index`
*   Requires: `classes/paladin/holy/logic/spells/index`

## classes/paladin/holy/ids/index.lua

*   Requires: `classes/paladin/holy/ids/auras`
*   Requires: `classes/paladin/holy/ids/spells`
*   Requires: `classes/paladin/holy/ids/talents`

## classes/paladin/holy/variables.lua

*   Requires: `common/enums`

## core/modules/heal_engine/index.lua

*   Requires: `core/modules/heal_engine/on_update`
*   Requires: `core/modules/heal_engine/reset`
*   Requires: `core/modules/heal_engine/start`

## core/menu.lua

*   Requires: `common/utility/control_panel_helper`
*   Requires: `common/utility/key_helper`

## classes/paladin/holy/logic/rotations/index.lua

*   Requires: `classes/paladin/holy/logic/rotations/avenging_crusader`
*   Requires: `classes/paladin/holy/logic/rotations/healing`
*   Requires: `classes/paladin/holy/logic/rotations/damage`

## classes/paladin/holy/logic/spells/index.lua

*   Requires: `classes/paladin/holy/logic/spells/crusader_strike`
*   Requires: `classes/paladin/holy/logic/spells/judgment`
*   Requires: `classes/paladin/holy/logic/spells/hammer_of_wrath`

## _api/common/utility/inventory_helper.lua

*   Requires: `common/utility/spell_helper`