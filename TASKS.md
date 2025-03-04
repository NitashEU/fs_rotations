# Herald of the Sun Implementation Tasks

## Core Mechanics Improvements

### 1. Sun's Avatar Beam System
- [x] Implement complete beam visualization in `drawing.lua`
  - Create line drawings between paladin and allies with Dawnlight
  - Add beam intersection highlighting
  - Implement visual radius indicator for optimal positioning
- [x] Create beam optimization algorithm in `dawnlight.lua`
  - Calculate optimal player positioning for maximum beam intersections
  - Add target priority based on raid role (tank > melee > ranged)
  - Implement distance-based targeting for better mastery benefit

### 2. Dawnlight Application Logic
- [x] Fix Dawnlight application during cooldowns in `dawnlight.lua`
  - Implement separate handling for Avenging Wrath (4 targets)
  - Implement separate handling for Awakening (1 target)
  - Add logic to avoid double-applying to targets that already have Dawnlight
- [x] Implement Holy Prism interaction properly
  - Track post-Holy Prism state more accurately with timer
  - Implement counter for the next 2 Holy Power spenders
  - Create targeting priority for optimal Dawnlight application

### 3. Holy Armaments System
- [x] Remove Holy Armaments System as it's not part of the Herald of the Sun spec
  - Removed `holy_arnament.lua`
  - Removed references in auras, spells, variables, and rotation files
  - Removed Sacred Weapon/Holy Bulwark references

### 4. Awakening Mechanics
- [x] Fix Awakening tracking in `variables.lua`
  - Replace hardcoded value with proper counter in `holy_prism.lua`
  - Track Holy Power spender count toward Awakening proc
  - Add visual indicator for Awakening progress (14/15, etc.)
- [x] Implement proper Awakening usage strategy
  - Add logic to use Holy Prism immediately before/after Awakening
  - Prioritize applying both Dawnlight HoTs quickly after Awakening

## Tracking System Improvements

### 5. Buff Tracking Enhancements
- [x] Implement complete Gleaming Rays tracking
  - Add duration tracking in `variables.lua`
  - Adjust spell priority when buff is active
  - Create visual indicator for active buff status
- [x] Implement Solar Grace tracking
  - Track stack count and duration
  - Create haste threshold calculation based on stack count
  - Add visual indicator showing current stack count
- [x] Implement Rising Sunlight tracking
  - Add cooldown duration tracking
  - Create Holy Power tracking during buff to avoid overcapping
  - Integrate with cooldown usage strategy

### 6. Holy Power Management
- [x] Refine Holy Power spender logic in `spend_holy_power.lua`
  - Implement Eternal Flame vs Light of Dawn decision based on healing need
  - Add Empyrean Legacy integration with proper target selection
  - Create threshold for single-target vs multi-target healing efficiency
- [x] Implement proper overcap prevention
  - Add predictive Holy Power tracking
  - Create warning indicator when approaching cap

## Visual Elements

### 7. UI Improvements
- [x] Create comprehensive Herald visualization in `drawing.lua`
  - Implement Sun's Avatar beam connections with proper colors
  - Add Dawnlight HoT indicators on targets with duration bars
  - Create Sacred Weapon/Holy Bulwark state indicator
  - Add Empyrean Legacy proc visualization
- [x] Add cooldown tracking UI elements
  - Create Avenging Wrath cooldown tracker
  - Add Holy Prism cooldown with Dawnlight application status
  - Implement Awakening progress tracker (x/15 Holy Power spenders)

### 8. Menu and Settings Updates
- [x] Fix namespace references in `menu.lua`
  - Replace all instances of `FS.paladin_holy.menu` with `FS.paladin_holy_herald.menu`
- [x] Add missing settings and sliders
  - Create `hs_critical_priority_slider` in menu and settings
  - Add `wog_critical_hp_threshold` setting
  - Implement comprehensive cooldown management options

## Spell Implementation

### 9. Holy Prism Enhancement
- [x] Update `holy_prism.lua` for Herald mechanics
  - Fix hardcoded Awakening value
  - Implement Rising Sunlight buff integration
  - Add target selection optimization for maximum healing effect
- [x] Create post-Holy Prism state tracking
  - Track the 2 Holy Power spender window accurately
  - Implement priority shift during this window to apply Dawnlight
  - Add visual indicator for "Dawnlight ready" state

### 10. Eternal Flame Implementation
- [x] Create dedicated `eternal_flame.lua` in `logic/spells/`
  - Implement HoT component tracking
  - Add integration with Empyrean Legacy
  - Create target selection logic based on HoT duration and health
- [x] Update Holy Power spending priority
  - Adjust Light of Dawn vs Eternal Flame thresholds
  - Implement overhealing prevention logic
  - Add efficient HoT application strategy

## Code Maintenance

### 11. Documentation
- [x] Add comprehensive comments to all Herald-specific files
  - Document beam optimization algorithm
  - Add explanations for spell priority decisions
  - Document Dawnlight application logic
- [x] Create README.md for Herald implementation
  - Add overview of implementation
  - Document design decisions
  - Add usage instructions

### 12. Final Review
- [x] Conduct comprehensive validation against guides
  - Verify all key mechanics are implemented
  - Confirm rotation priorities match guide recommendations
- [x] Fix bootstrap.lua spec_id and class_id
  - Update spec_id from 0 to correct value
  - Update class_id from 0 to correct value