# Implementation Guide for Filling Memory Bank with Existing Project (fs_rotations)

This document describes the implementation details for filling the memory bank with the existing project (fs_rotations).

## Code Locations

*   **Project Structure:** The project structure is extracted using the `list_files` tool and stored in `memory-bank/fs-rotations/project_structure.md`. The output is formatted as a tree-like representation.
*   **Module Dependencies:** The module dependencies are extracted using the `search_files` tool and stored in `memory-bank/fs-rotations/module_dependencies.md`. The output is formatted as a structured list.
*   **API Interfaces:** The API interfaces are extracted by reading the `core/api.lua` file and stored in `memory-bank/fs-rotations/api_interfaces.md`. The output includes a description of the parameters and return values for each function.
*   **Key Algorithms:** The key algorithms are extracted by reading the files in `classes/paladin/holy/logic/rotations/` and stored in `memory-bank/fs-rotations/key_algorithms.md`. The output includes a more detailed description of the algorithm and its implementation.
*   **Configuration Settings:** The configuration settings are extracted by reading the `core/settings.lua` and `classes/paladin/holy/settings.lua` files and stored in `memory-bank/fs-rotations/configuration_settings.md`. The output includes the possible values for each setting.

## Integration Points

*   The extracted information is stored in Markdown files in the `memory-bank/fs-rotations/` directory.
*   The Markdown files are linked to from the `memory-bank/dev/implementationGuides.md` file.

## Specific Implementation Choices

*   The `list_files` tool is used to extract the project structure because it provides a complete listing of all files and directories in the project.
*   The `search_files` tool is used to extract the module dependencies because it can identify all `require` statements in the project.
*   The `read_file` tool is used to extract the API interfaces and configuration settings because it can read the contents of the relevant files.
*   The extracted information is stored in Markdown files because Markdown is a simple and easy-to-read format.