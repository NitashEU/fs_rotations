if false then
    return {
        name = "FS Rotations",
        version = "1.3.2",
        author = "FS",
        load = false
    }
end

FS = {
    ---@type SpecConfig
    spec_config = nil,
    ---@type ModuleConfig[]
    loaded_modules = {}
}

require("entry/index")

local plugin = {
    name = "FS Rotations",
    version = "1.3.2",
    author = "FS",
    load = true
}

-- Get local player
local local_player = core.object_manager.get_local_player()
if not local_player then
    plugin["load"] = false
    return plugin
end

-- Get player info
local player_class = local_player:get_class()
local player_spec_id = core.spell_book.get_specialization_id()

if FS.entry_helper.check_spec(player_class, player_spec_id) then
    return plugin
end

-- Spec not supported or module failed to load
plugin["load"] = false
return plugin
