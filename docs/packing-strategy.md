# Packing Strategy for fs_rotations

## Overview
This document outlines the strategy for creating distributable packages of the fs_rotations codebase.

## Files to Include
- `classes/` directory and subdirectories
- `core/` directory and subdirectories
- `entry/` directory and subdirectories
- Root files:
  - `header.lua`
  - `main.lua`

## Files to Exclude
- `_api/` directory
- `memory-bank/` directory
- `docs/` directory
- `.gitignore`
- `README.md`
- Any temporary or build files
- The packing script itself

## Implementation Requirements
The packing script should:
1. Create a temporary staging directory
2. Copy only the required files while preserving directory structure
3. Create a zip archive named `fs_rotations.zip`
4. Clean up temporary files after packaging
5. Provide feedback on the packaging process

## Script Location
The script should be placed in the root directory as `pack.ps1` (PowerShell) since we're on Windows.

## Usage
The script will be executed from the root directory and will automatically handle all packaging steps.