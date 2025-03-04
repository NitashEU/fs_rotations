-------------------------------------------------------------------------------------------------------------------
-- Herald of the Sun: Dawnlight Implementation
--
-- This file implements the core mechanics for Dawnlight application and beam optimization, a key feature of the
-- Herald of the Sun specialization. Dawnlight is applied to allies after using Holy Prism followed by Holy Power spenders.
-- During Avenging Wrath, the beams between the player and Dawnlight targets can intersect to create additional healing.
--
-- Key features:
-- 1. Advanced targeting algorithm that prioritizes based on role, health, position and mastery benefit
-- 2. Beam intersection optimization to calculate the ideal player position for maximum healing
-- 3. Special handling for cooldown states (Avenging Wrath, Awakening) with different target priorities
-- 4. Integration with Holy Prism's 2-spell window for Dawnlight application
-------------------------------------------------------------------------------------------------------------------

---@type vec3
local vec3 = require("common/geometry/vector_3")

-- Define player role priority for targeting
-- Tanks receive highest priority for Dawnlight application due to their consistent damage intake
-- Melee DPS receive medium priority as they're often grouped together for better beam intersections
-- Ranged DPS receive lowest priority but still benefit from targeted application
local ROLE_PRIORITY = {
    TANK = 1,    -- Highest priority
    MELEE = 2,   -- Medium priority
    RANGED = 3   -- Lowest priority
}

-- Get a unit's role for priority calculations
-- This determines the base targeting priority for Dawnlight application
---@param unit table WoW unit object
---@return number Role priority (1-3, lower is higher priority)
local function get_unit_role_priority(unit)
    if unit.is_tank then
        return ROLE_PRIORITY.TANK
    elseif unit.is_melee then
        return ROLE_PRIORITY.MELEE
    else
        return ROLE_PRIORITY.RANGED
    end
end

-- Calculate mastery benefit based on distance
-- Paladin mastery (Lightbringer) scales with proximity - closer allies receive more healing
-- This function calculates the benefit factor based on distance to the player
---@param unit table WoW unit object - the target to check
---@param player table WoW player unit object - the paladin player
---@return number Benefit multiplier (0-1) where 1 is maximum benefit (closest position)
local function calculate_mastery_benefit(unit, player)
    local unit_pos = unit:get_position()
    local player_pos = player:get_position()
    
    -- Safety check for position data
    if not unit_pos or not player_pos then
        return 0
    end
    
    local distance = unit_pos:distance(player_pos)
    -- Paladin mastery scales with proximity - closer is better
    -- This is a simplified calculation - real implementation would use actual mastery scaling
    local max_mastery_distance = 40  -- max range
    local benefit = 1 - (distance / max_mastery_distance)
    
    -- Clamp the result between 0 and 1
    return math.max(0, math.min(1, benefit))
end

