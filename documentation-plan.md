# Documentation Update Plan

## 1. File Iteration
- Recursively scan the d:\ffff\scripts\fs_rotations directory for all files named `knowledge.md`.

## 2. Consistent Template
- Use a standard template for every `knowledge.md` file:
  - **Overview:** Brief description of module purpose.
  - **Modules/Submodules:** List of related Lua modules.
  - **Function Signatures:** Extracted from Lua annotations where relevant.
  - **Examples:** Short usage examples from the source files.
  
## 3. Reflecting Lua Files & Logic
- Analyze nearby *.lua files (e.g., in `_api`, `common`, `modules`, etc.) for:
  - Annotated function definitions and class signatures.
  - Logical descriptions in comments that can be extracted.
- Include the key function signatures in the respective section:
  - For example, for `spell_queue.lua` add signatures for `queue_item_self`, `queue_spell_target`, etc.

## 4. Function Signatures Importance
- When function signatures are important, list them explicitly in a table or code block within the documentation.
- Prefer a format that matches the Lua annotations (e.g., function name followed by parameters and optional description).

## 5. Process Workflow
- Identify the module’s related Lua files.
- Extract existing annotations and comments.
- Merge relevant information into the corresponding `knowledge.md` file.
- Maintain consistency in structure and terminology across all documents.

## 6. Final Integration
- After updating each file, perform cross-referencing:
  - Ensure that global terms and module names remain consistent.
  - Include links or references to related documentation sections.

## 7. Summary
- This plan serves as a guideline to iterate through each module’s documentation and update all `knowledge.md` files to be consistent, reflective of the Lua file logic, with clear function signatures where necessary.

...existing details and future updates...
