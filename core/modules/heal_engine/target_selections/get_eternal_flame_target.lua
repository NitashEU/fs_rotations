---Get optimal target for Eternal Flame based on health, role, and existing HoT status
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param tank_hp_threshold number Maximum health percentage to consider a tank for healing (0-100)
---@param critical_hp_threshold number Maximum health percentage to consider a target in critical condition (0-100)
---@param spell_id number ID of the healing spell to check castability
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@param current_ef_count number Current count of active Eternal Flame HoTs
---@param max_ef_targets number Maximum targets to maintain Eternal Flame on
---@param has_empyrean boolean Whether Empyrean Legacy is active for enhanced healing
---@param eternal_flame_up function Function to check if a unit has Eternal Flame
---@param eternal_flame_remains function Function to get remaining time on Eternal Flame for a unit
---@return game_object|nil target The optimal target for Eternal Flame, or nil if no valid target found
function FS.modules.heal_engine.get_eternal_flame_target(hp_threshold, tank_hp_threshold, critical_hp_threshold,
                                                         spell_id, skip_facing, skip_range, current_ef_count,
                                                         max_ef_targets, has_empyrean, eternal_flame_up,
                                                         eternal_flame_remains)
    -- Target selection variables
    local target = nil
    local target_score = 0

    -- First try tank healing if they're low
    --local tank_target = FS.modules.heal_engine.get_tank_damage_target(
    --    spell_id,
    --    skip_facing,
    --    skip_range
    --)
    --
    --if tank_target then
    --    local tank_hp = FS.api.unit_helper:get_health_percentage(tank_target)
    --
    --    -- If tank is below threshold
    --    if tank_hp <= tank_hp_threshold then
    --        target = tank_target
    --        target_score = (1 - tank_hp) * 100 -- Higher score for lower health
    --
    --        -- Check if tank already has HoT
    --        if eternal_flame_up(tank_target) then
    --          local remains = eternal_flame_remains(tank_target) / 1000
    --
    --          -- Reduce score if HoT already present, unless very low health or HoT is about to expire
    --          if tank_hp > tank_hp_threshold * 0.7 and remains > 3 then
    --              target_score = target_score * 0.7
    --          elseif remains < 3 then
    --              -- Bonus for refreshing nearly expired HoT on tank
    --              target_score = target_score * 0.8
    --          end
    --        else
    --            -- Significant bonus for applying new HoT to tank
    --            target_score = target_score * 0.9
    --        end
    --    end
    --end

    -- Check for other potential targets
    local general_targets = {}

    -- Function to score a potential target
    local function score_target(unit)
        if not unit then return 0 end

        local hp = FS.api.unit_helper:get_health_percentage(unit)
        if hp > hp_threshold then return 0 end

        local health_deficit = unit:get_max_health() - unit:get_health()
        local score = health_deficit -- Base score: higher health deficit = higher score

        -- Check if unit already has HoT
        if eternal_flame_up(unit) then
            local remains = eternal_flame_remains(unit) / 1000

            -- If HoT has significant time left, reduce score substantially
            if remains > 6 then
                score = score * 0.9  -- Substantial reduction for long remaining HoT
            elseif remains > 4 then
                score = score * 0.92 -- Large reduction for medium remaining HoT
            elseif remains > 2 then
                score = score * 0.95 -- Moderate reduction for short remaining HoT
            end
        elseif FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight, unit) then
            score = score * 0.95 -- Reduce score if Dawnlight is up (but not Eternal Flame
        else
            if FS.paladin_holy_herald.variables.holy_power_spenders_since_prism == 0 and FS.paladin_holy_herald.variables.last_holy_prism_time ~= 0 then
                local allies_in_range = FS.api.unit_helper:get_ally_list_around(unit:get_position(), 10, true, true,
                    false)
                -- Increase score if there are more allies in range
                if #allies_in_range > 1 then
                    score = score *
                        (1 + (#allies_in_range - 1) * 0.05) -- Increase score based on number of allies in range
                    -- Apply a cap to the score increase
                    if score > 1.5 then
                        score = 1.5
                    end
                end
            end

            -- Bonus for applying new HoT
            --score = score * 1.05
            --
            ---- Additional bonus if we have few active HoTs
            --if current_ef_count < max_ef_targets - 1 then
            --    score = score * 1.1
            --end
        end

        return score
    end

    -- Score all potential targets
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1215760, target) then
            local unit_score = score_target(unit)
            if unit_score > 0 then
                table.insert(general_targets, { unit = unit, score = unit_score })
            end
        end
    end

    -- Sort by score (highest first)
    table.sort(general_targets, function(a, b) return a.score > b.score end)

    -- Check if we found a higher-scoring target than the tank
    if #general_targets > 0 and general_targets[1].score > target_score then
        target = general_targets[1].unit
        target_score = general_targets[1].score
    end

    -- Consider Empyrean Legacy proc: if active, ensure we use it
    --if has_empyrean and not target then
    --    -- If we have Empyrean Legacy but no good target, pick anyone who could use healing
    --    target = FS.modules.heal_engine.get_single_target(
    --        hp_threshold, -- Almost anyone who's not at full health
    --        spell_id,
    --        skip_facing,
    --        skip_range
    --    )
    --
    --    if target then
    --        target_score = 50 -- Modest score just to use the proc
    --    end
    --end

    if target then
        --core.log(tostring(target_score))
    end

    return target
end
