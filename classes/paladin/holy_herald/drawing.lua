FS.paladin_holy_herald.drawing = {}

-- Function to draw a line between two units
---@param from_unit table WoW unit object from which to start the line
---@param to_unit table WoW unit object at which to end the line
---@param color table Color with r, g, b, a values (0-255)
---@param thickness number Line thickness
local function draw_beam_line(from_unit, to_unit, color, thickness)
    local from_pos = from_unit:get_position()
    local to_pos = to_unit:get_position()
    
    if from_pos and to_pos then
        FS.api.graphics:draw_line(from_pos, to_pos, color, thickness)
    end
end

-- Function to calculate intersection points between beams
---@param beams table Array of beam information containing from_pos and to_pos
---@return table Array of intersection points (x, y, z coordinates)
local function calculate_beam_intersections(beams)
    local intersections = {}
    local vec3 = require("common/geometry/vector_3")
    
    -- For each pair of beams, check if they intersect
    for i = 1, #beams do
        for j = i + 1, #beams do
            local beam1 = beams[i]
            local beam2 = beams[j]
            
            -- Create line objects using vec3
            local line1_start = vec3.new(beam1.from_pos.x, beam1.from_pos.y, beam1.from_pos.z)
            local line1_end = vec3.new(beam1.to_pos.x, beam1.to_pos.y, beam1.to_pos.z)
            local line2_start = vec3.new(beam2.from_pos.x, beam2.from_pos.y, beam2.from_pos.z)
            local line2_end = vec3.new(beam2.to_pos.x, beam2.to_pos.y, beam2.to_pos.z)
            
            -- Calculate intersection (simplified 2D intersection)
            -- Using geometry API to find intersection
            local line1 = FS.api.geometry:create_line(line1_start, line1_end)
            local line2 = FS.api.geometry:create_line(line2_start, line2_end)
            
            local intersection = line1:intersects_with(line2)
            
            if intersection then
                table.insert(intersections, intersection)
            end
        end
    end
    
    return intersections
end

-- Calculate the optimal player position for maximum beam intersections
---@param targets table Array of target unit objects with Dawnlight
---@return table Position (x, y, z) for optimal player positioning or nil if cannot calculate
local function calculate_optimal_position(targets)
    if #targets < 3 then
        return nil  -- Need at least 3 targets for meaningful optimization
    end
    
    -- In a real implementation, this would be a complex algorithm that calculates
    -- the optimal player position to maximize beam intersections
    -- For now, we'll use a simplified approach: the center of mass of all targets
    local sum_x, sum_y, sum_z = 0, 0, 0
    local valid_targets = 0
    
    for _, target in ipairs(targets) do
        local pos = target:get_position()
        if pos then
            sum_x = sum_x + pos.x
            sum_y = sum_y + pos.y
            sum_z = sum_z + pos.z
            valid_targets = valid_targets + 1
        end
    end
    
    if valid_targets > 0 then
        local vec3 = require("common/geometry/vector_3")
        return vec3.new(
            sum_x / valid_targets,
            sum_y / valid_targets,
            sum_z / valid_targets
        )
    end
    
    return nil
end

-- Draw a radius indicator showing optimal positioning
---@param position table Position (x, y, z) around which to draw the radius
---@param radius number Radius size
---@param color table Color with r, g, b, a values (0-255)
local function draw_radius_indicator(position, radius, color)
    if position then
        local vec3 = require("common/geometry/vector_3")
        
        -- Draw a circle on the ground
        local circle = FS.api.geometry:create_circle(position, radius)
        FS.api.graphics:draw_circle(circle, color, 2)
        
        -- Draw a vertical beam at the position
        local top_position = vec3.new(position.x, position.y, position.z + 5)
        FS.api.graphics:draw_line(position, top_position, color, 3)
    end
end

