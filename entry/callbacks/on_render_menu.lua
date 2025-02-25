---@type color
local color = require("common/color")

---@alias on_render_menu fun()

---Safe execution wrapper for module menu rendering functions
---@param module table The module containing the function
---@param func_name string Name of the function to call
---@param module_name string Name of the module for error tracking
local function safe_render_menu(module, func_name, module_name)
    if not module[func_name] then return end
    
    -- Create component name
    local component = module_name .. "." .. func_name
    
    -- Use the enhanced safe_execute method in error_handler
    FS.error_handler:safe_execute(module[func_name], component)
end

---Safe function to render menu elements
---@param menu_element table The menu element to render
---@param label string The label for the menu element
---@param tooltip string|nil Optional tooltip
---@return boolean Whether the render was successful
local function safe_render_element(menu_element, label, tooltip)
    if not menu_element then return false end
    
    local component = "menu_element." .. label
    
    local render_func = function()
        if tooltip then
            menu_element:render(label, tooltip)
        else
            menu_element:render(label)
        end
        
        -- For buttons, return true if they were clicked
        if type(menu_element.was_clicked) == "function" and menu_element:was_clicked() then
            return true
        end
        return false -- Not clicked or not a button
    end
    
    local success, result = FS.error_handler:safe_execute(render_func, component)
    
    if not success then
        return false
    end
    
    return result or false -- Convert nil to false
end

