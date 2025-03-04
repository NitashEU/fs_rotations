# Holy Herald Implementation Learnings

## Eternal Flame Implementation (Task 10)

### HoT Management Strategies
- **Target Scoring System**: Developed a multi-factor scoring system that combines health percentage, role, position, and incoming damage to prioritize targets for HoT application.
- **HoT Duration Tracking**: Created visual duration tracking for Eternal Flame HoTs that dynamically handles multiple targets and positions indicators to avoid UI overlapping.
- **Stack Count Management**: Implemented limit-based application strategy (max 3 targets) with diminishing returns for reapplication to ensure efficient resource usage.

### Resource Optimization Patterns
- **Efficiency Calculation**: Designed a weighted efficiency calculation for Holy Power spending decisions between Light of Dawn and Eternal Flame.
- **Varying Threshold System**: Created threshold deltas that require higher value differences when resources are limited versus being at risk of overcapping.
- **Adaptive Prioritization**: Implemented context-aware prioritization that shifts spending patterns based on buff states, group health, and incoming resource gains.

### Visual Feedback Systems
- **Stacked UI Elements**: Designed non-overlapping feedback systems when multiple HoTs are present on the same target.
- **Status Indication**: Used color schemes and pulsing effects to indicate HoT status (expiring soon vs significant duration remaining).
- **Graphical Icons**: Created flame-style graphics to visually distinguish different HoT types at a glance.

### Coordination with Other Systems
- **Empyrean Legacy Integration**: Added special handling for Empyrean Legacy procs with Eternal Flame for enhanced single-target healing.
- **Holy Power Prediction**: Enhanced Holy Power tracking to factor in both Rising Sunlight and standard regeneration mechanics.
- **Resource Generation Forecasting**: Added systems to estimate future resource generation for better spend/save decisions.

## Holy Prism Enhancement (Task 9)

### Dynamic Thresholding
- **Buff-Aware Healing Thresholds**: Implemented different healing thresholds based on buff status, making Holy Prism more effective when Rising Sunlight is active.
- **Adaptive Target Requirements**: Reduced minimum target requirements when in specific states (post-Holy Prism) to ensure Dawnlight application consistency.

### State Tracking
- **Improved Window Tracking**: Extended the post-Holy Prism state window from 10 to 15 seconds, providing more flexibility for players to apply Dawnlight effects.
- **Counter Mechanisms**: Implemented accurate tracking for Holy Power spenders after Holy Prism cast with proper increment mechanisms.
- **Target Memory**: Added last target tracking to enhance analytics and future targeting decisions.

### Visual Feedback Systems
- **Pulse Effect Visualization**: Created a pulsing sun-like indicator that clearly shows when players are in the Dawnlight application state.
- **Countdown Indicators**: Added remaining spender count to the visual indicator so players know exactly how many more Holy Power spenders they can use.
- **2D UI Integration**: Used specialized 2D drawing APIs for cleaner UI rendering that doesn't clutter the 3D game world.

### Conditional Logic
- **Multi-Check Validations**: Replaced simple conditions with comprehensive validation chains that consider settings, buff states, and game conditions.
- **Prioritization Logic**: Created a hierarchy of importance for different spell usage cases based on situational factors.

### Code Organization
- **Helper Functions**: Created utility functions like `should_prioritize_dawnlight()` to encapsulate complex condition checking and improve readability.
- **Centralized Settings**: Ensured consistent behavior by reading from settings rather than hardcoding values.
- **Predictive Resource Management**: Added Holy Power prediction during Rising Sunlight to better manage resources and prevent overcapping.

## Codebase Cleanup Techniques

### Removal Process
- When removing features, check all file types for references: spells, auras, variables, talents, menu files
- Add clear comments to indicate why a feature was removed
- Use grep to find all references that need to be updated
- Leave placeholder comments in require statements and empty lines to maintain code structure
- Check for namespace variables and remove them while preserving any necessary structure

### Dependency Management
- Understand relationships between related files before removing code
- Remove features in a specific order: implementation files first, then references, then config
- Comment out rather than delete when unsure about dependencies
- Check rotation files for dependencies on removed features
- Make code review easier by explaining the rationale for removals

## Spell Window Tracking

### State Management Techniques
- Combine timestamps and counters for complete state tracking (e.g., `last_spell_time` + `actions_since_spell`)
- Define constants for window parameters to make them configurable (e.g., `max_actions_window = 2`)
- Create dedicated reset functions for starting new sequences (keeps tracking logic in one place)
- Use time-based cutoffs alongside counter limits for more precise control

### Cross-Spell Interaction Patterns
- Increment counters at consumption points in all relevant spell functions
- Create centralized state query functions that check multiple conditions
- Design state systems that work across multiple files with consistent behavior
- Pass context information between scoring and action functions

## Target Selection & Scoring

### Scoring Function Design
- Make scoring functions accept optional priority parameters for flexibility
- Use early exits for ineligible targets to improve performance
- Implement different scoring logic for different states using conditionals
- Weight multiple factors (role, health, position) with tunable parameters

### Buff Application Strategies
- Check remaining buff slots before starting application logic
- Factor "urgency" into priority calculations when resources are limited
- Sort targets by computed score and use slicing to select the top N
- Create specialized handling for different cooldown states

## Code Structure and API Patterns

### API Access Patterns
- **Unit and position data**: Use unit objects directly with methods like `unit:get_position()` instead of `core.unit_manager.get_unit_position(unit)`
- **Buff checking**: Use `FS.variables.buff_up(aura_id, unit)` to check buffs on any unit, not just the player
- **Time handling**: Use `core.time() / 1000` instead of `GetTime()` to get current time in seconds

