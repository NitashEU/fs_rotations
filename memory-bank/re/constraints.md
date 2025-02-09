# Constraints and Guidelines for Filling Memory Bank with Existing Project (fs_rotations)

## 1. Documentation Standards and Guidelines

*   Use LDoc-style comments to document functions, classes, and modules.
    *   Example:
        ```lua
        --- Adds two numbers together.
        --- @param a number The first number.
        --- @param b number The second number.
        --- @return number The sum of the two numbers.
        local function add(a, b)
          return a + b
        end

        ---@class Unit A unit in the game.
        ---@field name string The name of the unit.
        ---@field name string The name of the unit.
        ---@field health number The health of the unit.
        local Unit = {}

        ---@param name string The name of the unit.
        ---@param health number The health of the unit.
        ---@return Unit
        function Unit:new(name, health)
          local self = {
            name = name,
            health = health
          }
          setmetatable(self, { __index = Unit })
          return self
        end
        ```
*   Provide a brief description of the purpose of each function, class, and module.
*   Document the parameters and return values of each function.
*   Provide examples of how to use the functions, classes, and modules.
*   Use consistent formatting and style throughout the documentation.
*   Keep the documentation up-to-date with the code.

## 2. Technical Constraints

*   The documentation must be compatible with the LUA environment.
*   The documentation must be easily accessible and searchable.
    *   Since the target audience is the AI, the documentation should be stored in a structured format (e.g., Markdown) with clear headings and links. The AI can then use the headings and links to easily navigate and search the documentation.
*   The documentation must be maintainable and updatable.

## 3. Project Limitations

*   The project is a plugin for an existing script, and the script cannot be changed.
*   The plugin must be compatible with the existing script's API.