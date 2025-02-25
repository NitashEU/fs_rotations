---@type cone
local cone = require("common/geometry/cone")

---Get optimal scoring for frontal cone healing spells like Light of Dawn
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param min_targets number Minimum number of targets required below threshold
---@param radius number Radius/length of the cone
---@param angle number Angle of the cone in degrees
---@param spell_id number ID of the healing spell to check castability
---@return game_object|nil target Returns player if conditions met, nil otherwise
function FS.modules.heal_engine.get_frontal_cone_heal_target(hp_threshold, min_targets, radius, angle, spell_id
)
    if not hp_threshold or not min_targets or not radius or not angle or not spell_id then
        return nil
    end

    if not FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, FS.variables.me, true, true) then
        return nil
    end
    -- Create cone from player position
    local cone_shape = cone:create_unit_frontal(FS.variables.me, radius, angle)

    -- Count affected targets
    local affected_count = 0

    -- Check all units in cone
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if cone_shape:is_inside(FS.modules.heal_engine.get_cached_position(unit), 0) or unit == FS.variables.me then
            local health_data = FS.modules.heal_engine.current_health_values[unit]
            if health_data and health_data.health_percentage <= hp_threshold then
                affected_count = affected_count + 1
            end
        end
    end

    -- Cast if we meet minimum targets, add me as a target
    if affected_count >= min_targets then
        return FS.variables.me
    end

    return nil
end
