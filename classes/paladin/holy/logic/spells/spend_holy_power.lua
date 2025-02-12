---@return boolean
function FS.paladin_holy.logic.spells.spend_holy_power(requireBA)
    local currentHP = FS.paladin_holy.variables.holy_power()
    -- For normal rotation: check if near overcap
    if requireBA and currentHP < 4 then
        return false
    end
    -- For AC rotation: ensure Blessed Assurance is not up
    if (not requireBA) and FS.paladin_holy.variables.blessed_assurance_up() then
        return false
    end

    -- Use existing spell functions in priority order:
    if FS.paladin_holy.logic.spells.word_of_glory() then -- Already handles tank priority
        return true
    end
    if FS.paladin_holy.logic.spells.light_of_dawn() then
        return true
    end

    -- Only SotR needs direct implementation since it doesn't exist yet
    local target = FS.variables.enemy_target()
    if target then
        local target_pos = target:get_position()
        if target_pos and target_pos:dist_to(FS.variables.me:get_position()) <= 8 and
           FS.api.spell_helper:is_spell_queueable(FS.paladin_holy.spells.shield_of_the_righteous, FS.variables.me, FS.variables.me, true, true) then
            FS.api.spell_queue:queue_spell_target(FS.paladin_holy.spells.shield_of_the_righteous, FS.variables.me, 1)
            return true
        end
    end
    return false
end
