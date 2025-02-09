function FS.modules.heal_engine.reset()
    local is_in_combat = FS.variables.me:is_in_combat()
    if is_in_combat and not FS.modules.heal_engine.is_in_combat then
        FS.modules.heal_engine.is_in_combat = true
        FS.modules.heal_engine.start()
    elseif not is_in_combat and FS.modules.heal_engine.is_in_combat then
        FS.modules.heal_engine.is_in_combat = false
        FS.modules.heal_engine.reset()
    end
end
