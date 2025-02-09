# System Patterns for Filling Memory Bank with Existing Project (fs_rotations)

## 1. Memory Bank Structure and Organization

The memory bank should be organized as follows:

*   **Project Structure:**
    *   File: `memory-bank/fs_rotations/project_structure.md`
    *   Content: A tree-like representation of the file and directory structure, with relative links to the corresponding files and a brief description of the purpose of each directory.
*   **Module Dependencies:**
    *   File: `memory-bank/fs_rotations/module_dependencies.md`
    *   Content: A graph representation of the module dependencies, showing which modules depend on which other modules, implemented using Mermaid syntax within the Markdown file.
*   **API Interfaces:**
    *   File: `memory-bank/fs_rotations/api_interfaces.md`
    *   Content: A list of the functions and data structures exposed by the `FS.api` table, with descriptions of their purpose and usage.
*   **Key Algorithms:**
    *   File: `memory-bank/fs_rotations/key_algorithms.md`
    *   Content: A description of the key algorithms used in the plugin, with links to the relevant code.
*   **Configuration Settings:**
    *   File: `memory-bank/fs_rotations/configuration_settings.md`
    *   Content: A list of the configuration settings and parameters, with descriptions of their purpose and possible values.

## 2. Tools and Technologies

The following tools and technologies should be used for extracting and storing information:

*   `list_files`: To extract the file and directory structure.
*   `read_file`: To extract the content of the files.
*   `search_files`: To identify the `require` statements.
*   Markdown: To store the extracted information in a structured format.

## 3. Review and Update Process

The process for reviewing and updating the memory bank content should be:

1.  The Developer extracts the information from the `fs_rotations` project and stores it in the corresponding files in the memory bank.
2.  The Reviewer reviews the content of the files for accuracy, completeness, and clarity.
3.  If the Reviewer finds any issues, they provide feedback to the Developer.
4.  The Developer addresses the feedback and updates the files in the memory bank.
5.  The Reviewer reviews the updated files.
6.  This process is repeated until the Reviewer is satisfied with the content of the files.
7.  The memory bank content is updated manually whenever the `fs_rotations` project is changed.