-- Score a target based on priority factors for Dawnlight application
-- This is the core targeting algorithm that determines which allies should receive Dawnlight
-- It considers multiple factors and adjusts priorities based on current game state
---@param unit table WoW unit object - the potential target to score
---@param player table WoW player unit object - the paladin player
---@param priority_multiplier? number Optional multiplier to adjust priority (default: 1.0)
---@return number Priority score (higher is better)
local function score_dawnlight_target(unit, player, priority_multiplier)
    priority_multiplier = priority_multiplier or 1.0
    
    -- Early exit: Already has Dawnlight, skip this target completely
    if FS.variables.buff_up(FS.paladin_holy_herald.auras.dawnlight, unit) then
        return 0
    end
    
    -- Calculate base scores for different criteria
    -- Role score - tanks > melee > ranged (converts to 3 > 2 > 1)
    local role_score = 4 - get_unit_role_priority(unit)  -- Convert to 1-3 where higher is better
    
    -- Health score - lower health generally means higher priority
    local health_score = 1 - unit.health_percentage  -- Lower health = higher score
    
    -- Mastery score - closer targets benefit more from paladin mastery
    local mastery_score = calculate_mastery_benefit(unit, player)
    
    -- Additional factors based on current cooldown state
    -- --------------------------------------------------------
    
    -- Special scoring for Avenging Wrath - prioritize for beam intersections
    if FS.paladin_holy_herald.variables.avenging_wrath_up() then
        -- During Avenging Wrath, prioritize tanks and targets that will create
        -- better beam intersections with existing Dawnlight targets
        if unit.is_tank then
            role_score = role_score * 1.3  -- Boost tank priority for better beams
        end
    end
    
    -- Special scoring for Awakening (mini-Avenging Wrath proc)
    if FS.paladin_holy_herald.variables.awakening_max_remains() > 0 then
        -- During Awakening, we want targets that will get the most benefit
        -- Slightly prefer higher health targets during Awakening (contrary to normal)
        -- since Awakening provides significant burst healing already
        health_score = 0.5 + (unit.health_percentage * 0.5) -- Higher health = higher score during Awakening
    end
    
    -- Special scoring for Holy Prism state - this adjusts priority based on
    -- how many Holy Power spenders we have left to apply Dawnlight
    if FS.paladin_holy_herald.variables.post_holy_prism_state() then
        -- If we're running out of Holy Power spenders, prioritize applying Dawnlight
        local spenders_remaining = FS.paladin_holy_herald.variables.max_holy_power_spenders_window - 
                                 FS.paladin_holy_herald.variables.holy_power_spenders_since_prism
        
        if spenders_remaining == 1 then
            -- Last chance to apply Dawnlight, boost priority significantly
            priority_multiplier = priority_multiplier * 1.5
        end
    end
    
    -- Weight the different factors 
    -- These weights balance the importance of each criterion and can be tuned
    local role_weight = 0.35    -- 35% weight for role-based targeting
    local health_weight = 0.25   -- 25% weight for health-based targeting
    local mastery_weight = 0.4   -- 40% weight for mastery benefit (proximity)
    
    -- Calculate the final base score using weighted factors
    local base_score = (role_score * role_weight) + 
                     (health_score * health_weight) + 
                     (mastery_score * mastery_weight)
    
    -- Apply priority multiplier to final score
    return base_score * priority_multiplier
end

