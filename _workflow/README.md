# AI-Assisted Software Development Workflow with Specialized Roles in VS Code

This project defines an AI-assisted software development workflow implemented as a set of specialized roles within a VS Code extension.  It leverages AI agents, each with a distinct responsibility, to guide users through the software development lifecycle in a structured and controlled manner.

## Core Concepts

*   **Specialized Roles:** The workflow is divided into distinct roles (Memory Bank Initializer, Requirements Engineer, Project Owner, Task Manager, Software Engineer, Developer, Reviewer), each focusing on a specific phase or aspect of software development.
*   **Rule-Based System:** Each role operates under a set of rules defined in `.clinerules` and role-specific rule files (e.g., `.clinerules-re`). These rules govern behavior, file access, documentation standards, and more.
*   **Persistent Memory Bank:** Each role utilizes a dedicated "Memory Bank" (`memory-bank/` directory) for persistent storage of project knowledge, documentation, and specifications.
*   **MCP (Model Context Protocol) Integration:**  Roles are configured to use MCP to access external knowledge sources to enhance their capabilities (e.g., verifying requirements, informing architectural decisions, technical lookups).
*   **User-Driven Workflow:** The workflow is semi-automated, with users manually switching between roles to progress through the development stages and maintain oversight.

## Roles in Detail

*   **Memory Bank Initializer (mb-init):**  Guides initial project setup and populates the Memory Bank with foundational project context (overview, documentation summary, codebase info, initial requirements, constraints).
*   **Requirements Engineer (re):** Gathers and documents verified project requirements, ensuring factual accuracy and user confirmation. Leverages MCP for external knowledge verification.
*   **Project Owner (po):** Defines and approves system implementation patterns and architectural decisions based on requirements. Utilizes MCP to inform pattern selection with best practices.
*   **Software Engineer (swe):** Plans implementation details, solves technical problems, and documents design patterns based on requirements and system patterns. Uses MCP for targeted technical knowledge retrieval.
*   **Developer (dev):** Implements code according to specifications in the Memory Bank. Documents implementation details and handles implementation-level debugging. Minimal MCP usage.
*   **Task Manager (tm):** Tracks the current status of tasks (completed, in-progress, pending) and provides a text-based workflow status overview.
*   **Reviewer (reviewer - Optional):** Critically evaluates project documents and provides constructive feedback to ensure quality. Can use MCP for external quality standard references.

## Workflow Process

1.  **Memory Bank Initialization (mb-init Mode):** Bootstrap the Memory Bank with initial project context.
2.  **Requirements Engineering (re Mode):** Gather and document verified project requirements.
3.  **System Pattern Definition (po Mode):** Define and approve system implementation patterns.
4.  **Software Engineering and Design (swe Mode):** Plan implementation details and document design patterns.
5.  **Development and Implementation (dev Mode):** Implement code based on specifications.
6.  **Task Management (tm Mode - Ongoing):** Track task status and visualize workflow progress.
7.  **Review (reviewer Mode - Optional, On-Demand):** Review project documents and provide feedback.

## Getting Started

See [HOWTO.md](HOWTO.md) for a detailed step-by-step guide on using this AI-assisted development workflow in VS Code.

## Configuration

*   **`customModes` JSON:** Defines the custom modes (roles), their definitions, instructions, and group permissions. (See [HOWTO.md](HOWTO.md) for the JSON configuration).
*   **`.clinerules`:**  General project rules applied to all modes, defining environment, file access, documentation, and mode operation guidelines.
*   **`.clinerules-*`:** Role-specific rule files (e.g., `.clinerules-re`, `.clinerules-po`) that extend or specialize the general rules for each role, defining specific file access, documentation requirements, and more.
*   **`custom-instructions`:** Directory containing `.clinerules-*` files and potentially other custom instruction files for each mode.
*   **`memory-bank`:** Directory where each role's persistent memory is stored in Markdown files.

## Benefits

*   **Structured AI-Assisted Development:** Provides a clear and organized framework for using AI in software development.
*   **Specialized AI Agents:**  Roles allow for focused AI assistance for specific development tasks.
*   **Improved Documentation and Traceability:**  Emphasis on documenting every stage of the process within the Memory Bank.
*   **Enhanced Decision Making:** MCP integration provides access to external knowledge for more informed decisions.
*   **User Control and Oversight:** Manual role switching and review stages ensure human control over the AI-driven process.

## Limitations

*   **Configuration Overhead:** Requires initial setup and configuration of rules and custom modes.
*   **Potential Rigidity:** Rule-based system might require adjustments for highly dynamic or novel projects.
*   **User Orchestration:**  User needs to actively manage role switching and workflow progression.
*   **Dependency on MCP Quality:**  Effectiveness is influenced by the accuracy and relevance of external knowledge sources connected to MCP.

## Contributing

[If you wish to make this project open-source and accept contributions, add contribution guidelines here]

## License

[Specify your project license here]

**This project provides a foundation for building more intelligent and structured AI-assisted software development workflows. Explore the documentation, experiment with the workflow, and adapt it to your specific project needs.**