---@return boolean
function FS.paladin_holy.logic.spells.holy_arnament()
    local spell_id = FS.paladin_holy.spells.holy_arnament

    -- Check if Holy Armament Override is active
    if FS.paladin_holy.variables.holy_armament_override_up() then
        -- Sacred Weapon mode - target healer with highest damage
        local target = FS.modules.heal_engine.get_healer_damage_target(spell_id, true, false, true)
        if not target then
            return false
        end

        -- Queue Sacred Weapon cast with high priority
        FS.api.spell_queue:queue_spell_target(spell_id, target, 1)
        return true
    else
        -- Holy Bulwark mode - target tank with highest damage
        local target = FS.modules.heal_engine.get_tank_damage_target(spell_id, true, false)
        if not target then
            return false
        end

        -- Queue Holy Bulwark cast with high priority
        FS.api.spell_queue:queue_spell_target(spell_id, target, 1)
        return true
    end
end
