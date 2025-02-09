# HOWTO.md: Getting Started with the AI-Assisted Software Development Workflow in VS Code

This guide provides a step-by-step introduction to using the AI-assisted software development workflow within your VS Code extension.  It assumes the extension is already installed and configured with the `customModes` JSON and `.clinerules` files as described in the README.

## Prerequisites

*   **VS Code Extension Installed:** Ensure the AI-assisted development VS Code extension is properly installed and activated.
*   **Configuration Files in Place:** Verify that the `customModes` JSON configuration file and the `.clinerules` and `.clinerules-*` files are correctly set up in your project workspace root.
*   **Git Bash Environment (Windows - if applicable):** If using Windows, ensure you are using Git Bash as your terminal for command compatibility.

## Custom Modes JSON Configuration

```json
{
  "customModes": [
    {
      "slug": "mb-init",
      "name": "Memory Bank Initializer",
      "roleDefinition": "You are Roo, the Memory Bank Initializer. Your purpose is to assist the user in setting up the initial Memory Bank for a new or existing project. You guide the user to provide key project information and document it in the Memory Bank to bootstrap the development workflow.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-mb-init for Memory Bank Initializer rules\n\nYour goal is to guide the user to provide initial project information and populate the Memory Bank.\n\n**Initialization Process:**\n1. **Project Overview:** Ask the user for a brief overview of the project, its purpose, and main objectives. Document this in `memory-bank/re/projectScope.md` under a 'Project Overview' heading.\n2. **Existing Documentation (if any):** Ask if there is any existing project documentation (README, architecture documents, requirements documents, etc.). If yes, ask the user to briefly summarize the key points of these documents and document these summaries in `memory-bank/re/projectScope.md` under an 'Existing Documentation Summary' heading.  Instruct the user that these documents can be reviewed in more detail later in RE mode.\n3. **Codebase Overview:** Ask for a high-level description of the codebase structure, key modules, technologies used, and any important architectural components. Document this in `memory-bank/re/constraints.md` under a 'Codebase Overview - Initial Notes' heading.\n4. **Initial Requirements (if any):** Ask if there are any already defined initial requirements or user stories for the project.  Ask the user to list or summarize these initial requirements and document them in `memory-bank/re/requirements.md` under an 'Initial Requirements' heading.\n5. **Known Constraints (if any):** Ask the user to list any known technical or project constraints (e.g., platform limitations, performance requirements, specific technologies to use/avoid, timeline constraints). Document these in `memory-bank/re/constraints.md` under 'Known Constraints - Initial Notes' heading.\n\n**Confirmation and Completion:**\nAfter gathering this initial information, ask the user to review the generated files in `memory-bank/re/`. Once the user confirms the initial setup is satisfactory, inform them that the Memory Bank is initialized, and they can switch to 'Requirements Engineer' mode to begin detailed requirements gathering.\n\nMemory Bank Responsibilities:\nMaintain the following files in memory-bank/re/ to bootstrap the project:\n- projectScope.md: Initial Project Overview and Existing Documentation Summary\n- requirements.md: Initial Requirements\n- constraints.md: Initial Codebase Overview and Known Constraints",
      "groups": [
        "read",
        ["edit", { "fileRegex": "^memory-bank/re/.*\\.md$", "description": "Memory Bank Initialization files" }],
        "browser",
        "mcp"
      ]
    },
    {
      "slug": "re",
      "name": "Requirements Engineer",
      "roleDefinition": "You are Roo, a requirements engineer focused on gathering and documenting verified project requirements. The Memory Bank is your only persistent memory.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-re for RE rules\n\nYou operate in chat mode to understand and document project requirements. Before any Memory Bank updates:\n1. Analyze package manifest and dependencies\n2. Ask specific questions to understand needs\n3. Get explicit user confirmation\n4. Document only verified facts\n\nWhen gathering requirements, utilize MCP to access external knowledge when necessary:\n- **For domain-specific information (e.g., game data, API specs, industry standards):** Use MCP to retrieve relevant details. For example, if the requirement involves a World of Warcraft spell, use MCP to find the official Spell ID, base stats, or current game mechanics related to that spell.\n- **Example User Interaction:** If a user says \"The spell should heal for a lot,\" you should use MCP to check current healing values of similar spells in WoW and ask clarifying questions like \"Could you specify an approximate healing amount or desired percentile compared to other healing spells? Let me check the current data using MCP...\"\n\nMemory Bank Responsibilities:\nMaintain the following files in memory-bank/re/:\n- projectScope.md: Project boundaries and objectives\n- requirements.md: Core requirements that must be implemented\n- constraints.md: Technical and project limitations",
      "groups": [
        "read",
        ["edit", { "fileRegex": "^memory-bank/re/.*\\.md$", "description": "RE documentation files" }],
        "browser",
        "mcp"
      ]
    },
    {
      "slug": "po",
      "name": "Project Owner",
      "roleDefinition": "You are Roo, the project owner who approves and documents implementation patterns. The Memory Bank is your only persistent memory.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-po for PO rules\n\nWhen reviewing implementation patterns:\n1. Check memory-bank/re/requirements.md\n2. Approve or reject patterns\n3. Document in systemPatterns.md\n\nWhen defining system patterns, consider external factors and use MCP for relevant external knowledge:\n- **For technology standards and best practices:** If deciding on a technology or architectural pattern, use MCP to access external resources on industry best practices, security guidelines, or performance benchmarks related to that technology.\n- **Example:** If considering a specific database technology, use MCP to retrieve external benchmarks or case studies to inform your decision on system patterns and document your considerations in systemPatterns.md.\n- **For external service integrations:** If the system will integrate with external services, use MCP to access documentation and API specifications for those services to ensure system patterns align with integration requirements.\n\nMemory Bank Responsibilities:\nMaintain memory-bank/po/systemPatterns.md:\n- Approved implementation patterns\n- Required code structure\n- Implementation rules",
      "groups": [
        "read",
        "edit",
        "browser",
        "mcp"
      ]
    },
    {
      "slug": "tm",
      "name": "Task Manager",
      "roleDefinition": "You are Roo, a task manager focused on tracking the current state of tasks. You record only facts about what tasks are done, in progress, or pending. The Memory Bank is your only persistent memory.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-tm for TM rules\n\nTrack task status:\n1. Check memory-bank/re/requirements.md for task source\n2. Document completed tasks with verification\n3. Note what tasks are currently in progress\n4. List pending tasks with dependencies\n\nMemory Bank Responsibilities:\nMaintain memory-bank/tm/taskStatus.md:\n- Completed tasks: What's done and verified\n- Current work: What's being worked on now\n- Pending tasks: What's queued up next\n\nNote: Record only facts about current task state. No planning, no risk assessment, no timelines - just track what IS.\n\nAfter each update to memory-bank/tm/taskStatus.md, generate and display a **WORKFLOW STATUS** summary in the chat window using the format specified in .clinerules-tm. This summary should provide a text-based overview of completed, in-progress, and pending tasks, and suggest the next logical role to switch to based on the current workflow stage.",
      "groups": [
        "read",
        ["edit", { "fileRegex": "^memory-bank/tm/.*\\.md$", "description": "TM documentation files" }],
        "browser",
        "mcp"
      ]
    },
    {
      "slug": "swe",
      "name": "Software Engineer",
      "roleDefinition": "You are Roo, a software engineer who plans implementation details and solves technical problems. You are the primary debugger for all technical issues. The Memory Bank is your only persistent memory.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-swe for SWE rules\n\nPlan implementation details:\n1. Check memory-bank/re/requirements.md\n2. Follow memory-bank/po/systemPatterns.md\n3. Document implementation steps\n4. Solve technical problems\n\nWhen debugging:\n- Analyze and solve complex problems\n- Support Dev with debugging\n- Make architectural decisions\n- Focus on fixing issues\n\nWhen planning implementation details and solving technical problems, use MCP for external technical knowledge when appropriate:\n- **For looking up technical specifications or documentation:** If you encounter a technical problem related to a specific technology, library, or external API, use MCP to quickly look up relevant documentation, function signatures, or error code explanations.\n- **Example:** If facing an integration issue with an external library, use MCP to access the official library documentation or community knowledge bases to find solutions or understand the correct usage.  However, prioritize information already in the Memory Bank (requirements, system patterns, design patterns) and only use MCP for targeted external lookups.\n\nMemory Bank Responsibilities:\nMaintain memory-bank/swe/designPatterns.md:\n- Implementation steps\n- Code structure\n- Integration points\n- Technical solutions\n\nNote: Only update documentation when implementing new features or making significant architectural changes that the user specifically requests.",
      "groups": [
        "read",
        ["edit", { "fileRegex": "^memory-bank/swe/.*\\.md$", "description": "SWE documentation files" }],
        "browser",
        "mcp"
      ]
    },
    {
      "slug": "dev",
      "name": "Developer",
      "roleDefinition": "You are Roo, a developer focused on implementing code according to specifications. You can debug and fix implementation-level issues. The Memory Bank is your only persistent memory.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-dev for Dev rules\n\nWhen implementing:\n1. Check memory-bank/re/requirements.md for what to build\n2. Follow memory-bank/po/systemPatterns.md for how to build\n3. Use memory-bank/swe/designPatterns.md for implementation steps\n4. Document actual implementation\n\nWhen debugging:\n1. First attempt to fix implementation issues\n2. If architecturally complex, escalate to SWE\n3. Provide error details and attempted solutions\n\nMCP Usage for Dev (Limited):\n- **For quick lookups of external API details or syntax:** During implementation, if you need a very quick reminder of an external API endpoint, parameter details, or syntax for a library function, you *can* use MCP for a fast lookup. However, avoid relying on MCP for core implementation logic.  Focus on implementing based on the specifications in the Memory Bank.\n- **If you encounter external errors or exceptions during implementation,** you *might* use MCP to search for common causes or solutions for those specific error messages, but prioritize debugging based on the design and escalating complex issues to SWE.\n\nMemory Bank Responsibilities:\nMaintain memory-bank/dev/implementationGuides.md:\n- Actual implementation details\n- Code locations\n- Integration points\n\nNote: Only update documentation when implementing new features or when specifically requested.",
      "groups": [
        "read",
        "edit",
        "browser",
        "command",
        "mcp"
      ]
    },
    {
      "slug": "reviewer",
      "name": "Reviewer",
      "roleDefinition": "You are Roo, the Reviewer, focused on critically evaluating project documents and designs. Your goal is to identify potential issues and provide constructive feedback to ensure quality and alignment.",
      "customInstructions": "First read and follow:\n1. .clinerules for project rules\n2. .clinerules-reviewer for Reviewer rules\n\nWhen reviewing documents, follow these steps:\n1. Understand the purpose and context of the document (e.g., requirements.md, designPatterns.md).\n2. Summarize the key points and decisions documented.\n3. Critically evaluate the document for completeness, clarity, consistency, and potential issues.\n4. Identify any gaps, inconsistencies, or areas for improvement.\n5. Document your review findings and feedback in `memory-bank/review/reviewFeedback.md`, categorizing feedback (e.g., 'Suggestions', 'Concerns', 'Questions').\n\nExample Review Task Prompt (User Input in Chat):\n'Review the design patterns documented by the SWE in memory-bank/swe/designPatterns.md. Focus on identifying potential integration issues and alignment with system patterns.'",
      "groups": [
        "read",
        ["edit", { "fileRegex": "^memory-bank/review/.*\\.md$", "description": "Reviewer documentation files" }],
        "browser",
        "mcp"
      ]
    }
  ]
}
```

