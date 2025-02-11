# System Patterns: Holy Paladin Rotation Plugin

## Architecture Overview
1. Core Systems
   - Entry System: Plugin initialization and lifecycle
     * Plugin validation and metadata handling
     * Dynamic module loading
     * Callback registration
   - Heal Engine: Target selection and healing logic
   - Rotation System: Spell priority and execution
   - Settings Management: Configuration and persistence
   - Humanizer System: Natural delay and jitter management

2. Module Organization
   - Core modules: Base functionality and shared systems
     * API Integration (api.lua)
     * Humanizer Logic (humanizer.lua)
     * Menu System (menu.lua)
     * Settings Management (settings.lua)
     * Variable Handling (variables.lua)
   - Class modules: Specialization-specific implementations
     * IDs (spells, auras, talents)
     * Logic (rotations, spells)
     * Settings and UI
     * Variables and state
   - Utility modules: Helper functions and common tools

## Design Patterns
1. Module Pattern
   - Encapsulated functionality
   - Clear interfaces
   - Dependency management
   - Lazy loading optimization

2. Observer Pattern
   - Event-driven updates
   - Game state monitoring
   - Performance optimization
   - Callback system

3. Strategy Pattern
   - Three-tiered rotation system
     * Avenging Crusader priority
     * Healing rotation
     * Damage rotation
   - Pluggable healing strategies
   - Flexible target selection
   - Dynamic spec loading

4. Facade Pattern (Core API)
   - Unified interface to game systems
   - Abstracted complexity
   - Consistent access patterns
   - Centralized dependency management

5. Weight System Pattern
   - Parameterized scoring weights
   - Normalized weight calculations
   - Optional component weighting
   - Spec-specific weight configurations
   - Linear distance scoring model

## Component Relationships
1. Entry System → Module Loading → Rotation Logic
   - Validation → Dependencies → Spec Module
   - Error Handling → Recovery → Fallback
2. Heal Engine → Target Selection → Spell Execution
   - Weight System → Target Scoring → Selection
   - Enemy Target → Allied Healing → Position-based Calculations
3. Settings → Configuration → Runtime Behavior
4. Core API → Game Interface → Plugin Logic
5. Humanizer → Delay Management → Action Execution
6. Rotation System → Spell Logic → Target Selection

## Technical Decisions
1. Modular architecture for maintainability
2. Performance-first design approach
3. Clear separation of concerns
   - IDs module for constants
   - Logic module for rotations
   - Settings for configuration
   - Variables for state
4. Robust error handling
5. Efficient initialization process
6. Progressive module loading
7. Humanized action timing
   - Dynamic delay calculation
   - Latency-aware jitter
   - Configurable boundaries
8. Unified menu system
   - Consistent ID prefixing
   - Type-safe menu elements
   - Hierarchical organization
9. Flexible targeting system
   - Configurable weight parameters
   - Normalized scoring calculations
   - Optional component weighting
   - Linear distance scoring model
   - Enemy-to-ally healing patterns
   - Position-based range calculations

## Core API Integration
1. Buff Management
   - Buff tracking
   - Aura monitoring
   - Duration management
2. Combat Systems
   - Spell queueing
   - Custom heal engine
   - Custom predictions
3. Target Selection
   - Smart targeting with weights
   - Unit validation
   - Combat range checks
   - Distance-based scoring
   - Enemy target integration
   - Position-based healing
4. Utility Systems
   - Spell helpers
   - Unit helpers
   - Plugin helpers
   - Control panel integration
   - Key binding management

## Implementation Patterns
1. Type Safety
   - Comprehensive annotations
   - Interface definitions
   - Runtime validation

2. State Management
   - Centralized variables
   - Clear state transitions
   - Predictable updates

3. Error Handling
   - Graceful degradation
   - Clear error boundaries
   - Recovery mechanisms

4. Performance Optimization
   - Efficient calculations
   - Smart caching
   - Minimal overhead

5. Weight System Implementation
   - Parameter-based weight configuration
   - Runtime weight normalization
   - Optional component weighting
   - Default weight fallbacks
   - Linear distance scoring

6. Target Selection Patterns
   - Direct target selection
   - Enemy-based allied healing
   - Position-based calculations
   - Flexible range validation
   - Spell queueing integration