-- Helper function to draw Awakening stack indicator
local function draw_awakening_indicator()
    if not FS.paladin_holy_herald.talents.awakening then
        return
    end
    
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    local text_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + 4) -- Positioned above player
    
    -- Check if Awakening max buff is active
    if FS.paladin_holy_herald.variables.awakening_max_remains() > 0 then
        -- Awakening is at max stacks - show a special indicator
        local awakening_text = "Awakening MAX"
        local awakening_color = {r = 255, g = 100, b = 0, a = 255} -- Bright orange for max
        
        FS.api.graphics:draw_text(text_pos, awakening_text, awakening_color)
    else
        -- Show current stack count
        local stacks = FS.paladin_holy_herald.variables.awakening_stacks()
        local max_stacks = 15 -- Max stacks for Awakening
        local awakening_text = string.format("Awakening: %d/%d", stacks, max_stacks)
        
        -- Color coding based on stack count
        local r, g, b = 255, 255, 255 -- Default white
        
        if stacks >= 13 then
            -- Near max (13-14): orange-yellow to indicate getting close
            r, g, b = 255, 165, 0
        elseif stacks >= 10 then
            -- Getting close (10-12): yellow
            r, g, b = 255, 255, 0
        elseif stacks >= 5 then
            -- Making progress (5-9): light blue
            r, g, b = 173, 216, 230
        end
        
        local awakening_color = {r = r, g = g, b = b, a = 255}
        FS.api.graphics:draw_text(text_pos, awakening_text, awakening_color)
    end
end

-- Draw Gleaming Rays buff indicator
local function draw_gleaming_rays_indicator()
    if not FS.paladin_holy_herald.variables.gleaming_rays_up() then
        return
    end
    
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    local text_pos = vec3.new(player_pos.x - 2, player_pos.y, player_pos.z + 3) -- Offset to left side
    
    local remains = FS.paladin_holy_herald.variables.gleaming_rays_remains() / 1000 -- Convert to seconds
    local rays_text = string.format("Gleaming Rays: %.1fs", remains)
    
    -- Pulse effect based on remaining time
    local alpha = 200 + 55 * math.sin(core.time() / 300) -- Pulsing effect
    
    -- Yellow-gold color for Gleaming Rays
    local rays_color = {r = 255, g = 215, b = 0, a = alpha}
    FS.api.graphics:draw_text(text_pos, rays_text, rays_color)
    
    -- Draw a small sun icon or circle to represent the buff visually
    local icon_pos = vec3.new(player_pos.x - 3, player_pos.y, player_pos.z + 2.7)
    local circle = FS.api.geometry:create_circle(icon_pos, 0.2)
    FS.api.graphics:draw_circle(circle, rays_color, 2)
end

-- Draw Solar Grace stack indicator
local function draw_solar_grace_indicator()
    local stacks = FS.paladin_holy_herald.variables.solar_grace_stacks()
    if not stacks or stacks == 0 then
        return
    end
    
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    local text_pos = vec3.new(player_pos.x + 2, player_pos.y, player_pos.z + 3) -- Offset to right side
    
    local remains = FS.paladin_holy_herald.variables.solar_grace_remains() / 1000 -- Convert to seconds
    local haste_bonus = FS.paladin_holy_herald.variables.get_solar_grace_haste_bonus() * 100 -- Convert to percentage
    local grace_text = string.format("Solar Grace: %d (%.1f%% haste)", stacks, haste_bonus)
    
    -- Brighten color based on stack count (more stacks = brighter)
    local brightness = math.min(230 + (stacks * 5), 255)
    local grace_color = {r = brightness, g = brightness, b = 150, a = 255}
    FS.api.graphics:draw_text(text_pos, grace_text, grace_color)
    
    -- Draw stacks as small dots in a row
    for i = 1, stacks do
        local dot_pos = vec3.new(player_pos.x + 1.8 + (i * 0.2), player_pos.y, player_pos.z + 2.7)
        local circle = FS.api.geometry:create_circle(dot_pos, 0.05)
        local dot_color = {r = brightness, g = brightness, b = 150, a = 230}
        FS.api.graphics:draw_circle(circle, dot_color, 1)
    end
end