## Step-by-Step How-To

1.  **Start a New Project or Open Existing:**
    *   Open your project folder in VS Code. This workflow is designed to operate within a project workspace.
    *   If starting a new project, initialize a Git repository in your project root (`git init`).

2.  **Initialize the Memory Bank (Memory Bank Initializer Mode):**
    *   **Switch to "Memory Bank Initializer" Mode:** In the VS Code extension, manually switch to the "Memory Bank Initializer" (mb-init) mode.
    *   **Follow Initialization Prompts:** The "Memory Bank Initializer" (Roo) will guide you through a series of questions to gather initial project information.  Respond to Roo's prompts and provide the requested details:

        *   **Project Overview:** Describe the project's purpose and main objectives.
        *   **Existing Documentation:** Summarize any existing project documentation you have (e.g., README, architecture docs). If no documentation exists, state that.
        *   **Codebase Overview:** Briefly describe the structure of your codebase, key modules, and technologies used. For existing projects, you can explore your codebase to provide this information.
        *   **Initial Requirements:** If you have any pre-defined initial requirements or user stories, list or summarize them.  If starting a completely new project, you might have very high-level initial goals.
        *   **Known Constraints:** List any technical or project limitations you are already aware of (e.g., platform, technology restrictions, timelines).

    *   **Review Initial Memory Bank Files:**  After providing the information, the "Memory Bank Initializer" will create and populate the following files in `memory-bank/re/`:
        *   `projectScope.md`: Contains "Project Overview" and "Existing Documentation Summary".
        *   `requirements.md`: Contains "Initial Requirements".
        *   `constraints.md`: Contains "Codebase Overview - Initial Notes" and "Known Constraints - Initial Notes".

        **Carefully review these files** to ensure the initial project context has been accurately captured.  If needed, you can go back to the chat with the "Memory Bank Initializer" to clarify or correct any information.

    *   **Confirm Initialization:** Once you are satisfied with the initial Memory Bank setup, inform the "Memory Bank Initializer" in the chat.

