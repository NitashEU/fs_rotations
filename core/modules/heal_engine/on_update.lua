--- Heal Engine Update Functions
--- Handles periodic updates for health tracking and damage analysis

function FS.modules.heal_engine.on_fast_update()
    -- Skip if not in combat
    if not FS.modules.heal_engine.state.is_in_combat then
        return
    end

    local current_time = core.game_time()
    
    -- Update caches
    FS.modules.heal_engine.cache.maintain_caches(current_time)
    FS.modules.heal_engine.cache.refresh_position_cache(current_time)

    -- Update health data with damage callback for logging
    FS.modules.heal_engine.collector.update_health_data(current_time, function(unit, damage, current_health, previous_health, time)
        FS.modules.heal_engine.health_logger.log_damage_event(unit, damage, current_health, previous_health, time)
    end)
end

function FS.modules.heal_engine.on_update()
    local current_time = core.game_time()
    
    -- Update combat state tracking
    FS.modules.heal_engine.state.update_combat_state(current_time)
    
    -- Only run DPS updates in combat
    if FS.modules.heal_engine.state.is_in_combat then
        -- Update DPS values
        FS.modules.heal_engine.damage_analyzer.update_all_units_dps(current_time)
    end
end