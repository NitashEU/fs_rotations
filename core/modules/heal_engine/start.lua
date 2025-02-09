function FS.modules.heal_engine.start()
    FS.modules.heal_engine.reset()
    local units = core.object_manager.get_all_objects()

    local function addUnitToTables(unit)
        table.insert(FS.modules.heal_engine.units, unit)
        if FS.api.unit_helper:is_tank(unit) then
            table.insert(FS.modules.heal_engine.tanks, unit)
        elseif FS.api.unit_helper:is_healer(unit) then
            table.insert(FS.modules.heal_engine.healers, unit)
        else
            table.insert(FS.modules.heal_engine.damagers, unit)
        end
    end

    for _, v in pairs(units) do
        local isValid = v:is_valid()
        local isPlayerOrPet = v:is_player() or v:get_npc_id() == 210759
        local isVisible = v:is_visible()
        local isPartyMember = v:is_party_member()
        local isNotMe = v ~= FS.variables.me

        if isValid and isPlayerOrPet and isVisible and isPartyMember and isNotMe then
            addUnitToTables(v)
        end
    end

    addUnitToTables(FS.variables.me)

    core.log("started")
    core.log(tostring(#FS.modules.heal_engine.units))
end