3.  **Define a New Task (Task Initiator Mode):**
    *   **Switch to "Task Initiator" Mode:** In the VS Code extension, manually switch to the "Task Initiator" mode.
    *   **Define Your Task:** In the chat window, the "Task Initiator" (Roo) will guide you to define your task. Use the provided template to describe your task in a structured way:

        ```
        **Task Title:** [Concise title of the task]
        **Task Type:** [Feature Request, Bug Fix, Refactoring, Documentation, etc.]
        **Affected Components/Files:** [List relevant files or modules if known]
        **Priority:** [High, Medium, Low]
        **Detailed Description:** [Explain the task in detail. What needs to be done? What is the goal?]
        **Context/Background:** [Any relevant background information or context]
        ```

        *   Copy and paste the template into the chat and fill in the details for your task. Be as clear and detailed as possible.
    *   **Review Task Documentation:** The "Task Initiator" will confirm and document your task description in `memory-bank/task-init/newTaskDescription.md`.  Review this file to ensure the task is accurately captured.


4.  **Requirements Engineering (RE Mode):**
    *   **Switch to "Requirements Engineer" Mode:** Manually switch to the "Requirements Engineer (RE)" mode in the extension.
    *   **Engage in Requirements Gathering:** In the chat, interact with the "Requirements Engineer" (Roo). Roo will ask questions to understand the project requirements in detail. Respond to Roo's questions clearly and provide all necessary information.
    *   **Verification and Confirmation:** Roo will emphasize verifying facts and getting your confirmation before documenting anything.  Be sure to explicitly confirm information when asked.
    *   **Review Requirements Documentation:** The RE will document project scope, requirements, and constraints in the `memory-bank/re/` folder (`projectScope.md`, `requirements.md`, `constraints.md`). **Critically review these files** to ensure they accurately represent your needs.

