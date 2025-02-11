# System Patterns

## Target Selection Patterns

### Health-Based Selection

- Used for direct healing spells
- Prioritizes raw health missing or health percentage
- Examples: get_single_target.lua

### Damage-Based Selection

- Used for preventive healing and tank priority
- Considers incoming damage and damage patterns
- Examples: get_tank_damage_target.lua, get_healer_damage_target.lua

### Multi-Target Selection

- Used for AoE and chain healing spells
- Considers spatial relationships between targets
- Examples: get_group_heal_target.lua

### Clustered Heal Selection (New Pattern)

- Used for spells requiring optimal target clustering
- Balances multiple metrics (health, damage, positioning)
- Examples: get_clustered_heal_target.lua
- Key Characteristics:
  - Multiple metric evaluation
  - Spatial relationship validation
  - Target count requirements
  - Range-based calculations
  - Optional distance-based prioritization

## Implementation Patterns

### Target Selector Structure

```lua
-- Standard target selector structure
local function get_clustered_heal_target(params)
    -- Parameter validation
    if not validate_params(params) then return nil end

    -- Target filtering
    local valid_targets = filter_targets(params)

    -- Metric calculation with distance priority
    local best_target = find_best_target(valid_targets, params)

    -- Result validation
    return validate_result(best_target, params)
end
```

### Parameter Validation Pattern

```lua
-- Required parameters
local required_params = {
    threshold = "number",
    min_targets = "number",
    max_targets = "number",
    range = "number",
    prioritize_distance = "boolean"
}

-- Validation helper
local function validate_params(params)
    for param, type_name in pairs(required_params) do
        if type(params[param]) ~= type_name then
            return false
        end
    end
    return true
end
```

### Target Filtering Pattern

```lua
-- Filter targets based on requirements
local function filter_targets(targets, params)
    local valid_targets = {}
    for _, target in ipairs(targets) do
        if meets_requirements(target, params) then
            table.insert(valid_targets, target)
        end
    end
    return valid_targets
end
```

### Metric Calculation Pattern

```lua
-- Calculate combined metrics
local function calculate_target_score(target, params)
    local health_score = calculate_health_score(target)
    local damage_score = calculate_damage_score(target)
    local nearby_targets = count_nearby_targets(target, params.range)
    local distance_score = calculate_distance_score(target, params)

    -- Combine scores with appropriate weights
    local final_score = (health_score * 0.4) +
                       (damage_score * 0.3) +
                       (nearby_targets / params.max_targets * 0.2) +
                       (distance_score * 0.1)

    return final_score
end

-- Calculate distance-based score
local function calculate_distance_score(target, params)
    if not params.prioritize_distance then
        return 1.0 -- No distance weighting
    end

    local distance = get_distance_to_player(target)
    -- Score decreases linearly with distance
    return math.max(0.1, 1.0 - (distance / params.range))
end
```

### Result Validation Pattern

```lua
-- Validate final result
local function validate_result(target, params)
    if not target then return nil end

    local nearby_count = count_nearby_targets(target, params.range)
    if nearby_count < params.min_targets then return nil end

    return target
end
```

## Implementation Guidelines

1. Use local functions for clear scope and better performance
2. Implement parameter validation early
3. Filter invalid targets before scoring
4. Calculate combined metrics efficiently
5. Apply distance prioritization when specified
6. Validate final result before returning

### Key Considerations

- Balance between health needs and positioning
- Efficient distance calculations
- Proper weighting of different metrics
- Clear separation of concerns in implementation
- Reusability across different healing spells
- Distance prioritization as an optional feature
- Flexible scoring system for different healing scenarios
