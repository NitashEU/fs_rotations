function FS.modules.heal_engine.start()
    FS.modules.heal_engine.reset()
    local units = core.object_manager.get_all_objects()

    for _, v in pairs(units) do
        if
            v:is_valid()
            and (v:is_player() or v:get_npc_id() == 210759)
            and v:is_visible()
            and v:is_party_member()
            and v ~= FS.variables.me
        then
            table.insert(FS.modules.heal_engine.units, v)
            if FS.api.unit_helper:is_tank(v) then
                table.insert(FS.modules.heal_engine.tanks, v)
            elseif FS.api.unit_helper:is_healer(v) then
                table.insert(FS.modules.heal_engine.healers, v)
            else
                table.insert(FS.modules.heal_engine.damagers, v)
            end
        end
    end

    table.insert(FS.modules.heal_engine.units, FS.variables.me)
    if FS.api.unit_helper:is_tank(FS.variables.me) then
        table.insert(FS.modules.heal_engine.tanks, FS.variables.me)
    elseif FS.api.unit_helper:is_healer(FS.variables.me) then
        table.insert(FS.modules.heal_engine.healers, FS.variables.me)
    else
        table.insert(FS.modules.heal_engine.damagers, FS.variables.me)
    end
end