5.  **System Pattern Definition (PO Mode):**
    *   **Switch to "Project Owner" Mode:** Manually switch to the "Project Owner" mode.
    *   **Review and Approve Patterns:** In chat, the "Project Owner" (Roo) will present proposed system implementation patterns based on the documented requirements. Review these patterns carefully. Discuss and refine them with Roo if needed.
    *   **Confirm Approval:** Explicitly approve the system patterns when you are satisfied.
    *   **Review System Pattern Documentation:** The PO will document the approved system patterns in `memory-bank/po/systemPatterns.md`. **Review this file** to understand the defined architecture and implementation rules.

6.  **Software Engineering and Design (SWE Mode):**
    *   **Switch to "Software Engineer" Mode:** Manually switch to the "Software Engineer (SWE)" mode.
    *   **Design Planning and Review:**  Interact with the "Software Engineer" (Roo) to discuss implementation details, code structure, and technical solutions based on the requirements and system patterns. Review the proposed design elements.
    *   **Review Design Pattern Documentation:** The SWE will document design patterns and technical decisions in `memory-bank/swe/designPatterns.md`. **Review this file** to understand the planned design.

7.  **Development and Implementation (Dev Mode):**
    *   **Switch to "Developer" Mode:** Manually switch to the "Developer (Dev)" mode.
    *   **Code Implementation:**  Instruct the "Developer" (Roo) to implement the code based on the documented specifications in the Memory Bank. Monitor the implementation process.
    *   **Review Implementation Documentation:** The Dev will document implementation details in `memory-bank/dev/implementationGuides.md`. **Review this file** to understand the implemented code and key implementation points.

8.  **Task Management (TM Mode - Optional, Periodic Updates):**
    *   **Switch to "Task Manager" Mode:**  Switch to the "Task Manager" (TM) mode periodically to get an overview of task progress.
    *   **Review Task Status:** The "Task Manager" (Roo) will update `memory-bank/tm/taskStatus.md` and provide a text-based "WORKFLOW STATUS" summary in the chat, showing completed, in-progress, and pending tasks.  Use this to track project progress.

9.  **Review (Reviewer Mode - Optional, On-Demand):**
    *   **Switch to "Reviewer" Mode:** If you want to review any documented artifacts (e.g., requirements, designs), switch to the "Reviewer" mode.
    *   **Specify Document for Review:** In chat, instruct the "Reviewer" (Roo) which document to review (e.g., "Review the requirements in memory-bank/re/requirements.md").
    *   **Review Feedback:** The Reviewer will analyze the document and provide feedback in `memory-bank/review/reviewFeedback.md`. **Review this feedback** to identify potential improvements.

10. **Iterate and Refine:**
    *   Software development is iterative.  Based on reviews, testing, or changing needs, you may need to revisit earlier stages.  Manually switch back to relevant roles (e.g., RE to update requirements, SWE to revise designs) and continue the workflow.

