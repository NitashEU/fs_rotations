# Guide to Creating a New Class Spec

## Structure Overview
A new class spec requires the following file structure:
```
classes/[class_name]/[spec_name]/
├── bootstrap.lua        # Entry point, registers callbacks
├── drawing.lua          # Visual elements rendering
├── index.lua            # Requires all module files
├── menu.lua             # UI configuration
├── settings.lua         # Settings accessor functions
├── variables.lua        # Game state tracking
├── ids/
│   ├── auras.lua        # Buff/debuff IDs
│   ├── index.lua        # Requires ID files
│   ├── spells.lua       # Spell IDs
│   └── talents.lua      # Talent detection
└── logic/
    ├── index.lua        # Main rotation logic
    ├── rotations/
    │   ├── index.lua    # Requires rotation files
    │   └── [rotation_files].lua
    └── spells/
        ├── index.lua    # Requires spell files
        └── [spell_files].lua
```

## Implementation Steps

1. **Initialize Structure**
   - Copy the template directory structure
   - Update namespace to `FS.[class_name]_[spec_name]`

2. **Define IDs & Variables**
   - Populate spell, aura, and talent IDs
   - Create variables for game state tracking

3. **Implement Spell Logic**
   - Create individual spell implementations following pattern:
     ```lua
     ---@return boolean
     function FS.[class_name]_[spec_name].logic.spells.[spell_name]()
         -- 1. Early validation checks
         if not FS.api.spell_helper:is_spell_queueable(...) then
             return false
         end
         
         -- 2. Get settings from menu
         local threshold = FS.[class_name]_[spec_name].settings.[spell_name]_threshold()
         
         -- 3. Select appropriate target
         local target = FS.modules.heal_engine.get_single_target(...)
         if not target then
             return false
         end
         
         -- 4. Queue the spell
         FS.api.spell_queue:queue_spell_target(FS.[class_name]_[spec_name].spells.[spell_name], target, 1)
         return true
     end
     ```

4. **Create Rotation Logic**
   - Implement rotation strategies (healing, damage, cooldowns)
   - Set up priority system in each rotation

5. **Build UI Configuration**
   - Create menu elements (sliders, checkboxes, windows)
   - Organize settings logically by spell/function

6. **Setup Bootstrap**
   - Register required callbacks
   - Return a properly configured `SpecConfig`

## Key Design Patterns

- **Early Returns**: Validate conditions at the beginning of functions
- **Dynamic Thresholds**: Adjust spell usage thresholds based on game state
- **Target Selection**: Use appropriate heal engine methods for targeting
- **Priority System**: Implement clear rotation priorities

## Important Modules to Utilize

- `FS.api.spell_helper` - For spell validation and checking
- `FS.api.spell_queue` - For queuing spells with priorities
- `FS.modules.heal_engine` - For target selection
- `FS.variables` - For accessing common game state

## Testing Your Spec

1. Check all required IDs are correct
2. Verify all spell implementations follow the standard pattern
3. Test menu UI configuration
4. Ensure rotation priorities are correctly ordered