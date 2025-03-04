---@diagnostic disable: missing-fields

---@type buff_manager
local buff_manager = require("common/modules/buff_manager")

FS.variables = {
    ---@type game_object
    me = core.object_manager.get_local_player(),
    ---@type fun(): game_object?
    target = function() return FS.variables.me:get_target() end,
    ---@type fun(): game_object?
    enemy_target = function() return FS.variables.is_valid_enemy_target() and FS.variables.me:get_target() or nil end,
    is_valid_enemy_target = function()
        local target = FS.variables.target()
        if not target then return false end
        if not target:is_valid() then return false end
        if target:is_dead() then return false end
        if not FS.variables.me:can_attack(target) then return false end
        return true
    end,
}

---@param spell_id number
---@return boolean
function FS.variables.buff_up(spell_id)
    return buff_manager:get_buff_data(FS.variables.me, { spell_id }).is_active
end

---@param spell_id number
---@return number
function FS.variables.buff_remains(spell_id)
    return buff_manager:get_buff_data(FS.variables.me, { spell_id }).remaining
end

---@param spell_id number
---@return boolean
function FS.variables.aura_up(spell_id)
    return buff_manager:get_aura_data(FS.variables.me, { spell_id }).is_active
end

---@param spell_id number
---@return number
function FS.variables.aura_remains(spell_id)
    return buff_manager:get_aura_data(FS.variables.me, { spell_id }).remaining
end

---@param power_type number
---@return number
function FS.variables.resource(power_type)
    return FS.variables.me:get_power(power_type)
end