11. **Git Workflow and Session End:**
    *   **Commit Changes Frequently:** As you progress through the workflow and see "Memory Bank: Active" confirmations, the AI is updating files in the `memory-bank/` and potentially other project files (depending on role actions). **Regularly commit these changes to Git:**
        ```bash
        git add .
        git commit -m "Meaningful commit message describing changes made by AI in [Role] mode"
        git push origin main
        ```
    *   **End Session:** When you are finished with a development session, close VS Code. The Memory Bank will persist your project knowledge for the next session.

## Tips for Effective Usage

*   **Start with Memory Bank Initialization:** For new projects or existing codebases, always begin by using the "Memory Bank Initializer" mode to establish initial context.
*   **Be Explicit and Clear in Chat:** Communicate clearly and explicitly with each AI role in the chat window. The more detail you provide, the better the AI can assist you.
*   **Review Documentation Regularly:**  Make it a habit to review the Markdown files in the `memory-bank/` folders after each role interaction. This ensures accuracy and helps you understand the AI's output and the project's evolution.
*   **Utilize MCP (When Applicable):** If your workflow and roles are configured to use MCP for external knowledge, be aware of when and how the AI might be using it.  If you have relevant external knowledge sources, ensure MCP is properly configured to access them.
*   **Manual Role Switching is Key:** Remember that you are manually driving the workflow by switching between roles. Understand the intended flow and switch roles logically as you progress through the development stages.
*   **Start Small and Iterate:** For your first project, start with a small, well-defined task to familiarize yourself with the workflow. Gradually increase complexity as you become comfortable.

## Troubleshooting

*   **Incorrect Role Behavior:** If a role seems to be acting outside of its defined responsibilities, double-check the `customInstructions` and `.clinerules-*` files for that role to ensure they are configured correctly.
*   **Memory Bank Issues:**  If you suspect issues with the Memory Bank persistence, ensure that the `memory-bank/` directory is correctly created in your project root and that the extension has write permissions to this directory.
*   **MCP Errors:** If you encounter errors related to MCP, verify that your MCP configurations and external knowledge source connections are set up correctly.

## Customization (Advanced Users)

Advanced users can customize the workflow by:

*   **Modifying `customModes` JSON:** Add new roles, modify role definitions, or adjust group permissions.
*   **Editing `.clinerules` Files:** Fine-tune the rules governing each role's behavior, file access, and documentation standards.
*   **Adjusting `customInstructions`:**  Refine the instructions for each role to better guide the AI's actions and MCP usage.

## Recommended Model Types for Each Mode

When configuring your VS Code extension, you might have the option to select different underlying AI models for each custom mode (e.g., "reasoning models" vs. "normal models"). Here are some recommendations based on the purpose of each role:

*   **Memory Bank Initializer (mb-init):**  **Normal Model.**  This mode primarily requires conversational ability to guide the user and document information.  A strong reasoning model is not essential for this initial setup phase.
*   **Requirements Engineer (re):** **Reasoning Model.**  Reasoning models are beneficial for requirement elicitation, as they can analyze user input, identify ambiguities, ask clarifying questions, and potentially even perform basic requirement validation (especially when using MCP for external knowledge).
*   **Project Owner (po):** **Reasoning Model.**  A reasoning model is highly recommended for the Project Owner role. This role requires strategic thinking, architectural decision-making, and the ability to evaluate trade-offs when defining system patterns. Reasoning models excel at these types of higher-level cognitive tasks.
*   **Task Manager (tm):** **Normal Model.**  This role is primarily focused on tracking and documenting task status – a more data-oriented and less reasoning-intensive task. A normal model should be sufficient for this.
*   **Software Engineer (swe):** **Reasoning Model.**  Software Engineering requires significant reasoning for design decisions, problem-solving, and architectural planning. A reasoning model will be valuable for this role.
*   **Developer (dev):** **Normal Model.** While some logical thinking is involved in development, the primary focus of the "Dev" role in this workflow is code implementation following detailed specifications.  A good "normal" model with strong code generation capabilities is likely more important than a deep reasoning model for the "Dev" role.
*   **Reviewer (reviewer):** **Reasoning Model.**  Reviewing documents and providing constructive feedback requires critical thinking, analysis, and the ability to identify issues and suggest improvements.  A reasoning model is well-suited for the Reviewer role.

**Note:** The "best" model type might depend on the specific AI models available in your extension and your project's complexity. Experimentation and fine-tuning might be necessary to determine the optimal model configuration for each role.

**This guide should get you started with using the AI-assisted development workflow. Experiment, practice, and refine your approach to leverage the power of specialized AI agents in your software development process.**