-- Find the best targets for Dawnlight application based on cooldown state
-- This function scores all available targets and returns the top N targets for Dawnlight application
-- The selection is based on the scoring algorithm and adjusts for different game states
---@param max_targets number Maximum number of targets to find
---@param priority_multiplier? number Optional multiplier to adjust priority (default: 1.0)
---@return table Array of target unit objects sorted by priority
local function find_best_dawnlight_targets(max_targets, priority_multiplier)
    priority_multiplier = priority_multiplier or 1.0
    local player = FS.variables.me
    local scored_targets = {}
    
    -- Score each available target in the raid/party
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        local score = score_dawnlight_target(unit, player, priority_multiplier)
        -- Only include targets with positive scores (valid targets)
        if score > 0 then
            table.insert(scored_targets, {unit = unit, score = score})
        end
    end
    
    -- Sort by score (highest first) to get the best targets at the top
    table.sort(scored_targets, function(a, b) return a.score > b.score end)
    
    -- Return only the needed number of targets (limited by max_targets)
    local result = {}
    for i = 1, math.min(max_targets, #scored_targets) do
        table.insert(result, scored_targets[i].unit)
    end
    
    return result
end

-- Calculate the average position of a group of units
-- This is the starting point for beam optimization, providing a centroid position
-- from which to refine the optimal position for beam intersections
---@param units table Array of unit IDs to include in calculation
---@return table|nil Position {x, y, z} or nil if cannot calculate
local function calculate_average_position(units)
    -- Early exit if no units provided
    if #units == 0 then
        return nil
    end
    
    -- Initialize sum variables for position averaging
    local sum_x, sum_y, sum_z = 0, 0, 0
    local valid_count = 0
    
    -- Sum up all valid unit positions
    for _, unit in ipairs(units) do
        local pos = unit:get_position()
        if pos then
            sum_x = sum_x + pos.x
            sum_y = sum_y + pos.y
            sum_z = sum_z + pos.z
            valid_count = valid_count + 1
        end
    end
    
    -- Safety check: ensure we had at least one valid position
    if valid_count == 0 then
        return nil
    end
    
    -- Return the average position (centroid) of all units
    return {
        x = sum_x / valid_count,
        y = sum_y / valid_count,
        z = sum_z / valid_count
    }
end

-- Calculate beam intersections for a player position and target units
-- This is the core function of the beam optimization system that counts how many
-- beam intersections occur at a given player position, which determines healing output
---@param player_pos table Player position {x, y, z}
---@param target_positions table Array of target positions {x, y, z}
---@return number Number of beam intersections
local function calculate_beam_intersections(player_pos, target_positions)
    local intersections = 0
    
    -- Check each pair of beams for intersection
    -- We need to test all pairs of beams (n choose 2) = n(n-1)/2 combinations
    for i = 1, #target_positions do
        for j = i + 1, #target_positions do
            -- Get the endpoints for the two beams we're checking
            local beam1_end = target_positions[i]
            local beam2_end = target_positions[j]
            
            -- Use the geometry API to check for line intersection
            -- Both lines start at the player position and extend to different targets
            local intersection = FS.api.geometry:get_line_intersection(
                player_pos, beam1_end,
                player_pos, beam2_end
            )
            
            -- If an intersection is found, increment our counter
            if intersection then
                intersections = intersections + 1
            end
        end
    end
    
    return intersections
end

-- Find the optimal player position for maximum beam intersections
-- This is the main beam optimization algorithm that determines where the player should stand
-- to maximize the number of beam intersections, which increases healing output during Avenging Wrath
---@param targets table Array of unit IDs with Dawnlight
---@return table|nil Optimal position {x, y, z} or nil if cannot calculate
local function find_optimal_position(targets)
    -- We need at least 3 targets to have any possible beam intersections
    -- (With 2 targets, there's only 1 beam and no intersections possible)
    if #targets < 3 then
        return nil -- Need at least 3 targets for meaningful optimization
    end
    
    -- Extract positions from all target units
    local target_positions = {}
    for _, unit in ipairs(targets) do
        local pos = unit:get_position()
        if pos then
            table.insert(target_positions, pos)
        end
    end
    
    -- Verify we still have enough targets with valid positions
    if #target_positions < 3 then
        return nil
    end
    
    -- Start with the average position (centroid) as our baseline
    -- This provides a good initial guess that is likely to be near the optimal position
    local current_position = calculate_average_position(targets)
    if not current_position then
        return nil
    end
    
    -- Simple hill-climbing optimization algorithm:
    -- 1. Start at the centroid position
    -- 2. Try moving in several directions
    -- 3. Keep the best position (most intersections)
    
    local best_position = current_position
    local best_intersections = calculate_beam_intersections(current_position, target_positions)
    
    -- Define the search space - we'll try steps in 8 directions (cardinal + diagonals)
    local step_size = 2  -- 2 meter steps
    local directions = {
        {x = 1, y = 0, z = 0},    -- East
        {x = -1, y = 0, z = 0},   -- West
        {x = 0, y = 1, z = 0},    -- North
        {x = 0, y = -1, z = 0},   -- South
        {x = 1, y = 1, z = 0},    -- Northeast
        {x = -1, y = 1, z = 0},   -- Northwest
        {x = 1, y = -1, z = 0},   -- Southeast
        {x = -1, y = -1, z = 0}   -- Southwest
    }
    
    -- Test each direction to see if we get better results
    for _, dir in ipairs(directions) do
        -- Generate test position by moving in the current direction
        local test_pos = {
            x = current_position.x + (dir.x * step_size),
            y = current_position.y + (dir.y * step_size),
            z = current_position.z + (dir.z * step_size)
        }
        
        -- Calculate intersections at this test position
        local intersections = calculate_beam_intersections(test_pos, target_positions)
        
        -- If this position is better, update our best position
        if intersections > best_intersections then
            best_position = test_pos
            best_intersections = intersections
        end
    end
    
    -- Return the position with the most beam intersections
    return best_position
end

-------------------------------------------------------------------------------------------------------------------
-- Apply Dawnlight
--
-- This is the main entry point for Dawnlight application. It determines:
-- 1. How many targets can receive Dawnlight based on current buffs (1 normally, 4 during Avenging Wrath)
-- 2. Which targets should receive Dawnlight based on role, health, and position
-- 3. Whether to optimize player position for beam intersections (during Avenging Wrath)
-- 4. Special handling for different states (Avenging Wrath, Awakening, post-Holy Prism)
--
-- This function is called at the beginning of the healing rotation to prioritize 
-- Dawnlight application after using Holy Prism
-------------------------------------------------------------------------------------------------------------------
---@return boolean True if Dawnlight application is ready, false otherwise
function FS.paladin_holy_herald.logic.spells.apply_dawnlight()
    local player = FS.variables.me
    local max_targets = 1  -- Default to 1 target for normal gameplay
    
    -- Adjust max targets based on current buffs/cooldowns
    -- Avenging Wrath allows up to 4 Dawnlight targets for beam intersections
    if FS.paladin_holy_herald.variables.avenging_wrath_up() then
        max_targets = 4  -- During Avenging Wrath, we can have up to 4 Dawnlight targets
    elseif FS.paladin_holy_herald.variables.awakening_max_remains() > 0 then
        max_targets = 1  -- During Awakening, just apply to 1 target
    end
    
    -- Early exit if we've reached our max target count
    local current_dawnlight_count = FS.paladin_holy_herald.variables.dawnlight_count()
    if current_dawnlight_count >= max_targets then
        return false
    end
    
    -- Early exit if Holy Prism wasn't cast recently or all Holy Power spenders used
    -- Dawnlight can only be applied during the window after Holy Prism
    if not FS.paladin_holy_herald.variables.post_holy_prism_state() then
        return false
    end
    
    -- Calculate how many more Dawnlight buffs we can apply in this cycle
    local remaining_applications = max_targets - current_dawnlight_count
    
    -- Get the Holy Power spender counter to determine priority
    -- This tracks how many spenders we've used since Holy Prism was cast
    local spenders_used = FS.paladin_holy_herald.variables.holy_power_spenders_since_prism
    local max_spenders = FS.paladin_holy_herald.variables.max_holy_power_spenders_window
    local spenders_remaining = max_spenders - spenders_used
    
    -- Adjust priority based on spenders remaining and targets needed
    local priority_multiplier = 1.0
    
    -- If we're on our last opportunity to apply Dawnlight, significantly increase priority
    if spenders_remaining == 1 and remaining_applications > 0 then
        priority_multiplier = 2.0  -- Boost priority for last chance to apply
    end
    
    -- Find best targets to apply Dawnlight to using our scoring system
    local best_targets = find_best_dawnlight_targets(remaining_applications, priority_multiplier)
    if #best_targets == 0 then
        return false
    end
    
    -- Get the highest priority target from our scored list
    local target = best_targets[1]
    
    -- If setting is enabled to prioritize self and player doesn't have Dawnlight
    -- This is often preferred for better positioning control with beams
    if FS.paladin_holy_herald.settings.prioritize_self_dawnlight() and 
       not FS.paladin_holy_herald.variables.dawnlight_up() then
        target = player
    end
    
    -- Special handling for Avenging Wrath - try to maximize beam intersections
    -- Once we have 3+ targets with Dawnlight, we can optimize player position
    if FS.paladin_holy_herald.variables.avenging_wrath_up() and current_dawnlight_count >= 3 then
        -- With 3+ targets, optimize for beam intersections
        FS.paladin_holy_herald.variables.optimal_beam_position = find_optimal_position(
            FS.paladin_holy_herald.variables.dawnlight_targets()
        )
    end
    
    -- Special handling for Awakening - prioritize higher health targets that benefit most
    if FS.paladin_holy_herald.variables.awakening_max_remains() > 0 then
        -- During Awakening, focus on higher health targets since Awakening provides 
        -- significant healing already, and we want Dawnlight on targets that will last
        target = best_targets[1]  -- Already sorted by our scoring function
    end
    
    -- Update visualization information for the drawing system
    if FS.paladin_holy_herald.variables.optimal_beam_position == nil then
        FS.paladin_holy_herald.variables.optimal_beam_position = find_optimal_position(
            FS.paladin_holy_herald.variables.dawnlight_targets()
        )
    end
    
    -- We have a valid target, Dawnlight will be applied through our next Holy Power spender
    -- Note: The actual Dawnlight application happens via the Word of Glory/Light of Dawn/Eternal Flame spell casts
    return true
end

-------------------------------------------------------------------------------------------------------------------
-- Optimize Dawnlight Beams
--
-- This function is responsible for calculating and tracking the optimal player position
-- for maximizing beam intersections during Avenging Wrath. It's called in the main rotation
-- when Avenging Wrath is active and the beam optimization setting is enabled.
-- 
-- The optimization happens in these steps:
-- 1. Check if we're in Avenging Wrath and have enough Dawnlight targets
-- 2. Calculate the optimal position for maximum beam intersections
-- 3. Update the UI variables for the drawing system to display positioning guidance
-------------------------------------------------------------------------------------------------------------------
---@return boolean True if optimization was performed, false otherwise
function FS.paladin_holy_herald.logic.spells.optimize_dawnlight_beams()
    -- Only meaningful during Avenging Wrath when multiple beams can intersect
    if not FS.paladin_holy_herald.variables.avenging_wrath_up() then
        return false
    end
    
    -- Find all units with Dawnlight using the dawnlight_targets function
    local dawnlight_targets = FS.paladin_holy_herald.variables.dawnlight_targets()
    
    -- No optimization needed if we don't have enough beams for intersections
    -- Need at least 3 targets to have any intersections
    if #dawnlight_targets < 3 then
        return false
    end
    
    -- Calculate and store optimal position in a global variable for the drawing system to use
    -- This allows the UI to show a visual indicator of where to stand
    FS.paladin_holy_herald.variables.optimal_beam_position = find_optimal_position(dawnlight_targets)
    
    -- Also calculate and store the current intersection count for UI display
    -- This shows the player how many intersections they currently have
    FS.paladin_holy_herald.variables.update_beam_intersections()
    
    return true
end

-------------------------------------------------------------------------------------------------------------------
-- Get Current Intersection Count
--
-- This utility function calculates how many beam intersections are occurring
-- at the player's current position. It's used for UI display and to help
-- players understand how effective their current position is.
--
-- The count is used by the drawing system to show the effectiveness of the current
-- beam configuration during Avenging Wrath.
-------------------------------------------------------------------------------------------------------------------
---@return number Number of beam intersections at the current player position
function FS.paladin_holy_herald.logic.spells.get_current_intersection_count()
    local player = FS.variables.me
    local player_pos = player:get_position()
    
    -- Safety check for player position
    if not player_pos then
        return 0
    end
    
    -- Get all current targets with Dawnlight 
    local dawnlight_targets = FS.paladin_holy_herald.variables.dawnlight_targets()
    local target_positions = {}
    
    -- Extract position information from each target
    for _, unit in ipairs(dawnlight_targets) do
        local target_pos = unit:get_position()
        if target_pos then
            table.insert(target_positions, target_pos)
        end
    end
    
    -- Calculate intersections at the player's current position
    return calculate_beam_intersections(player_pos, target_positions)
end