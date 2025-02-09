# Project Structure

```
.
├── .clinerules
├── .clinerules-dev
├── .clinerules-mb-init
├── .clinerules-po
├── .clinerules-re
├── .clinerules-reviewer
├── .clinerules-swe
├── .clinerules-task-init
├── .clinerules-tm
├── header.lua
├── main.lua
├── taskStatus_template.md
├── _api
│   ├── core.lua
│   ├── game_object.lua
│   ├── menu.lua
│   ├── common
│   │   ├── buff_db.lua
│   │   ├── color.lua
│   │   ├── enums.lua
│   │   ├── spell_attributes.lua
│   │   ├── talents_id.lua
│   │   ├── unit_manager.lua
│   │   ├── geometry
│   │   │   ├── geometry.lua
│   │   │   ├── vec2.lua
│   │   │   └── vec3.lua
│   │   └── modules
│   │       ├── buff_manager.lua
│   │       ├── combat_forecast.lua
│   │       ├── health_prediction.lua
│   │       ├── profiler.lua
│   │       ├── spell_prediction.lua
│   │       ├── spell_queue.lua
│   │       └── target_selector.lua
│   └── utility
│       ├── auto_attack_helper.lua
│       ├── control_panel_helper.lua
│       ├── cooldown_tracker.lua
│       ├── dungeons_helper.lua
│       ├── inventory_helper.lua
│       ├── key_helper.lua
│       ├── movement_handler.lua
│       ├── plugin_helper.lua
│       ├── pvp_helper.lua
│       ├── spell_helper.lua
│       ├── ui_buttons_info.lua
│       └── unit_helper.lua
├── _workflow
│   ├── HOWTO.md
│   └── README.md
├── classes
│   └── paladin
│       └── holy
│           ├── bootstrap.lua
│           ├── drawing.lua
│           ├── index.lua
│           ├── menu.lua
│           ├── settings.lua
│           ├── variables.lua
│           ├── ids
│           │   ├── auras.lua
│           │   ├── index.lua
│           │   ├── spells.lua
│           │   └── talents.lua
│           └── logic
│               ├── index.lua
│               ├── rotations
│               │   ├── avenging_crusader.lua
│               │   ├── damage.lua
│               │   ├── healing.lua
│               │   └── index.lua
│               └── spells
│                   ├── crusader_strike.lua
│                   ├── hammer_of_wrath.lua
│                   ├── index.lua
│                   └── judgment.lua
├── core
│   ├── api.lua
│   ├── humanizer.lua
│   ├── index.lua
│   ├── menu.lua
│   ├── settings.lua
│   ├── variables.lua
│   └── modules
│       └── heal_engine
│           ├── index.lua
│           ├── on_update.lua
│           ├── reset.lua
│           └── start.lua
├── entry
│   ├── check_spec.lua
│   ├── entry_helper.lua
│   ├── index.lua
│   ├── init.lua
│   ├── load_required_modules.lua
│   ├── load_spec_module.lua
│   └── callbacks
│       ├── index.lua
│       ├── on_render_control_panel.lua
│       ├── on_render_menu.lua
│       ├── on_render.lua
│       └── on_update.lua
├── interfaces
│   └── spec_config.lua
├── memory-bank
│   ├── dev
│   │   └── implementationGuides.md
│   ├── fs-rotations
│   │   ├── api_interfaces.md
│   │   ├── configuration_settings.md
│   │   ├── key_algorithms.md
│   │   ├── module_dependencies.md
│   │   └── project_structure.md
│   ├── po
│   │   └── systemPatterns.md
│   ├── re
│   │   ├── constraints.md
│   │   ├── projectScope.md
│   │   └── requirements.md
│   ├── review
│   │   └── reviewFeedback.md
│   ├── swe
│   │   ├── api_interfaces_template.md
│   │   ├── configuration_settings_template.md
│   │   ├── designPatterns.md
│   │   ├── key_algorithms_template.md
│   │   ├── module_dependencies_template.md
│   │   └── project_structure_template.md
│   ├── task-init
│   │   └── newTaskDescription.md
│   └── tm
│       └── taskStatus.md
└── taskStatus_template.md