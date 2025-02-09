FS.humanizer = {
    next_run = 0
}

function FS.humanizer.can_run()
    return core:game_time() >= FS.humanizer.next_run
end

function FS.humanizer.update()
    local latency = core.get_ping() * 1.5
    local min_delay = FS.settings.min_delay() + latency
    local max_delay = FS.settings.max_delay() + latency
    FS.humanizer.next_run = math.random(min_delay, max_delay) + core:game_time()
end
