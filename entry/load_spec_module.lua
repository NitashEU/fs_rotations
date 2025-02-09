---@type enums
local enums = require("common/enums")

---Loads the module for the player's specialization
---@return boolean
function FS.entry_helper.load_spec_module()
    ---@type boolean, SpecConfig
    local success, module = pcall(require,
        "classes/" ..
        FS.entry_helper.class_spec_map
        [enums.class_spec_id.get_specialization_enum(FS.spec_config.class_id, FS.spec_config.spec_id)] ..
        "/bootstrap")
    if success then
        FS.spec_config = module
        return true
    end
    core.log("Failed to load spec module: " .. module)
    return false
end