-- Draw Rising Sunlight indicator with Holy Power prediction
local function draw_rising_sunlight_indicator()
    if not FS.paladin_holy_herald.variables.rising_sunlight_up() then
        return
    end
    
    -- Update status tracking
    FS.paladin_holy_herald.variables.update_rising_sunlight_status()
    
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    local text_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + 3.5) -- Positioned above Awakening
    
    local remains = FS.paladin_holy_herald.variables.rising_sunlight_remains() / 1000 -- Convert to seconds
    local current_hp = FS.paladin_holy_herald.variables.holy_power()
    local predicted_hp = FS.paladin_holy_herald.variables.get_predicted_holy_power()
    
    local sunlight_text = string.format("Rising Sunlight: %.1fs", remains)
    local hp_text = string.format("HP: %d → %d", current_hp, predicted_hp)
    
    -- Red warning color when at risk of overcapping
    local sunlight_color
    if FS.paladin_holy_herald.variables.is_holy_power_overcap_risk() then
        sunlight_color = {r = 255, g = 50, b = 50, a = 255} -- Red warning
    else
        sunlight_color = {r = 255, g = 150, b = 0, a = 255} -- Orange normal
    end
    
    FS.api.graphics:draw_text(text_pos, sunlight_text, sunlight_color)
    
    -- Draw HP prediction text slightly below
    local hp_text_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + 3.2)
    FS.api.graphics:draw_text(hp_text_pos, hp_text, sunlight_color)
    
    -- Draw small sun icon that pulses with the buff duration
    local pulse_scale = 0.8 + 0.2 * math.sin(core.time() / 200) -- Pulsing effect
    local icon_pos = vec3.new(player_pos.x - 3, player_pos.y, player_pos.z + 3.3)
    local circle = FS.api.geometry:create_circle(icon_pos, 0.25 * pulse_scale)
    FS.api.graphics:draw_circle(circle, sunlight_color, 2)
end

-- Draw Holy Power overcap warning indicator
local function draw_holy_power_warning()
    local current_hp = FS.paladin_holy_herald.variables.get_holy_power_as_number()
    local max_hp = FS.paladin_holy_herald.variables.max_holy_power
    
    -- Only show warning when nearing cap or additional HP is incoming
    if current_hp < max_hp - 1 then
        return
    end
    
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    
    -- Different display based on how close to overcapping
    local warning_text
    local warning_color
    local position_offset = 2.7 -- Position near but not on top of other indicators
    
    local incoming_hp = FS.paladin_holy_herald.variables.estimate_upcoming_holy_power(3)
    local is_imminent_overcap = (current_hp + incoming_hp) > max_hp
    
    if current_hp >= max_hp then
        -- Already overcapped
        warning_text = "⚠ HOLY POWER CAPPED ⚠"
        warning_color = {r = 255, g = 0, b = 0, a = 255} -- Bright red
        
        -- Pulsing animation for capped state
        local pulse = 0.7 + 0.3 * math.abs(math.sin(core.time() / 150))
        warning_color.r = warning_color.r * pulse
    elseif is_imminent_overcap then
        -- About to overcap based on incoming resources
        warning_text = "⚠ HP Overcap Imminent ⚠"
        warning_color = {r = 255, g = 80, b = 0, a = 255} -- Orange-red
    else
        -- Nearing cap but not immediate
        warning_text = "Holy Power: " .. current_hp .. "/" .. max_hp
        warning_color = {r = 255, g = 160, b = 0, a = 200} -- Yellow-orange
    end
    
    -- Position the text at player's position plus offset
    local text_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + position_offset)
    FS.api.graphics:draw_text(text_pos, warning_text, warning_color)
    
    -- Show spend recommendation when capped
    if current_hp >= max_hp or is_imminent_overcap then
        local advice_text = "Use HP spender now!"
        local advice_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + position_offset - 0.3)
        FS.api.graphics:draw_text(advice_pos, advice_text, warning_color)
    end
end

