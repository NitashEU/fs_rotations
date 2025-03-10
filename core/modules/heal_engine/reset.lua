function FS.modules.heal_engine.reset()
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
    -- Fight-wide DPS tracking
    FS.modules.heal_engine.fight_start_time = nil
    FS.modules.heal_engine.fight_start_health = {}
    FS.modules.heal_engine.fight_total_damage = {}
end
