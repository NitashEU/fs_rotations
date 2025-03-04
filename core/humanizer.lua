FS.humanizer = {
    next_run = 0,
}

---Applies jitter to a delay value
---@param delay number The base delay value
---@param latency number The current latency value
---@return number The delay with jitter applied
local function apply_jitter(delay, latency)
    if not FS.settings.jitter.is_enabled() then
        return delay
    end

    local latency_factor = math.min(latency / 200, 1) -- Normalize latency impact

    -- Calculate jitter percentage based on base jitter and latency
    local jitter_percent = FS.settings.jitter.base_jitter() +
        (FS.settings.jitter.latency_jitter() * latency_factor)

    -- Clamp total jitter to max_jitter
    jitter_percent = math.min(jitter_percent, FS.settings.jitter.max_jitter())

    -- Calculate jitter range
    local jitter_range = delay * jitter_percent

    -- Apply random jitter within range
    return delay + (math.random() * 2 - 1) * jitter_range
end

function FS.humanizer.can_run()
    return core.game_time() >= FS.humanizer.next_run
end

function FS.humanizer.update()
    local latency = core.get_ping() * 1.5
    local min_delay = FS.settings.min_delay() + latency
    local max_delay = FS.settings.max_delay() + latency

    -- Get base delay
    local base_delay = math.random(min_delay, max_delay)

    -- Apply jitter to the delay
    local final_delay = apply_jitter(base_delay, latency)

    FS.humanizer.next_run = final_delay + core.game_time()
end
