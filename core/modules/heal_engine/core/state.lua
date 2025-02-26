--- Heal Engine State Management
--- Handles combat state tracking and transitions

-- Module namespace
local state = {
    ---@type boolean Whether the player is in combat
    is_in_combat = false,
    ---@type number Timestamp of fight start
    fight_start_time = nil,
    ---@type table<game_object, number> Health at fight start for each unit
    fight_start_health = {},
    ---@type table<game_object, number> Total damage taken for each unit in this fight
    fight_total_damage = {}
}

--- Start combat tracking
---@param current_time number Current game time
function state.enter_combat(current_time)
    state.is_in_combat = true
    state.fight_start_time = current_time
    
    -- Reset fight-wide tracking
    state.fight_start_health = {}
    state.fight_total_damage = {}
    
    -- Call the start function to initialize combat systems
    FS.modules.heal_engine.start()
    
    -- Log combat start if logging enabled
    if FS.modules.heal_engine.health_logger then
        FS.modules.heal_engine.health_logger.log_combat_state(true)
    end
end

--- End combat tracking
---@param current_time number Current game time
function state.exit_combat(current_time)
    -- Log final fight stats if logging enabled
    if state.fight_start_time and FS.modules.heal_engine.health_logger then
        local fight_duration = (current_time - state.fight_start_time) / 1000
        for _, unit in pairs(FS.modules.heal_engine.units) do
            local total_damage = state.fight_total_damage[unit] or 0
            FS.modules.heal_engine.health_logger.log_fight_dps(unit, total_damage, fight_duration)
        end
    end
    
    -- Reset combat state
    state.is_in_combat = false
    state.fight_start_time = nil
    
    -- Reset all data tracking
    FS.modules.heal_engine.reset()
    
    -- Clear DPS tracking data
    if FS.modules.heal_engine.damage_analyzer then
        FS.modules.heal_engine.damage_analyzer.last_dps_values = {}
        FS.modules.heal_engine.damage_analyzer.last_dps_update = 0
    end
    
    -- Log combat end if logging enabled
    if FS.modules.heal_engine.health_logger then
        FS.modules.heal_engine.health_logger.log_combat_state(false)
    end
end

--- Update combat state based on player state
---@param current_time number Current game time
function state.update_combat_state(current_time)
    local is_in_combat = FS.variables.me:is_in_combat()
    
    -- Handle combat state transitions
    if is_in_combat and not state.is_in_combat then
        state.enter_combat(current_time)
    elseif not is_in_combat and state.is_in_combat then
        state.exit_combat(current_time)
    end
end

-- Export the module
FS.modules.heal_engine.state = state
return state