---@type on_render_menu
function FS.entry_helper.on_render_menu()
    -- Wrap the entire menu rendering in a pcall
    local success, error_msg = pcall(function()
        FS.menu.main_tree:render("FS Rotations v" .. FS.version:toString(), function()
            -- Core settings section
            safe_render_element(FS.menu.enable_script_check, "Enable Script")
            if not FS.settings.is_enabled() then return end
            
            -- Humanizer section
            safe_render_element(FS.menu.humanizer, "Humanizer", color.white())
            safe_render_element(FS.menu.min_delay, "Min delay", "Min delay until next run.")
            safe_render_element(FS.menu.max_delay, "Max delay", "Max delay until next run.")
            
            -- Jitter settings
            safe_render_element(FS.menu.humanizer_jitter.enable_jitter, "Enable Jitter", 
                "Adds randomization to delays for more human-like behavior")
                
            if FS.settings.jitter.is_enabled() then
                safe_render_element(FS.menu.humanizer_jitter.base_jitter, "Base Jitter %",
                    "Base percentage of delay to use for randomization")
                safe_render_element(FS.menu.humanizer_jitter.latency_jitter, "Latency Jitter %",
                    "Additional jitter based on current latency")
                safe_render_element(FS.menu.humanizer_jitter.max_jitter, "Max Jitter %",
                    "Maximum total jitter percentage")
            end
            
            -- Enhanced error handler settings
            if FS.menu.error_handler then
                safe_render_element(FS.menu.error_handler.tree, "Error Handling", color.white())
                
                -- Only render error handling menu if the tree node is open
                if FS.menu.error_handler.tree:is_open() then
                    -- Basic settings section
                    core.menu.text("Settings"):render()
                    
                    safe_render_element(FS.menu.error_handler.show_errors, "Show Error Details", 
                        "Display detailed error information in the menu")
                    
                    safe_render_element(FS.menu.error_handler.show_stack_traces, "Show Stack Traces", 
                        "Show detailed stack traces for errors (can be verbose)")
                    
                    safe_render_element(FS.menu.error_handler.capture_state_checkbox, "Capture Game State", 
                        "Capture game state when errors occur (player, target, combat status)")
                    
                    safe_render_element(FS.menu.error_handler.max_errors_slider, "Max Errors Before Disabling", 
                        "Number of errors before temporarily disabling a component")
                    
                    safe_render_element(FS.menu.error_handler.base_cooldown_slider, "Base Disable Duration (seconds)", 
                        "Initial duration to disable a component after repeated errors")
                    
                    safe_render_element(FS.menu.error_handler.max_cooldown_slider, "Max Disable Duration (seconds)", 
                        "Maximum duration to disable a component with frequent errors")
                    
                    if safe_render_element(FS.menu.error_handler.clear_errors, "Clear All Errors") then
                        -- Button was clicked, clear error history
                        FS.error_handler:reset()
                        FS.menu.error_handler.selected_error = nil
                    end
                    
                    -- Display error list if enabled
                    if FS.menu.error_handler.show_errors:get_state() then
                        -- Get errors for display
                        local errors_for_display = FS.error_handler:get_errors_for_display()
                        local error_count = #errors_for_display
                        
                        -- Separator
                        core.menu.separator():render()
                        
                        -- Display error count with color-coded header
                        if error_count > 0 then
                            core.menu.text("Active Errors: " .. error_count):render(color.new(255, 100, 100, 255))
                        else
                            core.menu.text("No Active Errors"):render(color.new(100, 255, 100, 255))
                        end
                        
                        -- List errors
                        if error_count > 0 then
                            for i, error_info in ipairs(errors_for_display) do
                                -- Format time for display
                                local time_ago = math.floor(core.game_time() / 1000 - error_info.timestamp)
                                local time_text = time_ago <= 60 and time_ago .. "s ago" or 
                                                 math.floor(time_ago / 60) .. "m " .. (time_ago % 60) .. "s ago"
                                
                                -- Create error display text with color coding based on status
                                local error_text
                                local err_color
                                
                                if error_info.status:find("Disabled") then
                                    error_text = "⛔ " .. error_info.component .. " (" .. error_info.count .. ") - " .. time_text
                                    err_color = color.new(255, 80, 80, 255)
                                else
                                    error_text = "⚠️ " .. error_info.component .. " (" .. error_info.count .. ") - " .. time_text
                                    err_color = color.new(255, 180, 0, 255)
                                end
                                
                                -- Display the error with selection capability
                                local error_button = core.menu.button("error_" .. i)
                                error_button:render_as_selectable(error_text, err_color, FS.menu.error_handler.selected_error == error_info.component)
                                
                                -- Handle error selection for details view
                                if error_button:was_clicked() then
                                    if FS.menu.error_handler.selected_error == error_info.component then
                                        FS.menu.error_handler.selected_error = nil -- Deselect if already selected
                                    else
                                        FS.menu.error_handler.selected_error = error_info.component
                                        FS.error_handler:mark_reported(error_info.component)
                                    end
                                end
                            end
                            
                            -- Show details for selected error
                            if FS.menu.error_handler.selected_error then
                                local details = FS.error_handler:get_error_details(FS.menu.error_handler.selected_error)
                                
                                if details and #details.instances > 0 then
                                    -- Separator
                                    core.menu.separator():render()
                                    
                                    -- Display details header
                                    core.menu.text("Error Details: " .. FS.menu.error_handler.selected_error):render(color.new(255, 255, 100, 255))
                                    
                                    -- Display the latest error instance
                                    local latest = details.instances[1]
                                    
                                    -- Error message
                                    core.menu.text("Message: " .. latest.message):render()
                                    
                                    -- Timestamp
                                    local time_ago = math.floor(core.game_time() / 1000 - latest.timestamp)
                                    local time_text = time_ago <= 60 and time_ago .. " seconds ago" or 
                                                    math.floor(time_ago / 60) .. " minutes " .. (time_ago % 60) .. " seconds ago"
                                    core.menu.text("Time: " .. time_text):render()
                                    
                                    -- Stack trace if enabled
                                    if FS.menu.error_handler.show_stack_traces:get_state() and latest.stack then
                                        core.menu.text("Stack Trace:"):render()
                                        
                                        -- Process stack trace to remove the initial lines related to our error handling
                                        local stack_lines = {}
                                        for line in latest.stack:gmatch("([^\n]+)") do
                                            -- Skip internal error handler lines
                                            if not line:find("safe_execute") and not line:find("pcall") then
                                                table.insert(stack_lines, line)
                                            end
                                        end
                                        
                                        -- Display each line of the stack trace
                                        for _, line in ipairs(stack_lines) do
                                            core.menu.text("  " .. line):render()
                                        end
                                    end
                                    
                                    -- Game state if captured
                                    if latest.game_state then
                                        core.menu.text("Game State:"):render()
                                        
                                        if latest.game_state.player then
                                            core.menu.text("  Player: " .. latest.game_state.player.name .. 
                                                          " (" .. latest.game_state.player.class .. 
                                                          ", HP: " .. latest.game_state.player.health_percent .. "%)"):render()
                                        end
                                        
                                        if latest.game_state.target then
                                            core.menu.text("  Target: " .. latest.game_state.target.name .. 
                                                          " (HP: " .. latest.game_state.target.health_percent .. "%)"):render()
                                        else
                                            core.menu.text("  Target: None"):render()
                                        end
                                        
                                        core.menu.text("  In Combat: " .. (latest.game_state.in_combat and "Yes" or "No")):render()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Performance metrics menu
            if FS.menu.profiler then
                safe_render_element(FS.menu.profiler.tree, "Performance Metrics", color.white())
                
                -- Only render performance metrics menu if the tree node is open
                if FS.menu.profiler.tree:is_open() then
                    -- Basic settings section
                    core.menu.text("Settings"):render()
                    
                    -- Enable/disable profiling
                    if safe_render_element(FS.menu.profiler.enabled, "Enable Performance Metrics",
                        "Track and display performance metrics for functions and memory usage") then
                        FS.profiler.config.enabled = FS.menu.profiler.enabled:get_state()
                    end
                    
                    -- Show metrics option
                    safe_render_element(FS.menu.profiler.show_metrics, "Show Metrics", 
                        "Display detailed performance metrics in the menu")
                    
                    -- Add memory capture button
                    if safe_render_element(FS.menu.profiler.capture_memory, "Capture Memory Snapshot") then
                        FS.profiler:capture_memory_snapshot()
                    end
                    
                    -- Add clear metrics button
                    if safe_render_element(FS.menu.profiler.clear_metrics, "Clear All Metrics") then
                        FS.profiler:reset()
                        FS.menu.profiler.selected_metric = nil
                    end
                    
                    -- Configuration section
                    safe_render_element(FS.menu.profiler.config_tree, "Advanced Configuration")
                    if FS.menu.profiler.config_tree:is_open() then
                        -- Limit number of stored metrics
                        if safe_render_element(FS.menu.profiler.max_metrics, "Max Stored Metrics",
                            "Maximum number of metrics to keep in memory") then
                            FS.profiler.config.max_metrics = FS.menu.profiler.max_metrics:get()
                        end
                        
                        -- History size for charts
                        if safe_render_element(FS.menu.profiler.history_size, "History Size",
                            "Number of historical data points to keep for charts") then
                            FS.profiler.config.history_size = FS.menu.profiler.history_size:get()
                        end
                        
                        -- Warning threshold
                        if safe_render_element(FS.menu.profiler.warning_threshold, "Warning Threshold (ms)",
                            "Execution time above which to show warning indicators") then
                            FS.profiler.config.default_warning_threshold = FS.menu.profiler.warning_threshold:get()
                        end
                        
                        -- Alert threshold
                        if safe_render_element(FS.menu.profiler.alert_threshold, "Alert Threshold (ms)",
                            "Execution time above which to show alert indicators") then
                            FS.profiler.config.default_alert_threshold = FS.menu.profiler.alert_threshold:get()
                        end
                    end
                    
                    -- Display metrics if enabled
                    if FS.menu.profiler.show_metrics:get_state() and FS.profiler.config.enabled then
                        -- Separator
                        core.menu.separator():render()
                        
                        -- Setup combobox options for categories
                        local categories = { "All Categories" }
                        local category_map = { [0] = nil }  -- Index to category mapping
                        
                        -- Collect all unique categories
                        local category_set = {}
                        for _, metric in pairs(FS.profiler.metrics) do
                            if not category_set[metric.category] then
                                category_set[metric.category] = true
                                table.insert(categories, metric.category)
                                category_map[#categories - 1] = metric.category
                            end
                        end
                        
                        -- Update combobox options
                        FS.menu.profiler.category_filter:set_options(categories)
                        
                        -- Display filter options
                        core.menu.text("Filter & Sort"):render()
                        
                        -- Category filter
                        safe_render_element(FS.menu.profiler.category_filter, "Category")
                        
                        -- Sort options
                        FS.menu.profiler.sort_by:set_options({ "Total Time", "Count", "Average Time", "Max Time", "Last Time" })
                        safe_render_element(FS.menu.profiler.sort_by, "Sort By")
                        
                        -- Get selected category
                        local selected_category_idx = FS.menu.profiler.category_filter:get()
                        local selected_category = category_map[selected_category_idx]
                        
                        -- Get selected sort method
                        local sort_methods = { "total_time", "count", "avg_time", "max_time", "last_time" }
                        local selected_sort = sort_methods[FS.menu.profiler.sort_by:get() + 1] or "total_time"
                        
                        -- Get metrics for display
                        local metrics = FS.profiler:get_metrics_for_display(selected_category, selected_sort, 20)
                        
                        -- Separator before metrics
                        core.menu.separator():render()
                        
                        -- Check if we have any metrics to display
                        if #metrics == 0 then
                            core.menu.text("No metrics available"):render(color.new(180, 180, 180, 255))
                        else
                            -- Display memory usage first
                            local memory_stats = FS.profiler:get_memory_stats()
                            
                            -- Memory usage header with color based on trend
                            local mem_color = color.new(180, 180, 180, 255) -- Default grey
                            if memory_stats.change_rate > 1024 * 10 then -- 10 KB/s growth
                                mem_color = color.new(255, 100, 100, 255) -- Red for fast growth
                            elseif memory_stats.change_rate > 1024 then -- 1 KB/s growth
                                mem_color = color.new(255, 200, 0, 255) -- Orange for moderate growth
                            elseif memory_stats.change_rate < 0 then -- Shrinking
                                mem_color = color.new(100, 255, 100, 255) -- Green for shrinking
                            end
                            
                            core.menu.text(string.format("Memory Usage: %.2f MB", memory_stats.memory_mb)):render(mem_color)
                            
                            if memory_stats.change_rate ~= 0 then
                                local change_text = memory_stats.change_rate > 0 and "+" or ""
                                change_text = string.format("%s%.2f KB/s", change_text, memory_stats.change_rate / 1024)
                                core.menu.text("  Rate: " .. change_text):render(mem_color)
                            end
                            
                            -- Display metrics table header
                            core.menu.separator():render()
                            core.menu.text("Performance Metrics (Top 20)"):render(color.new(255, 255, 100, 255))
                            
                            -- Simple table header
                            local header_text = "Name                        Count      Avg (ms)    Max (ms)    Total (ms)"
                            core.menu.text(header_text):render()
                            
                            -- Render metrics rows
                            for i, metric in ipairs(metrics) do
                                -- Determine color based on avg time
                                local row_color
                                if metric.avg_time >= metric.alert_threshold then
                                    row_color = color.new(255, 80, 80, 255) -- Red for slow
                                elseif metric.avg_time >= metric.warning_threshold then
                                    row_color = color.new(255, 200, 0, 255) -- Orange for warning
                                else
                                    row_color = color.white -- Default
                                end
                                
                                -- Format name with category
                                local name = metric.category .. "." .. metric.name
                                if #name > 25 then
                                    name = name:sub(1, 22) .. "..."
                                else
                                    name = name .. string.rep(" ", 25 - #name)
                                end
                                
                                -- Format values
                                local count_str = string.format("%-10d", metric.count)
                                local avg_str = string.format("%-11.2f", metric.avg_time)
                                local max_str = string.format("%-11.2f", metric.max_time)
                                local total_str = string.format("%.2f", metric.total_time)
                                
                                -- Combine into row
                                local row_text = name .. count_str .. avg_str .. max_str .. total_str
                                
                                -- Create selectable button for the row
                                local metric_button = core.menu.button("metric_" .. i)
                                metric_button:render_as_selectable(row_text, row_color, 
                                    FS.menu.profiler.selected_metric == metric.key)
                                
                                -- Handle metric selection for details
                                if metric_button:was_clicked() then
                                    if FS.menu.profiler.selected_metric == metric.key then
                                        FS.menu.profiler.selected_metric = nil -- Deselect if already selected
                                    else
                                        FS.menu.profiler.selected_metric = metric.key
                                    end
                                end
                            end
                            
                            -- Show details for selected metric
                            if FS.menu.profiler.selected_metric then
                                local selected_key = FS.menu.profiler.selected_metric
                                local metric = FS.profiler.metrics[selected_key]
                                local history = FS.profiler.history[selected_key]
                                
                                if metric and history and #history > 0 then
                                    -- Separator
                                    core.menu.separator():render()
                                    
                                    -- Display details header
                                    core.menu.text("Metric Details: " .. selected_key):render(color.new(255, 255, 100, 255))
                                    
                                    -- Basic stats
                                    core.menu.text(string.format("  Calls: %d", metric.count)):render()
                                    core.menu.text(string.format("  Avg Time: %.2f ms", metric.count > 0 and metric.total_time / metric.count or 0)):render()
                                    core.menu.text(string.format("  Min Time: %.2f ms", metric.min_time)):render()
                                    core.menu.text(string.format("  Max Time: %.2f ms", metric.max_time)):render()
                                    core.menu.text(string.format("  Total Time: %.2f ms", metric.total_time)):render()
                                    
                                    -- Last execution
                                    local time_ago = (core.game_time() - metric.last_timestamp) / 1000
                                    if time_ago < 60 then
                                        core.menu.text(string.format("  Last Call: %.1f seconds ago (%.2f ms)", time_ago, metric.last_time)):render()
                                    else
                                        core.menu.text(string.format("  Last Call: %.1f minutes ago (%.2f ms)", time_ago / 60, metric.last_time)):render()
                                    end
                                    
                                    -- Display history graph if enabled and enough data points
                                    if FS.menu.profiler.show_charts:get_state() and #history >= 2 then
                                        -- Only display the most recent 30 points for clarity
                                        local display_points = math.min(30, #history)
                                        
                                        -- Get data for chart
                                        local values = {}
                                        for i = 1, display_points do
                                            table.insert(values, history[i])
                                        end
                                        
                                        -- Calculate min/max for y-axis
                                        local min_val = math.huge
                                        local max_val = 0
                                        for _, val in ipairs(values) do
                                            min_val = math.min(min_val, val)
                                            max_val = math.max(max_val, val)
                                        end
                                        
                                        -- Ensure reasonable min/max scale with padding
                                        min_val = math.max(0, min_val * 0.8)
                                        max_val = max_val * 1.2
                                        
                                        -- Show graph
                                        core.menu.text("  Execution Time History (ms)"):render()
                                        core.ui.plot_lines("##" .. selected_key, values, min_val, max_val)
                                    end
                                end
                            end
                            
                            -- Memory usage history chart if enabled
                            if FS.menu.profiler.show_charts:get_state() and #memory_stats.memory_history > 1 then
                                -- Separator
                                core.menu.separator():render()
                                
                                -- Header
                                core.menu.text("Memory Usage History (MB)"):render(mem_color)
                                
                                -- Calculate min/max for better scaling
                                local min_val = math.huge
                                local max_val = 0
                                for _, val in ipairs(memory_stats.memory_history) do
                                    min_val = math.min(min_val, val)
                                    max_val = math.max(max_val, val)
                                end
                                
                                -- Ensure reasonable min/max with padding
                                min_val = math.max(0, min_val * 0.95)
                                max_val = max_val * 1.05
                                
                                -- Show graph
                                core.ui.plot_lines("##memory_history", memory_stats.memory_history, min_val, max_val)
                            end
                        end
                    end
                end
            end
            
            -- Module menus
            for i, module in pairs(FS.loaded_modules) do
                safe_render_menu(module, "on_render_menu", "module_" .. i)
            end
            
            -- Spec menu
            if FS.spec_config then
                safe_render_menu(FS.spec_config, "on_render_menu", 
                                "spec_" .. (FS.spec_config.name or "unknown"))
            end
        end)
    end)
    
    if not success then
        -- Critical failure in menu rendering
        core.log_error("Critical menu rendering error: " .. error_msg)
        
        -- Fallback minimal menu to ensure user can still control the addon
        pcall(function()
            core.menu.tree_node():render("FS Rotations [ERROR MODE]", function()
                core.menu.checkbox("Enable", "Script is currently in error recovery mode"):render(true)
                core.menu.text("Error: " .. error_msg):render()
            end)
        end)
    end
end
