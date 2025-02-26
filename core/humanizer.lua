FS.humanizer = {
    next_run = 0,
}

---Applies jitter to a delay value
---@param delay number The base delay value
---@param latency number The current latency value
---@return number The delay with jitter applied
local function apply_jitter(delay, latency)
    -- Get jitter configuration from centralized config
    local jitter_enabled = FS.config:get("core.humanizer.jitter.enabled", true)
    if not jitter_enabled then
        return delay
    end

    local base_jitter = FS.config:get("core.humanizer.jitter.base", 0.1)
    local latency_jitter = FS.config:get("core.humanizer.jitter.latency", 0.2)
    local max_jitter = FS.config:get("core.humanizer.jitter.max", 0.3)
    local latency_cap = FS.config:get("core.humanizer.latency_cap", 200)

    -- Normalize latency impact
    local latency_factor = math.min(latency / latency_cap, 1)

    -- Calculate jitter percentage based on base jitter and latency
    local jitter_percent = base_jitter + (latency_jitter * latency_factor)

    -- Clamp total jitter to max_jitter
    jitter_percent = math.min(jitter_percent, max_jitter)

    -- Calculate jitter range
    local jitter_range = delay * jitter_percent

    -- Apply random jitter within range
    return delay + (math.random() * 2 - 1) * jitter_range
end

function FS.humanizer.can_run()
    return core.game_time() >= FS.humanizer.next_run
end

function FS.humanizer.update()
    -- Get configuration values
    local latency_factor = FS.config:get("core.humanizer.latency_factor", 1.5)
    local min_delay_base = FS.config:get("core.humanizer.min_delay", 50)
    local max_delay_base = FS.config:get("core.humanizer.max_delay", 150)

    -- Calculate actual delays based on latency
    local latency = core.get_ping() * latency_factor
    local min_delay = min_delay_base + latency
    local max_delay = max_delay_base + latency

    -- Get base delay
    local base_delay = math.random(min_delay, max_delay)

    -- Apply jitter to the delay
    local final_delay = apply_jitter(base_delay, latency)

    -- Set next execution time
    FS.humanizer.next_run = final_delay + core.game_time()
end
