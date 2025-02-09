# Active Context

## Current Status
- Initial project setup and API documentation completed
- Memory Bank structure established
- Core interfaces documented
- Integration patterns documented
- Holy Paladin spec implementation in progress
  * Core structure implemented
  * Damage dealing capabilities added
  * Avenging Crusader rotation implemented
  * Spell queueing system integrated
  * Damage rotation priority system implemented
  * Hammer of Wrath added to damage rotation
  * Healing rotation structure initialized with damage spells
  * Judgment spell updated with awakening_max buff check

## Current Implementation Details
1. Holy Paladin Components
   - Variables tracking:
     * Holy Power resource
     * Avenging Crusader buff
     * Awakening Max buff (with remaining time)
     * Blessed Assurance buff
   - Spell implementations:
     * Judgment (regular with awakening_max check and AC version)
     * Crusader Strike (regular and AC version with Blessed Assurance check)
     * Hammer of Wrath (regular damage rotation only)
   - Rotations:
     * Avenging Crusader priority system (using AC-specific spells)
     * Damage rotation structure with implemented priority:
       1. Judgment
       2. Crusader Strike
       3. Hammer of Wrath
     * Healing rotation structure with damage spells:
       1. Judgment (with awakening_max check)
       2. Crusader Strike
       3. Hammer of Wrath

2. Core Systems Integration
   - Humanizer system for action delays
   - Menu system with UI controls
   - Settings management
   - Buff tracking system with remaining time support
   - Spell queueing system

## Next Steps
1. Complete healing rotation implementation:
   - Add healing spell implementations
   - Define healing priority system
   - Implement target selection logic
   - Add healing cooldown management

2. Complete damage rotation implementation:
   - Implement Holy Power spender logic
   - Add Holy Shock implementation
   - Add Consecration implementation

3. Enhance buff tracking:
   - Add additional aura IDs as needed
   - Add proc tracking system

4. Improve rotation logic:
   - Implement resource pooling logic
   - Add cooldown usage conditions

5. UI Enhancements:
   - Add rotation status display
   - Implement cooldown tracking UI
   - Add resource monitoring display

## Integration Requirements
1. Follow established buff tracking patterns
2. Implement proper error handling
3. Maintain performance optimization standards
4. Follow code organization best practices
5. Consider future extensibility

## Documentation Updates Needed
- Update Holy Paladin specific patterns in integrationPatterns.md
- Document damage rotation patterns
- Update apiReference.md with new utility functions
- Document buff tracking patterns
- Document healing rotation patterns and priorities (when implemented)

## Recent Changes
- Added empty healing rotation with damage spells (Judgment > Crusader Strike > Hammer of Wrath)
- Added awakening_max buff ID and tracking
- Updated judgment spell to check awakening_max buff (won't cast if > 4000ms remaining)
- Added buff remaining time support to core variables
- Added Hammer of Wrath spell implementation
- Updated damage rotation with new priority system
- Maintained separation between regular and Avenging Crusader rotations
- Added Hammer of Wrath to spells index
- Implemented damage rotation priority: Judgment > Crusader Strike > Hammer of Wrath