### Namespace Structure
- Properly reference the correct namespace for Holy Herald (`FS.paladin_holy_herald` not `FS.paladin_holy`)
- Follow namespace hierarchy for accessing data (spells, auras, talents, variables)
- Use consistent patterns across files in the same spec

### Type Safety & Compatibility
- Add proper buff IDs to auras.lua instead of hardcoding them
- Avoid using talent IDs where aura IDs are expected
- Leverage optional parameters to make functions more flexible (like `unit?` in `buff_up()`)

## Code Improvements and Fixes Made

1. **Fixed unit object position access**:
   - Changed from `core.unit_manager.get_unit_position(unit)` to `unit:get_position()`

2. **Extended buff checking API**:
   - Updated core FS.variables functions to handle unit parameters:
     ```lua
     function FS.variables.buff_up(spell_id, unit)
         unit = unit or FS.variables.me
         return buff_manager:get_buff_data(unit, { spell_id }).is_active
     end
     ```

3. **Fixed time handling**:
   - Replaced `GetTime()` with `core.time() / 1000` for proper time handling in seconds

4. **Fixed namespace references**:
   - Updated all instances of `FS.paladin_holy` to `FS.paladin_holy_herald` in menu.lua
   - Discovered and fixed namespace issues in judgment.lua and other spell files

5. **Added missing aura IDs**:
   - Added Empyrean Legacy aura ID to the proper auras.lua file
   - Added Awakening stacks aura ID (414196) to track progression toward Awakening proc

6. **Improved buff tracking**:
   - Implemented comprehensive Awakening stack and proc tracking
   - Used the `buff_stacks()` API for accurate state tracking instead of manual counters

7. **Enhanced UI visualization**:
   - Added dynamic colored indicators for Awakening progress
   - Created configurable UI elements in the settings menu

8. **Implemented priority queuing**:
   - Used priority 0 for highest priority spells (like Judgment with Awakening max)
   - Created logic to ensure critical gameplay moments get proper spell priorities

## Enhanced Buff Tracking Patterns

### Resource Prediction
- Model future resource states using rate-based calculations to predict overcapping
- Create thresholds for adaptive behavior based on predicted resources
- Use timestamp tracking to calculate time spent in a specific state
- Distinguish between different "modes" of operation based on buff states
- Include ability cooldowns in resource prediction models
- Factor in the player's position and targeting state when predicting resources

### Resource Management
- Create clear distinction between critical (must-spend) and optimal (should-spend) states
- Implement tiered priorities based on resource levels (0: critical, 1: normal, 2: low priority)
- Consider multiple resource generators when building prediction models
- Design state transitions that adapt to changing gameplay conditions
- Build escalating warning systems as resources approach caps

### Visual Representation Systems
- Position related information close together but not overlapping
- Use color coding consistently across all indicators (red = warning, green = good)
- Include numerical values alongside visual indicators when precision matters
- Create pulsing effects by using sine waves with time functions
- Scale UI elements based on importance and information density

### Priority Adjustment
- Use different priority levels (0 for critical, 1+ for normal operations)
- Dynamically adjust priorities based on game state and buffs
- Create multi-factor decision trees that combine different buff states
- Implement "phase transitions" when entering/exiting buff windows

## Best Practices

### For API Usage
- Use the highest level API available (prefer FS.variables over direct core access)
- Maintain consistent patterns across similar functionalities
- Follow existing patterns in the codebase
- Use proper type casting when dealing with return values that might be nil

### For Buff and State Management
- Store buff IDs in auras.lua, not hardcoded in functions
- Use consistent buff checking methods
- Create helper functions for complex state checks
- Implement multi-tier state tracking (up/down, duration, stacks, effects)

### Performance Optimization
- Calculate complex values only when needed
- Cache results that won't change frequently
- Use early returns to avoid unnecessary calculations
- Keep track of intersection between buffs to optimize decision making
- Avoid redundant iterations through unit lists when multiple checks are needed
- Implement smarter target selection that eliminates non-viable targets early
- Skip expensive validation steps when in critical situations that require immediate action
- Use conditional evaluation paths with different performance characteristics based on urgency

### UI/UX Design
- Group related settings together in the UI
- Provide tooltips that explain functionality
- Use consistent naming patterns for settings and functions
- Position visual indicators in a way that minimizes eye movement
- Use color transitions to represent state changes (red → yellow → green)
- Apply visual scaling and pulsing to draw attention to critical information
- Create multi-level visual systems (text + icons + highlighting)
- Design information density appropriate to the importance of the data
- Provide configurable visualization layers that can be toggled independently
- Draw connections between related elements to show relationships

### Spatial Visualization Techniques
- Use 3D positioning to create distinct visual layers
- Implement ground-level indicators for positioning information
- Create floating text for status information at eye level
- Use animation to indicate urgency or importance
- Draw connecting lines to show relationships between units
- Visualize buff duration using both text and progress bars
- Create intersection indicators to highlight crucial positioning

### General Code Quality
- Fix one issue at a time, test, then proceed
- Look for patterns in existing implementation before creating new solutions
- Extend existing APIs rather than creating separate patterns
- Use proper typing and comments for function parameters
- Create self-documenting code with clear variable names
- Separate decision logic from execution logic to improve testability and readability
- Build helper functions with clear single responsibilities
- Maintain consistent error handling throughout the codebase
- Design interfaces that minimize cross-file dependencies

### Self-Review Techniques
- Approach code review as if you didn't write the code yourself
- Look for edge cases that might not be handled properly
- Question assumptions about external dependencies
- Check for performance bottlenecks in common execution paths
- Validate that user-facing elements provide clear feedback
- Review naming for consistency and clarity
- Consider how the code will evolve with future changes
- Look for places where error conditions might be improperly handled

These learnings will help make future implementations more consistent and less prone to errors.