-- Draw Sun's Avatar beam connections
local function draw_suns_avatar_connections()
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    -- Find all targets with Sun's Avatar buff
    local suns_avatar_targets = FS.paladin_holy_herald.variables.suns_avatar_targets()
    if #suns_avatar_targets == 0 then return end
    
    local vec3 = require("common/geometry/vector_3")
    
    -- Process each target
    for _, unit in ipairs(suns_avatar_targets) do
        local target_pos = unit:get_position()
        if target_pos then
            -- Draw beam line to this target with a distinctive solar appearance
            local beam_color = {r = 255, g = 220, b = 50, a = 200}  -- Bright yellow for Sun's Avatar
            draw_beam_line(player_unit, unit, beam_color, 3)  -- Thicker beam for visibility
            
            -- Add a sun icon at the target's position
            local icon_pos = vec3.new(target_pos.x, target_pos.y, target_pos.z + 2)
            local circle = FS.api.geometry:create_circle(icon_pos, 0.3)
            FS.api.graphics:draw_circle(circle, beam_color, 2)
            
            -- Show remaining duration
            local remains = FS.paladin_holy_herald.variables.suns_avatar_remains(unit) / 1000 -- Convert to seconds
            local text_pos = vec3.new(target_pos.x, target_pos.y, target_pos.z + 2.5)
            local info_text = string.format("Sun's Avatar: %.1fs", remains)
            FS.api.graphics:draw_text(text_pos, info_text, beam_color)
        end
    end
    
    -- Draw connections between Sun's Avatar targets for beam intersections
    for i = 1, #suns_avatar_targets do
        for j = i + 1, #suns_avatar_targets do
            local unit1 = suns_avatar_targets[i]
            local unit2 = suns_avatar_targets[j]
            
            local pos1 = unit1:get_position()
            local pos2 = unit2:get_position()
            
            if pos1 and pos2 then
                -- Calculate distance to determine if beams could intersect
                local distance = pos1:dist_to(pos2)
                local max_connection_distance = 30 -- Maximum distance for beam connections
                
                if distance <= max_connection_distance then
                    -- Draw connection line between targets
                    local connection_color = {r = 255, g = 180, b = 0, a = 150}  -- More transparent gold
                    FS.api.graphics:draw_line(pos1, pos2, connection_color, 1)
                    
                    -- Calculate midpoint for potential intersection visualization
                    local midpoint = vec3.new(
                        (pos1.x + pos2.x) / 2,
                        (pos1.y + pos2.y) / 2,
                        (pos1.z + pos2.z) / 2
                    )
                    
                    -- Draw intersection indicator
                    local intersection_color = {r = 255, g = 100, b = 0, a = 200}  -- Orange for intersections
                    local intersection_radius = 0.5
                    local circle = FS.api.geometry:create_circle(midpoint, intersection_radius)
                    FS.api.graphics:draw_circle(circle, intersection_color, 2)
                end
            end
        end
    end
end

-- Draw Dawnlight HoT indicators on targets
local function draw_dawnlight_hot_indicators()
    -- Get all targets with Dawnlight HoT
    local dawnlight_targets = FS.paladin_holy_herald.variables.dawnlight_targets()
    
    local vec3 = require("common/geometry/vector_3")
    
    for _, unit in ipairs(dawnlight_targets) do
        local target_pos = unit:get_position()
        if not target_pos then goto continue end
        
        local text_pos = vec3.new(target_pos.x, target_pos.y, target_pos.z + 2)
        
        -- Get HoT remaining time
        local remains = FS.paladin_holy_herald.variables.dawnlight_remains(unit) / 1000 -- Convert to seconds
        local max_duration = 8 -- Standard HoT duration
        local percentage = remains / max_duration
        
        -- Create text with information about the HoT
        local hot_text = string.format("Dawnlight: %.1fs", remains)
        
        -- Color coding based on remaining time
        local alpha = 255
        local r, g, b = 220, 180, 0  -- Default gold color
        
        if remains < 3 then
            -- About to expire - make it pulsate
            alpha = 150 + 105 * math.sin(core.time() / 200) -- Pulsing effect
            r, g, b = 255, 100, 0  -- Orange-red for expiring
        end
        
        local hot_color = {r = r, g = g, b = b, a = alpha}
        FS.api.graphics:draw_text(text_pos, hot_text, hot_color)
        
        -- Draw a small sun icon
        local icon_pos = vec3.new(target_pos.x - 1.5, target_pos.y, target_pos.z + 2)
        local circle = FS.api.geometry:create_circle(icon_pos, 0.2)
        FS.api.graphics:draw_circle(circle, hot_color, 2)
        
        -- Draw duration bar below target
        local bar_width = 2.0
        local bar_pos = vec3.new(target_pos.x, target_pos.y, target_pos.z - 0.2)
        
        -- Background bar
        local bg_start = vec3.new(bar_pos.x - bar_width/2, bar_pos.y, bar_pos.z)
        local bg_end = vec3.new(bar_pos.x + bar_width/2, bar_pos.y, bar_pos.z)
        local bg_color = {r = 50, g = 50, b = 50, a = 100}
        FS.api.graphics:draw_line(bg_start, bg_end, bg_color, 5)
        
        -- Foreground bar (remaining duration)
        local fg_width = bar_width * percentage
        local fg_start = vec3.new(bar_pos.x - bar_width/2, bar_pos.y, bar_pos.z)
        local fg_end = vec3.new(fg_start.x + fg_width, bar_pos.y, bar_pos.z)
        FS.api.graphics:draw_line(fg_start, fg_end, hot_color, 5)
        
        ::continue::
    end
end

