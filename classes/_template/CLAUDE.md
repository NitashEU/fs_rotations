# New Class/Spec Implementation Template

## Directory Structure
```
classes/{class_name}/{spec_name}/
  ├── bootstrap.lua       # Module initialization
  ├── drawing.lua         # Visualization
  ├── index.lua           # Entry point
  ├── menu.lua            # Settings UI
  ├── settings.lua        # Default settings
  ├── variables.lua       # Runtime state
  ├── ids/
  │   ├── auras.lua       # Buff/debuff IDs
  │   ├── index.lua       # ID exports
  │   ├── spells.lua      # Spell IDs
  │   └── talents.lua     # Talent IDs
  └── logic/
      ├── index.lua       # Logic exports
      ├── rotations/      # Rotation implementations
      │   └── index.lua   # Rotation exports
      └── spells/         # Spell implementations
          └── index.lua   # Spell exports
```

## Implementation Checklist
- [ ] Create directory structure
- [ ] Define spell/aura/talent IDs
- [ ] Implement spell casting logic
- [ ] Implement rotation priority
- [ ] Implement settings UI
- [ ] Implement runtime state tracking
- [ ] Add visualization support
- [ ] Test with different talent combinations
- [ ] Optimize for performance

## Standards
- Follow naming conventions (snake_case)
- Implement strong type checking
- Document all functions and return values
- Validate all input parameters
- Handle edge cases and errors gracefully
- Follow existing module patterns