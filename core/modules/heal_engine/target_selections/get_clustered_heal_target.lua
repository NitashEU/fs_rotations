---Get a target for clustered healing spells, optimizing for maximum affected targets
---@param hp_threshold number Maximum health percentage to consider a target for healing (0-100)
---@param min_targets number Minimum number of targets required below threshold
---@param max_targets number Maximum number of targets that can be affected
---@param range number Range to check for additional targets
---@param spell_id number ID of the healing spell to check castability
---@param prioritize_distance boolean Whether to prioritize targets closer to the player
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@param weights? {health: number, damage: number, cluster: number, distance: number} Optional weights for scoring (defaults to standard weights if not provided)
---@param position_unit? game_object Optional unit to use as the center for cluster calculations (defaults to target)
---@return game_object|nil target The optimal target to cast on, or nil if conditions not met
function FS.modules.heal_engine.get_clustered_heal_target(hp_threshold, min_targets, max_targets, range, spell_id,
                                                          prioritize_distance, skip_facing, skip_range, weights,
                                                          position_unit)
    -- Parameter validation
    if not hp_threshold or not min_targets or not max_targets or not range or not spell_id then
        return nil
    end

    local best_target = nil
    local best_score = 0

    -- Use provided weights or defaults
    local HEALTH_WEIGHT = 0.4   -- (weights and weights.health) or
    local DAMAGE_WEIGHT = 0.3   -- (weights and weights.damage) or
    local CLUSTER_WEIGHT = 0.2  -- (weights and weights.cluster) or
    local DISTANCE_WEIGHT = 0.1 -- (weights and weights.distance) or

    -- Normalize weights to ensure they sum to 1
    local total = HEALTH_WEIGHT + DAMAGE_WEIGHT + CLUSTER_WEIGHT + DISTANCE_WEIGHT
    if total > 0 then
        HEALTH_WEIGHT = HEALTH_WEIGHT / total
        DAMAGE_WEIGHT = DAMAGE_WEIGHT / total
        CLUSTER_WEIGHT = CLUSTER_WEIGHT / total
        DISTANCE_WEIGHT = DISTANCE_WEIGHT / total
    end

    -- Find highest damage taken across all units for normalization
    local highest_damage = 0
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1220769, unit) then
            local damage = FS.modules.heal_engine.damage_taken_per_second_last_5_seconds[unit] or 0
            highest_damage = math.max(highest_damage, damage)
        end
    end

    -- Helper function to calculate damage score for a unit
    ---@param unit game_object
    ---@return number
    local function calculate_damage_score(unit)
        if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1220769, unit) then
            local damage = FS.modules.heal_engine.damage_taken_per_second_last_5_seconds[unit] or 0
            -- Normalize damage score based on highest damage taken
            return highest_damage > 0 and (damage / highest_damage) or 0
        end
        return 0
    end

    -- Helper function to calculate distance score
    ---@param unit game_object
    ---@return number
    local function calculate_distance_score(unit)
        if not prioritize_distance then return 1 end

        local distance = FS.variables.me:get_position():dist_to(unit:get_position())
        -- Score increases linearly with distance (farther = higher score)
        return math.min(1.0, distance / range)
    end

    -- Evaluate each potential target
    for _, target in ipairs(FS.modules.heal_engine.units) do
        if target and target:is_valid() and not target:is_ghost() and not target:is_dead() and not FS.variables.debuff_up(1220769, target) and FS.api.spell_helper:is_spell_queueable(spell_id, FS.variables.me, target, skip_facing, skip_range) then
            -- Use position_unit if provided, otherwise use target for cluster center
            local cluster_center = position_unit or target
            local hd = FS.modules.heal_engine.current_health_values[target]

            -- Count potential affected targets and calculate cluster stats
            local affected_count = 0 -- Include primary target
            local total_health_deficit = 0
            local total_damage_score = calculate_damage_score(target)
            local lowest_health_pct = hd and hd.health_percentage or 1

            for _, unit in ipairs(FS.modules.heal_engine.units) do
                local health_data = FS.modules.heal_engine.current_health_values[unit]
                if unit and unit:is_valid() and not unit:is_ghost() and not unit:is_dead() and not FS.variables.debuff_up(1220769, target) and health_data
                    and health_data.health_percentage <= hp_threshold
                    and cluster_center:get_position():dist_to(unit:get_position()) <= range then
                    affected_count = affected_count + 1
                    total_health_deficit = total_health_deficit + (1 - health_data.health_percentage)
                    total_damage_score = total_damage_score + calculate_damage_score(unit)
                    lowest_health_pct = math.min(lowest_health_pct, health_data.health_percentage)
                end
            end

            -- Only consider targets that meet minimum affected count
            if affected_count >= min_targets then
                -- Calculate score components
                local count_score = affected_count / max_targets
                local health_score = total_health_deficit / affected_count
                local damage_score = total_damage_score / affected_count
                local distance_score = calculate_distance_score(target)

                -- Combine scores with weights
                local total_score = count_score * CLUSTER_WEIGHT +
                    health_score * HEALTH_WEIGHT +
                    damage_score * DAMAGE_WEIGHT +
                    distance_score * DISTANCE_WEIGHT

                if total_score > best_score then
                    best_score = total_score
                    best_target = target
                end
            end
        end
    end

    return best_target
end