-- Draw Eternal Flame HoT indicators on targets
local function draw_eternal_flame_hot_indicators()
    -- Only continue if talent is learned and feature is enabled
    if not (FS.paladin_holy_herald.talents.eternal_flame and 
            FS.paladin_holy_herald.settings.use_eternal_flame()) then
        return
    end
    
    -- Get all targets with Eternal Flame
    local ef_targets = {}
    for _, unit in ipairs(FS.modules.heal_engine.units) do
        if FS.paladin_holy_herald.variables.eternal_flame_up(unit) then
            table.insert(ef_targets, unit)
        end
    end
    
    if #ef_targets == 0 then
        return
    end
    
    local vec3 = require("common/geometry/vector_3")
    
    -- Process each target
    for _, unit in ipairs(ef_targets) do
        local target_pos = unit:get_position()
        if not target_pos then goto continue end
        
        -- Position this indicator lower than Dawnlight to avoid overlap
        local vertical_offset = 1.5
        
        -- Get HoT remaining time
        local remains = FS.paladin_holy_herald.variables.eternal_flame_remains(unit) / 1000 -- Convert to seconds
        local max_duration = FS.paladin_holy_herald.variables.eternal_flame_duration
        local percentage = remains / max_duration
        
        -- Create text for the HoT
        local hot_text = string.format("Eternal Flame: %.1fs", remains)
        local text_pos = vec3.new(target_pos.x, target_pos.y, target_pos.z + vertical_offset)
        
        -- Color coding based on remaining time
        local alpha = 255
        local r, g, b = 255, 140, 0  -- Default orange color for Eternal Flame
        
        if remains < 4 then
            -- About to expire - make it pulsate
            alpha = 150 + 105 * math.sin(core.time() / 200) -- Pulsing effect
            r, g, b = 255, 70, 0  -- More reddish for expiring
        end
        
        local hot_color = {r = r, g = g, b = b, a = alpha}
        FS.api.graphics:draw_text(text_pos, hot_text, hot_color)
        
        -- Draw a flame icon
        local icon_pos = vec3.new(target_pos.x - 1.7, target_pos.y, target_pos.z + vertical_offset - 0.3)
        local icon_size = 0.18
        
        -- Create a simple flame shape using triangular geometry
        local flame_height = icon_size * 1.5
        local flame_base = vec3.new(icon_pos.x, icon_pos.y, icon_pos.z)
        local flame_top = vec3.new(icon_pos.x, icon_pos.y, icon_pos.z + flame_height)
        local flame_left = vec3.new(icon_pos.x - icon_size/2, icon_pos.y, icon_pos.z)
        local flame_right = vec3.new(icon_pos.x + icon_size/2, icon_pos.y, icon_pos.z)
        
        -- Draw the flame shape
        FS.api.graphics:draw_line(flame_left, flame_top, hot_color, 1.5)
        FS.api.graphics:draw_line(flame_right, flame_top, hot_color, 1.5)
        FS.api.graphics:draw_line(flame_base, flame_top, hot_color, 1.5)
        
        -- Draw duration bar below target, offset from Dawnlight bar if present
        local ef_offset = FS.paladin_holy_herald.variables.dawnlight_up(unit) and -0.35 or -0.2
        local bar_width = 2.0
        local bar_pos = vec3.new(target_pos.x, target_pos.y, target_pos.z + ef_offset)
        
        -- Background bar
        local bg_start = vec3.new(bar_pos.x - bar_width/2, bar_pos.y, bar_pos.z)
        local bg_end = vec3.new(bar_pos.x + bar_width/2, bar_pos.y, bar_pos.z)
        local bg_color = {r = 50, g = 50, b = 50, a = 100}
        FS.api.graphics:draw_line(bg_start, bg_end, bg_color, 4)
        
        -- Foreground bar (remaining duration)
        local fg_width = bar_width * percentage
        local fg_start = vec3.new(bar_pos.x - bar_width/2, bar_pos.y, bar_pos.z)
        local fg_end = vec3.new(fg_start.x + fg_width, bar_pos.y, bar_pos.z)
        FS.api.graphics:draw_line(fg_start, fg_end, hot_color, 4)
        
        ::continue::
    end
end

