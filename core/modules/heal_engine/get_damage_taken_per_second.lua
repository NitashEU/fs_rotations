--- Heal Engine Damage Calculation
--- Re-exports the damage calculation function from the damage analyzer for backward compatibility

-- Re-export the function from the damage analyzer
FS.modules.heal_engine.get_damage_taken_per_second = function(unit, last_x_seconds)
    return FS.modules.heal_engine.damage_analyzer.get_damage_taken_per_second(unit, last_x_seconds)
end