---Get a target for clustered healing spells, optimizing for maximum affected targets
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param min_targets number Minimum number of targets required below threshold
---@param max_targets number Maximum number of targets that can be affected
---@param range number Range to check for additional targets
---@param spell_id number ID of the healing spell to check castability
---@param prioritize_distance boolean Whether to prioritize targets closer to the player
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@return game_object|nil target The optimal target to cast on, or nil if conditions not met
function FS.modules.heal_engine.get_clustered_heal_target(hp_threshold, min_targets, max_targets, range, spell_id,
                                                          prioritize_distance, skip_facing, skip_range)
    -- Parameter validation
    if not hp_threshold or not min_targets or not max_targets or not range or not spell_id then
        return nil
    end

    local best_target = nil
    local best_score = 0

    -- Score calculation weights
    local HEALTH_WEIGHT = 0.4
    local DAMAGE_WEIGHT = 0.3
    local CLUSTER_WEIGHT = 0.2
    local DISTANCE_WEIGHT = 0.1

    -- Helper function to calculate damage score for a unit
    local function calculate_damage_score(unit)
        local damage = FS.modules.heal_engine.damage_taken_per_second_last_5_seconds[unit] or 0
        -- Normalize damage score (assuming 50k damage/sec as max for normalization)
        return math.min(1, damage / 50000)
    end

    -- Helper function to calculate distance score
    local function calculate_distance_score(unit)
        if not prioritize_distance then return 1 end

        local distance = FS.variables.me:get_distance(unit)
        -- Score decreases linearly with distance
        return math.max(0.1, 1.0 - (distance / range))
    end

    -- Helper function to evaluate and score nearby targets
    local function evaluate_cluster(center_unit)
        -- Collect and sort nearby targets by health percentage
        local nearby_targets = {}

        for _, unit in ipairs(FS.modules.heal_engine.units) do
            local health_data = FS.modules.heal_engine.current_health_values[unit]
            if health_data
                and health_data.health_percentage <= hp_threshold
                and center_unit:get_distance(unit) <= range then
                table.insert(nearby_targets, {
                    unit = unit,
                    health_pct = health_data.health_percentage,
                    damage_score = calculate_damage_score(unit)
                })
            end
        end

        table.insert(nearby_targets, {
            unit = center_unit,
            health_pct = FS.modules.heal_engine.current_health_values[center_unit].health_percentage,
            damage_score = calculate_damage_score(center_unit)
        })

        -- Sort by health percentage (lowest first)
        table.sort(nearby_targets, function(a, b)
            return a.health_pct < b.health_pct
        end)

        -- Take only up to max_targets lowest health targets
        local count = math.min(#nearby_targets, max_targets)
        if count < min_targets then
            return nil
        end

        -- Calculate scores for the lowest health targets
        local total_health_score = 0
        local total_damage_score = 0

        for i = 1, count do
            local target_data = nearby_targets[i]
            -- Health score calculation (higher score for lower health)
            total_health_score = total_health_score + (100 - target_data.health_pct) / 100
            total_damage_score = total_damage_score + target_data.damage_score
        end

        return {
            count = count,
            avg_health_score = total_health_score / count,
            avg_damage_score = total_damage_score / count,
            lowest_health_pct = nearby_targets[1].health_pct -- Track lowest health for additional scoring
        }
    end

    -- Evaluate each potential target
    for _, target in ipairs(FS.modules.heal_engine.units) do
        if FS.api.spell_helper:is_spell_castable(spell_id, FS.variables.me, target, skip_facing, skip_range) then
            local cluster = evaluate_cluster(target)

            -- Only consider targets that meet minimum cluster size
            if cluster then
                -- Calculate combined score
                local health_score = cluster.avg_health_score * HEALTH_WEIGHT
                local damage_score = cluster.avg_damage_score * DAMAGE_WEIGHT
                local cluster_score = (cluster.count / max_targets) * CLUSTER_WEIGHT
                local distance_score = calculate_distance_score(target) * DISTANCE_WEIGHT

                -- Bonus score for targeting lowest health cluster
                local lowest_health_bonus = (100 - cluster.lowest_health_pct) / 100 * 0.2

                local total_score = health_score + damage_score + cluster_score + distance_score + lowest_health_bonus

                if total_score > best_score then
                    best_score = total_score
                    best_target = target
                end
            end
        end
    end

    return best_target
end