-- Draw Empyrean Legacy proc visualization
local function draw_empyrean_legacy_indicator()
    if not FS.paladin_holy_herald.variables.empyrean_legacy_up() then
        return
    end
    
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    local text_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + 5)  -- Position above other indicators
    
    local remains = FS.paladin_holy_herald.variables.empyrean_legacy_remains() / 1000 -- Convert to seconds
    
    -- Make text pulse as proc duration gets lower
    local pulse_intensity = 1.0
    if remains < 5 then
        pulse_intensity = 0.7 + 0.3 * math.sin(core.time() / 150) -- Faster pulsing when about to expire
    end
    
    -- Create text with proc information
    local legacy_text = string.format("Empyrean Legacy Ready! (%.1fs)", remains)
    
    -- Bright divine color for the proc
    local legacy_color = {r = 255 * pulse_intensity, g = 215 * pulse_intensity, b = 100 * pulse_intensity, a = 255}
    FS.api.graphics:draw_text(text_pos, legacy_text, legacy_color)
    
    -- Draw flashy indicator around player
    local circle_radius = 1.2 + 0.2 * math.sin(core.time() / 200)  -- Pulsating circle
    local ground_circle = FS.api.geometry:create_circle(player_pos, circle_radius)
    local circle_color = {r = 255, g = 215, b = 100, a = 120 + 30 * math.sin(core.time() / 150)}
    FS.api.graphics:draw_circle(ground_circle, circle_color, 2)
    
    -- Add usage suggestion if appropriate
    if FS.paladin_holy_herald.variables.should_use_empyrean_legacy() then
        local advice_pos = vec3.new(player_pos.x, player_pos.y, player_pos.z + 4.7)
        local advice_text = "Use Now!"
        local advice_color = {r = 255, g = 50, b = 50, a = 255}  -- Red for urgency
        FS.api.graphics:draw_text(advice_pos, advice_text, advice_color)
    end
end

