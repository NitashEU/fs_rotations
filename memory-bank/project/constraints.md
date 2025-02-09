# Initial Constraints

*   When using script-specific functions and modules from the "common" folder, use `require("common/**/*")`.
*   The interfaces are in `_api/common/**/*`.
*   The three files in `_api` itself do not need to be required.
*   Requiring something from the plugin itself has to be absolute in the require statement.

## Constraint 1 (Updated by Task task-20250209-1816-001)
* The task must be completed within the current working directory.