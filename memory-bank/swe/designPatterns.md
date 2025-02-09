# Design Patterns for Filling Memory Bank with Existing Project (fs_rotations)

## 1. Information Architecture

The memory bank should be located in the `memory-bank/fs_rotations` directory.

The memory bank should contain the following files:

*   `memory-bank/fs_rotations/project_structure.md`: A tree-like representation of the file and directory structure, with relative links to the corresponding files and a brief description of the purpose of each directory.
*   `memory-bank/fs_rotations/module_dependencies.md`: A graph representation of the module dependencies, showing which modules depend on which other modules, implemented using Mermaid syntax within the Markdown file.
*   `memory-bank/fs_rotations/api_interfaces.md`: A list of the functions and data structures exposed by the `FS.api` table, with descriptions of their purpose and usage.
*   `memory-bank/fs_rotations/key_algorithms.md`: A description of the key algorithms used in the plugin, with links to the relevant code.
*   `memory-bank/fs_rotations/configuration_settings.md`: A list of the configuration settings and parameters, with descriptions of their purpose and possible values.

## 2. Templates

*   Project Structure: `memory-bank/swe/project_structure_template.md`
*   Module Dependencies: `memory-bank/swe/module_dependencies_template.md`
*   API Interfaces: `memory-bank/swe/api_interfaces_template.md`
*   Key Algorithms: `memory-bank/swe/key_algorithms_template.md`
*   Configuration Settings: `memory-bank/swe/configuration_settings_template.md`

## 3. Metadata and Tagging Scheme

The following metadata and tags should be used:

*   **File Type:** This metadata should indicate the type of information stored in the file (e.g., Project Structure, Module Dependencies, API Interfaces, Key Algorithms, Configuration Settings).
*   **Module Name:** This tag should be used to identify the module that the information is related to.
*   **Function Name:** This tag should be used to identify the function that the information is related to.
*   **Algorithm Name:** This tag should be used to identify the algorithm that the information is related to.
*   **Setting Name:** This tag should be used to identify the setting that the information is related to.

Example:

```markdown
# Project Structure

File Type: Project Structure

## Directory: classes

Description: Contains the implementation of different classes and specs.

Module Name: classes

### File: classes/paladin/holy/index.lua

Description: Main file for the Holy Paladin class.

Module Name: classes
Function Name: None
```

## 4. Using the Templates

To create the initial memory bank content, follow these steps:

1.  Create a new file in the `memory-bank/fs_rotations` directory for each type of information (e.g., `memory-bank/fs_rotations/project_structure.md`).
2.  Copy the content of the corresponding template file (e.g., `memory-bank/swe/project_structure_template.md`) into the new file.
3.  Replace the placeholders in the template (e.g., `[Directory Name]`, `[File Name]`, `[Description]`) with the actual information from the `fs_rotations` project.
4.  Add the appropriate metadata and tags to the file.

## 5. Handling Errors and Exceptions

During the information extraction process, errors or exceptions may occur due to various reasons, such as file not found, invalid file format, or unexpected data. To handle these errors, the following approach should be followed:

1.  Use `pcall` to wrap the code that may raise an error.
2.  If an error occurs, log the error message and the file name to a separate log file (e.g., `memory-bank/fs_rotations/extraction_errors.log`).
3.  Continue with the extraction process for the remaining files.
4.  After the extraction process is complete, review the log file and manually correct any errors or inconsistencies in the extracted information.

## 6. Validating Extracted Information

To ensure that the extracted information is accurate and complete, the following validation steps should be performed:

1.  For the project structure, verify that all files and directories are listed in the `project_structure.md` file.
2.  For the module dependencies, verify that all `require` statements are listed in the `module_dependencies.md` file and that the dependencies are correctly represented.
3.  For the API interfaces, verify that all functions and data structures exposed by the `FS.api` table are listed in the `api_interfaces.md` file and that their descriptions are accurate.
4.  For the key algorithms, verify that the descriptions of the algorithms are accurate and that the links to the relevant code are correct.
5.  For the configuration settings, verify that all configuration settings and parameters are listed in the `configuration_settings.md` file and that their descriptions and possible values are accurate.

If the validation steps reveal that the extracted information is inaccurate or incomplete, the Developer should correct the errors manually. Re-running the extraction process may overwrite manual corrections and is therefore not recommended.