-- Draw cooldown tracking UI elements
local function draw_cooldown_trackers()
    local player_unit = FS.variables.me
    local player_pos = player_unit:get_position()
    if not player_pos then return end
    
    local vec3 = require("common/geometry/vector_3")
    local cooldowns = FS.paladin_holy_herald.variables.get_all_tracked_cooldowns()
    
    -- Position information
    local start_x = player_pos.x + 4  -- Offset to the right of player
    local start_y = player_pos.y
    local start_z = player_pos.z + 1  -- Slightly above ground
    local vertical_spacing = 0.4      -- Space between cooldown entries
    
    -- Draw background panel
    local num_cooldowns = 0
    for _ in pairs(cooldowns) do num_cooldowns = num_cooldowns + 1 end
    
    local panel_height = num_cooldowns * vertical_spacing + 0.5
    local panel_width = 4
    local panel_pos = vec3.new(start_x + panel_width/2, start_y, start_z + panel_height/2)
    
    -- Draw panel background
    local panel_color = {r = 0, g = 0, b = 0, a = 100}
    -- (No direct way to draw panel, so we'll skip this for now)
    
    -- Draw header
    local header_pos = vec3.new(start_x + panel_width/2, start_y, start_z + panel_height + 0.2)
    local header_text = "Cooldowns"
    local header_color = {r = 255, g = 255, b = 255, a = 200}
    FS.api.graphics:draw_text(header_pos, header_text, header_color)
    
    -- Draw individual cooldown entries
    local current_z = start_z + panel_height - 0.3
    
    for name, cd_info in pairs(cooldowns) do
        -- Skip if the spell is ready and has full charges
        if cd_info.is_ready and cd_info.charges >= cd_info.max_charges then
            goto continue
        end
        
        local cd_pos = vec3.new(start_x + 0.1, start_y, current_z)
        
        -- Create cooldown text
        local cd_text
        if cd_info.max_charges > 1 then
            cd_text = string.format("%s: %d/%d", cd_info.name, cd_info.charges, cd_info.max_charges)
            if not cd_info.is_ready then
                cd_text = cd_text .. string.format(" (%.1fs)", cd_info.remaining)
            end
        else
            if cd_info.is_ready then
                cd_text = string.format("%s: Ready", cd_info.name)
            else
                cd_text = string.format("%s: %.1fs", cd_info.name, cd_info.remaining)
            end
        end
        
        -- Determine color based on status
        local cd_color
        if cd_info.is_ready then
            cd_color = {r = 0, g = 255, b = 0, a = 255}  -- Green for ready
        else
            -- Transition from red to yellow to green as cooldown gets closer to ready
            local progress = 1 - (cd_info.remaining / cd_info.base_cooldown)
            cd_color = {
                r = 255 * (1 - progress),
                g = 255 * progress,
                b = 0,
                a = 255
            }
        end
        
        -- Draw the cooldown text
        FS.api.graphics:draw_text(cd_pos, cd_text, cd_color)
        
        -- Draw cooldown progress bar
        local bar_width = panel_width - 0.5
        local bar_pos = vec3.new(start_x + 0.1, start_y, current_z - 0.15)
        
        -- Background bar
        local bg_start = vec3.new(bar_pos.x, bar_pos.y, bar_pos.z)
        local bg_end = vec3.new(bar_pos.x + bar_width, bar_pos.y, bar_pos.z)
        local bg_color = {r = 80, g = 80, b = 80, a = 150}
        FS.api.graphics:draw_line(bg_start, bg_end, bg_color, 3)
        
        -- Progress bar
        if not cd_info.is_ready then
            local progress = 1 - (cd_info.remaining / cd_info.base_cooldown)
            local fg_width = bar_width * progress
            local fg_start = vec3.new(bar_pos.x, bar_pos.y, bar_pos.z)
            local fg_end = vec3.new(bar_pos.x + fg_width, bar_pos.y, bar_pos.z)
            FS.api.graphics:draw_line(fg_start, fg_end, cd_color, 3)
        end
        
        -- Move to next cooldown position
        current_z = current_z - vertical_spacing
        
        ::continue::
    end
end

---@type on_render
-- Draw a "Dawnlight Ready" indicator when Holy Prism has been used
local function draw_dawnlight_ready_indicator()
    -- Only show if we're in the post-Holy Prism state
    if not FS.paladin_holy_herald.variables.post_holy_prism_state() then
        return
    end
    
    -- Position in the UI panel
    local vec3 = require("common/geometry/vector_3")
    local screen_width = FS.api.graphics:get_screen_width()
    local screen_height = FS.api.graphics:get_screen_height()
    
    local pos_x = screen_width * 0.8
    local pos_y = screen_height * 0.3
    
    -- Create pulsing effect
    local pulse_factor = 0.7 + 0.3 * math.sin(core.time() / 200)
    local alpha = 180 + 75 * pulse_factor
    
    -- Draw the indicator
    local text = "DAWNLIGHT READY (" .. FS.paladin_holy_herald.variables.get_remaining_dawnlight_spenders() .. ")"
    local color = {r = 255, g = 215, b = 0, a = alpha}
    
    FS.api.graphics:draw_text_2d(pos_x, pos_y, text, color, "center", 16)
    
    -- Draw small sun icon
    local icon_size = 12
    local icon_x = pos_x - (FS.api.graphics:get_text_width(text, 16) / 2) - icon_size - 5
    local icon_y = pos_y + (icon_size / 2)
    
    FS.api.graphics:draw_circle_2d(icon_x, icon_y, icon_size / 2, color)
    
    -- Draw rays around the circle
    local ray_count = 8
    local ray_length = icon_size * 0.4
    
    for i = 1, ray_count do
        local angle = (i - 1) * (2 * math.pi / ray_count)
        local ray_start_x = icon_x + (icon_size / 2) * math.cos(angle)
        local ray_start_y = icon_y + (icon_size / 2) * math.sin(angle)
        local ray_end_x = icon_x + (icon_size / 2 + ray_length) * math.cos(angle)
        local ray_end_y = icon_y + (icon_size / 2 + ray_length) * math.sin(angle)
        
        FS.api.graphics:draw_line_2d(ray_start_x, ray_start_y, ray_end_x, ray_end_y, color, 1.5)
    end
end

function FS.paladin_holy_herald.drawing.on_render()
    -- Draw Awakening stack indicator if enabled
    if FS.paladin_holy_herald.settings.show_awakening_tracker() then
        draw_awakening_indicator()
    end
    
    -- Draw buff trackers if enabled
    if FS.paladin_holy_herald.settings.show_buff_trackers() then
        draw_gleaming_rays_indicator()
        draw_solar_grace_indicator()
        draw_rising_sunlight_indicator()
        draw_holy_power_warning()
    end
    
    -- Draw Dawnlight Ready indicator if in post-Holy Prism state
    if FS.paladin_holy_herald.settings.show_dawnlight_indicators() and
       FS.paladin_holy_herald.variables.should_prioritize_dawnlight() then
        draw_dawnlight_ready_indicator()
    end
    
    -- Draw Empyrean Legacy indicator if enabled
    if FS.paladin_holy_herald.settings.show_empyrean_legacy_indicator() then
        draw_empyrean_legacy_indicator()
    end
    
    -- Draw cooldown trackers if enabled
    if FS.paladin_holy_herald.settings.show_cooldown_trackers() then
        draw_cooldown_trackers()
    end
    
    -- Draw Sun's Avatar beams if enabled
    if FS.paladin_holy_herald.settings.show_suns_avatar_beams() then
        draw_suns_avatar_connections()
    end
    
    -- Draw Dawnlight HoT indicators if enabled
    if FS.paladin_holy_herald.settings.show_dawnlight_indicators() then
        draw_dawnlight_hot_indicators()
    end
    
    -- Draw Eternal Flame HoT indicators if enabled and talent is learned
    if FS.paladin_holy_herald.settings.show_dawnlight_indicators() and 
       FS.paladin_holy_herald.settings.use_eternal_flame() and
       FS.paladin_holy_herald.talents.eternal_flame then
        draw_eternal_flame_hot_indicators()
    end
    
    -- Draw Dawnlight status indicators if enabled in settings
    if FS.paladin_holy_herald.settings.optimize_beams() and FS.paladin_holy_herald.variables.avenging_wrath_up() then
        local player_unit = FS.variables.me
        local player_pos = player_unit:get_position()
        
        if not player_pos then return end
        
        -- Find all targets with Dawnlight buff using our helper function
        local dawnlight_targets = FS.paladin_holy_herald.variables.dawnlight_targets()
        local beams = {}
        
        -- Process each target with Dawnlight
        for _, unit in ipairs(dawnlight_targets) do
            local target_pos = unit:get_position()
            if target_pos then
                -- Store beam data for intersection calculation
                table.insert(beams, {
                    from_pos = player_pos,
                    to_pos = target_pos,
                    unit = unit
                })
                
                -- Draw beam line to this target
                local beam_color = {r = 255, g = 200, b = 0, a = 200}  -- Gold color for beams
                draw_beam_line(player_unit, unit, beam_color, 2)
            end
        end
        
        -- Calculate and draw beam intersections
        local intersections = calculate_beam_intersections(beams)
        local intersection_color = {r = 255, g = 100, b = 0, a = 255}  -- Orange for intersections
        
        for _, intersection in ipairs(intersections) do
            -- Draw a sphere at each intersection point
            FS.api.graphics:draw_sphere(intersection, 1, intersection_color)
        end
        
        -- Use the stored optimal position or calculate it now
        local optimal_position = FS.paladin_holy_herald.variables.optimal_beam_position
        if not optimal_position and #dawnlight_targets >= 3 then
            optimal_position = calculate_optimal_position(dawnlight_targets)
            FS.paladin_holy_herald.variables.optimal_beam_position = optimal_position
        end
        
        if optimal_position then
            local indicator_color = {r = 0, g = 255, b = 100, a = 180}  -- Green for optimal position
            draw_radius_indicator(optimal_position, 3, indicator_color)
            
            -- Draw line from current position to optimal position
            local guidance_color = {r = 0, g = 200, b = 255, a = 150}  -- Blue for guidance line
            FS.api.graphics:draw_line(player_pos, optimal_position, guidance_color, 1)
            
            -- Calculate distance to optimal position
            local vec3 = require("common/geometry/vector_3")
            local player_vec3 = vec3.new(player_pos.x, player_pos.y, player_pos.z)
            local optimal_vec3 = vec3.new(optimal_position.x, optimal_position.y, optimal_position.z)
            local distance = player_vec3:distance(optimal_vec3)
            
            -- Add distance information to the text
            local distance_text = string.format("Distance to optimal: %.1f yards", distance)
            FS.api.graphics:draw_text(
                vec3.new(player_pos.x, player_pos.y, player_pos.z + 3), 
                distance_text,
                {r = 0, g = 200, b = 255, a = 255}
            )
        end
        
        -- Draw current beam effectiveness indicator
        local beam_count = #dawnlight_targets
        local intersection_count = #intersections
        local effectiveness_text = string.format("Beams: %d | Intersections: %d", beam_count, intersection_count)
        FS.api.graphics:draw_text(
            vec3.new(player_pos.x, player_pos.y, player_pos.z + 2),
            effectiveness_text,
            {r = 255, g = 255, b = 255, a = 255}
        )
    end
end
