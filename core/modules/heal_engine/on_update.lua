local RingBuffer = require("core/modules/heal_engine/ring_buffer")

function FS.modules.heal_engine.on_update()
    local is_in_combat = FS.variables.me:is_in_combat()
    if is_in_combat and not FS.modules.heal_engine.is_in_combat then
        local buffer_size = FS.modules.heal_engine.buffer_size or 30
        for _, unit in pairs(FS.modules.heal_engine.units) do
            local hv = FS.modules.heal_engine.health_values[unit]
            if type(hv) ~= "table" or not hv.append then
                local rb = RingBuffer:new(buffer_size)
                if type(hv) == "table" then
                    for _, snapshot in ipairs(hv) do
                        rb:append(snapshot)
                    end
                end
                FS.modules.heal_engine.health_values[unit] = rb
            end
        end
        FS.modules.heal_engine.is_in_combat = true
        FS.modules.heal_engine.start()
    elseif not is_in_combat and FS.modules.heal_engine.is_in_combat then
        FS.modules.heal_engine.is_in_combat = false
        FS.modules.heal_engine.reset()
    end
    if FS.modules.heal_engine.is_in_combat then
        for _, unit in pairs(FS.modules.heal_engine.units) do
            FS.modules.heal_engine.damage_taken_per_second[unit] = FS.modules.heal_engine.get_damage_taken_per_second(
                unit, 1)
            FS.modules.heal_engine.damage_taken_per_second_last_5_seconds[unit] = FS.modules.heal_engine
                .get_damage_taken_per_second(unit, 5)
            FS.modules.heal_engine.damage_taken_per_second_last_10_seconds[unit] = FS.modules.heal_engine
                .get_damage_taken_per_second(unit, 10)
            FS.modules.heal_engine.damage_taken_per_second_last_15_seconds[unit] = FS.modules.heal_engine
                .get_damage_taken_per_second(unit, 15)
        end
    end
end

function FS.modules.heal_engine.on_fast_update()
    if not FS.modules.heal_engine.is_in_combat then
        return
    end

    local current_time = core.game_time()
    local retention_ms = FS.modules.heal_engine.retention_window_ms or 15000
    local buffer_size = FS.modules.heal_engine.buffer_size or 30

    -- For each unit, ensure the health snapshots are stored in a RingBuffer without losing historical data.
    for _, unit in pairs(FS.modules.heal_engine.units) do
        local hv = FS.modules.heal_engine.health_values[unit]
        if hv == nil then
            FS.modules.heal_engine.health_values[unit] = RingBuffer:new(buffer_size)
        elseif type(hv) == "table" and not hv.append then
            -- Convert existing plain array of snapshots to a RingBuffer while preserving history
            local rb = RingBuffer:new(buffer_size)
            for _, snapshot in ipairs(hv) do
                rb:append(snapshot)
            end
            FS.modules.heal_engine.health_values[unit] = rb
        end
        local rb = FS.modules.heal_engine.health_values[unit]
        rb:purge_old(current_time, retention_ms)
    end

    -- Record new snapshots.
    for _, unit in pairs(FS.modules.heal_engine.units) do
        local rb = FS.modules.heal_engine.health_values[unit]
        local snapshots = rb:to_array()
        local last_value = (#snapshots > 0 and snapshots[#snapshots]) or nil
        local new_value = {
            health = unit:get_health() + unit:get_total_shield(),
            max_health = unit:get_max_health(),
            health_percentage = (unit:get_health() + unit:get_total_shield()) / unit:get_max_health(),
            time = current_time
        }
        if not last_value or last_value.health ~= new_value.health then
            rb:append(new_value)
            FS.modules.heal_engine.current_health_values[unit] = new_value
        end
    end
end
