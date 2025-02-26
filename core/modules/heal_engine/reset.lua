function FS.modules.heal_engine.reset()
    -- Clean up current health values
    for unit, value in pairs(FS.modules.heal_engine.current_health_values) do
        FS.modules.heal_engine.release_health_value(value)
    end
    
    -- Clean up circular buffers
    for unit, buffer in pairs(FS.modules.heal_engine.health_values) do
        if buffer and buffer.records then
            -- Release each health value in the buffer
            for i = 1, buffer.capacity do
                if buffer.records[i] then
                    FS.modules.heal_engine.release_health_value(buffer.records[i])
                    buffer.records[i] = nil
                end
            end
            -- Release the buffer array itself
            FS.modules.heal_engine.release_array(buffer.records)
        end
    end
    
    -- Reset all module data
    FS.modules.heal_engine.units = {}
    FS.modules.heal_engine.tanks = {}
    FS.modules.heal_engine.healers = {}
    FS.modules.heal_engine.damagers = {}
    FS.modules.heal_engine.current_health_values = {}
    FS.modules.heal_engine.health_values = {}
    FS.modules.heal_engine.damage_taken_per_second = {}
    FS.modules.heal_engine.damage_taken_per_second_last_5_seconds = {}
    FS.modules.heal_engine.damage_taken_per_second_last_10_seconds = {}
    FS.modules.heal_engine.damage_taken_per_second_last_15_seconds = {}
    FS.modules.heal_engine.dps_cache = {}
    FS.modules.heal_engine.last_dps_values = {}
    
    -- Clear caches
    FS.modules.heal_engine.distance_cache = {}
    FS.modules.heal_engine.distance_cache_last_cleared = core.game_time()
    
    -- Fight-wide DPS tracking
    FS.modules.heal_engine.fight_start_time = nil
    FS.modules.heal_engine.fight_start_health = {}
    FS.modules.heal_engine.fight_total_damage = {}
    
    -- Log pool statistics if debug is enabled
    if FS.modules.heal_engine.settings and FS.modules.heal_engine.settings.logging and 
       FS.modules.heal_engine.settings.logging.is_debug_enabled() then
        core.log(string.format("Object Pool Stats - Created/Recycled - Health: %d/%d, Arrays: %d/%d, Pool Size: %d/%d",
            FS.modules.heal_engine.pool_stats.health_value_created,
            FS.modules.heal_engine.pool_stats.health_value_recycled,
            FS.modules.heal_engine.pool_stats.array_created,
            FS.modules.heal_engine.pool_stats.array_recycled,
            #FS.modules.heal_engine.health_value_pool,
            #FS.modules.heal_engine.array_pool
        ))
    end
end
