# Requirements for Filling Memory Bank with Existing Project (fs_rotations)

## 1. Information to be Extracted

*   **Project Structure:** The file and directory structure of the project.
    *   Level of Detail: A complete listing of all files and directories, with a brief description of the purpose of each directory.
    *   Tools and Technologies: The `list_files` tool can be used to extract the file and directory structure. The information can be stored in a Markdown file with a tree-like representation.
*   **Module Dependencies:** The dependencies between different modules, as defined by the `require` statements.
    *   Level of Detail: A list of all `require` statements, showing which modules depend on which other modules.
    *   Tools and Technologies: The `read_file` and `search_files` tools can be used to identify the `require` statements. The information can be stored in a Markdown file with a graph representation.
*   **API Interfaces:** The functions and data structures exposed by the `FS.api` table.
    *   Level of Detail: A list of all functions and data structures exposed by the `FS.api` table, with a brief description of their purpose and parameters.
    *   Tools and Technologies: The `read_file` tool can be used to extract the functions and data structures exposed by the `FS.api` table. The information can be stored in a Markdown file with a list of the functions and data structures.
*   **Key Algorithms:** The algorithms used for rotation logic, combat forecasting, and other core functionalities.
    *   Level of Detail: A high-level description of the key algorithms used in the plugin, with links to the relevant code.
    *   Tools and Technologies: The `read_file` tool can be used to extract the code for the key algorithms. The information can be stored in a Markdown file with a description of the algorithms and links to the relevant code.
*   **Configuration Settings:** The settings and parameters used to configure the plugin.
    *   Level of Detail: A list of all configuration settings and parameters, with a brief description of their purpose and possible values.
    *   Tools and Technologies: The `read_file` tool can be used to extract the configuration settings and parameters. The information can be stored in a Markdown file with a list of the settings and parameters.

## 2. Format and Organization for Storing Information

*   **Project Structure:** A tree-like representation of the file and directory structure, with links to the corresponding files.
*   **Module Dependencies:** A graph representation of the module dependencies, showing which modules depend on which other modules.
*   **API Interfaces:** A list of the functions and data structures exposed by the `FS.api` table, with descriptions of their purpose and usage.
*   **Key Algorithms:** A description of the key algorithms used in the plugin, with links to the relevant code.
*   **Configuration Settings:** A list of the configuration settings and parameters, with descriptions of their purpose and possible values.