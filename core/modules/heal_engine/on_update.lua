--- Heal Engine Update Functions
--- Handles periodic updates for health tracking and damage analysis

function FS.modules.heal_engine.on_fast_update()
    -- Start profiling this function
    FS.profiler:start("on_fast_update", "heal_engine")

    -- Skip if not in combat
    if not FS.modules.heal_engine.state.is_in_combat then
        FS.profiler:stop("on_fast_update", "heal_engine", true)
        return
    end

    local current_time = core.game_time()

    -- Profile cache maintenance
    FS.profiler:profile_function(function()
        FS.modules.heal_engine.cache.maintain_caches(current_time)
    end, "maintain_caches", "heal_engine.cache")

    -- Profile position cache refresh
    FS.profiler:profile_function(function()
        FS.modules.heal_engine.cache.refresh_position_cache(current_time)
    end, "refresh_position_cache", "heal_engine.cache")

    -- Profile health data collection
    FS.profiler:profile_function(function()
        FS.modules.heal_engine.collector.update_health_data(current_time,
            function(unit, damage, current_health, previous_health, time)
                FS.modules.heal_engine.health_logger.log_damage_event(unit, damage, current_health, previous_health, time)
            end)
    end, "update_health_data", "heal_engine.collector")

    -- End profiling
    FS.profiler:stop("on_fast_update", "heal_engine", true)
end

function FS.modules.heal_engine.on_update()
    -- Start profiling this function
    FS.profiler:start("on_update", "heal_engine")

    local current_time = core.game_time()

    -- Update object pool system
    FS.object_pool:update(current_time)

    -- Profile combat state update
    FS.profiler:profile_function(function()
        FS.modules.heal_engine.state.update_combat_state(current_time)
    end, "update_combat_state", "heal_engine.state")

    -- Only run DPS updates in combat
    if FS.modules.heal_engine.state.is_in_combat then
        -- Profile DPS analysis
        FS.profiler:profile_function(function()
            FS.modules.heal_engine.damage_analyzer.update_all_units_dps(current_time)
        end, "update_all_units_dps", "heal_engine.damage_analyzer")

        -- Take a memory snapshot occasionally (approximately every 30 seconds)
        if math.random() < 0.01 then -- 1% chance per update
            FS.profiler:capture_memory_snapshot()
        end
    end

    -- End profiling
    FS.profiler:stop("on_update", "heal_engine", true)
end
