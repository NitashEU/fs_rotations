# Changelog

All notable changes to FS Rotations will be documented in this file.
## [1.13.0] - 2025-02-25
## [1.12.0] - 2025-02-25
## [1.11.0] - 2025-02-25
## [1.10.4] - 2025-02-25
### Changed## [1.10.3] - 2025-02-25
- restructure heal engine with domain-oriented separation of concerns### Fixed
- Implement comprehensive input validation for heal engine target selection functions

## [1.10.2] - 2025-02-25
### Performance
- Implement position caching in heal engine for target selection

## [1.10.1] - 2025-02-25
### Fixed
- Update commit.sh script for macOS sed compatibility

## [1.10.0] - 2025-02-25

### Added
- add comprehensive performance metrics system with profiling and memory tracking- enhance error handler with stack traces, progressive backoff, and UI improvements- add standardized validation library- Robust error handling and exception boundaries system
- Error recovery mechanisms for all callbacks
- Visual error reporting in UI
- Automatic component disabling after repeated errors
- Error tracking and management

## [1.9.0] - 2025-02-25

### Added
- Centralized versioning system
- Automatic changelog generation
- Version display in UI
- Version-based settings migration
- Version compatibility checking

## [1.8.0] - 2025-02-25

### Added
- Holy Paladin rotation implementation
- Advanced healing prediction engine
- Damage tracking and forecasting
- Priority-based spell casting system
- Buff/debuff management
- Combat state forecasting
- Spell queue system
- Intelligent target selection

### Changed
- Improved clustered heal target selection
- Extracted DPS calculation helpers into separate functions

### Fixed
- Menu rendering for Holy Paladin spec

## [1.7.0] - 2025-02-10

### Added
- Initial version