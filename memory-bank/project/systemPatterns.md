# System Patterns

## Pattern 1: Memory Bank Initialization (Updated by Task task-20250209-1816-001)
* **Context:** When a new project is started, a memory bank needs to be initialized to store project-related information.
* **Problem:** How to structure and organize the project's memory bank to ensure that all necessary information is stored in a consistent and easily accessible manner.
* **Solution:** Create a directory structure with the following files:
    * memory-bank/project/projectScope.md: Stores the project scope.
    * memory-bank/project/requirements.md: Stores the project requirements.
    * memory-bank/project/constraints.md: Stores the project constraints.
    * memory-bank/currentTask.txt: Stores the ID of the current task.
    * memory-bank/tasks/[task-id]/taskDescription.md: Stores the description of the current task.
    * memory-bank/tasks/[task-id]/taskStatus.md: Stores the status of the current task.
* **Consequences:** Ensures that all project-related information is stored in a consistent and easily accessible manner.

## Pattern 2: Task Initialization (Updated by Task task-20250209-1816-001)
* **Context:** When a new task is started, the task needs to be initialized with a unique ID and a description.
* **Problem:** How to generate a unique task ID and store the task description in a consistent manner.
* **Solution:**
    * Generate a unique task ID using the current date and time.
    * Create a directory for the task under the memory-bank/tasks directory.
    * Create a taskDescription.md file in the task directory and store the task description in this file.
* **Consequences:** Ensures that all tasks are properly initialized and that their descriptions are stored in a consistent manner.