# Active Context: Holy Paladin Rotation Plugin

## Current Focus
1. Heal engine implementation is primary focus
   - Target selection logic optimization in progress
   - Clustered healing calculations being refined
   - Performance optimization ongoing
   - Health prediction system integration
2. Core systems implementation stable
3. Rotation logic implementation progressing
   - Holy Prism implementation in progress
     * Cast on enemy target, radiates healing to allies
     * Uses heal engine for target selection
     * Integrates with Beacon of Virtue mechanics
     * Prioritizes targets without BoV buff
     * 30-yard radius, 5 target maximum

## Recent Changes
1. Heal engine development advancing
   - Target selection algorithms implemented
   - Clustered healing logic developed
   - Health prediction integration started
   - Performance optimization initiated
2. Documentation maintained and updated
3. Core systems stability verified
4. Module integration progressing

## Next Steps
1. Complete heal engine optimization
   - Finalize target selection algorithms
   - Implement advanced healing strategies
   - Complete health prediction integration
   - Optimize performance metrics
2. Enhance rotation logic modules
   - Implement Holy Prism with heal engine integration
   - Add talent-based variations
   - Optimize priority system
3. Expand configuration interface
4. Implement testing framework

## Active Decisions
1. Heal engine optimization strategy
   - Focus on performance-critical paths
   - Optimize target selection algorithms
   - Enhance prediction accuracy
   - Balance CPU usage with effectiveness
2. Module organization maintained
   - Separate concerns (IDs, logic, settings, UI)
   - Three-tiered rotation system
   - Type-safe implementations
3. Configuration management system
   - Type-safe settings
   - Runtime validation
4. Documentation standards
   - Comprehensive type annotations
   - Clear module interfaces

## Current Considerations
1. Target selection algorithm efficiency
2. Health prediction accuracy vs performance
3. Clustered healing optimization
4. Memory usage optimization
5. CPU performance impact
6. Error handling robustness
7. Talent build adaptations
8. Holy Prism mechanics
   - Enemy target selection with heal engine
   - Ally healing radiation patterns
   - Beacon of Virtue buff tracking across raid
   - Priority system for unbuffed targets