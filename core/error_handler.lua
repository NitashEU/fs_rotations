---@class error_instance
---@field message string Error message
---@field stack string Stack trace
---@field timestamp number When the error occurred
---@field game_state table|nil Captured game state at error time

---@class error_data
---@field instances error_instance[] List of error instances
---@field component string Component that generated the error
---@field disabled_until number Timestamp until which the component is disabled
---@field last_reported number When the error was last reported to the user

-- Error handling system for FS Rotations
-- Tracks errors and provides recovery mechanisms with progressive backoff
FS.error_handler = {
    ---@type table<string, error_data>
    errors = {},
    
    -- Configuration
    max_errors = FS.config:get("core.error_handler.max_errors", 5),  -- Maximum errors before disabling
    base_cooldown = FS.config:get("core.error_handler.base_cooldown", 10), -- Base seconds to disable
    max_cooldown = FS.config:get("core.error_handler.max_cooldown", 300), -- Maximum cooldown in seconds
    error_window = FS.config:get("core.error_handler.error_window", 300), -- Time window for counting errors
    max_stored_instances = FS.config:get("core.error_handler.max_stored_instances", 50), -- Max stored instances per component
    capture_state = FS.config:get("core.error_handler.capture_state", true), -- Whether to capture game state on error
    disabled_components = {}, -- Cache of currently disabled components
    
    ---Record an error and determine if component should be disabled
    ---@param component string Name of the component (module/function)
    ---@param error_msg string Error message
    ---@param stack_level number|nil Stack level for trace capture (default: 3)
    ---@return boolean If false, component should be temporarily disabled
    record = function(self, component, error_msg, stack_level)
        local current_time = core.game_time() / 1000 -- convert to seconds
        stack_level = stack_level or 3
        
        -- Initialize error data if it doesn't exist
        self.errors[component] = self.errors[component] or {
            instances = {},
            component = component,
            disabled_until = 0,
            last_reported = 0
        }
        
        local error_data = self.errors[component]
        
        -- Create new error instance
        local error_instance = {
            message = error_msg,
            stack = debug.traceback("", stack_level),
            timestamp = current_time,
            game_state = self:capture_game_state_if_enabled()
        }
        
        -- Add to instances list
        table.insert(error_data.instances, 1, error_instance) -- Add at beginning for newest first
        
        -- Trim if too many instances
        if #error_data.instances > self.max_stored_instances then
            table.remove(error_data.instances)
        end
        
        -- Log the error
        core.log_error("Error in " .. component .. ": " .. error_msg)
        
        -- Calculate number of errors in the window
        local error_count = 0
        for _, instance in ipairs(error_data.instances) do
            if current_time - instance.timestamp <= self.error_window then
                error_count = error_count + 1
            end
        end
        
        -- Disable problematic component if error threshold reached
        if error_count >= self.max_errors then
            local cooldown = self:calculate_cooldown(error_count)
            error_data.disabled_until = current_time + cooldown
            
            -- Update disabled components cache
            self.disabled_components[component] = error_data.disabled_until
            
            core.log_warning("Temporarily disabled " .. component .. " for " .. 
                             cooldown .. " seconds due to repeated errors")
                             
            return false -- should disable
        end
        
        return true -- can continue
    end,
    
    ---Check if component is allowed to run
    ---@param component string Name of the component
    ---@return boolean True if allowed to run
    can_run = function(self, component)
        local current_time = core.game_time() / 1000
        
        -- Quick check using cached disabled components
        if self.disabled_components[component] and self.disabled_components[component] > current_time then
            return false
        end
        
        -- Check if this specific component is disabled
        if self.errors[component] and self.errors[component].disabled_until > current_time then
            return false
        end
        
        -- Also check if parent components are disabled
        -- For example, if "module.submodule" is disabled, "module.submodule.function" should also be disabled
        for error_component, error_data in pairs(self.errors) do
            if component:find(error_component .. ".", 1, true) == 1 and error_data.disabled_until > current_time then
                -- Cache this result
                self.disabled_components[component] = error_data.disabled_until
                return false
            end
        end
        
        -- Clean up disabled components cache occasionally
        if math.random() < 0.01 then -- 1% chance on each check
            self:cleanup_disabled_cache()
        end
        
        return true
    end,
    
    ---Calculate cooldown period with exponential backoff
    ---@param error_count number Number of errors in the window
    ---@return number Cooldown period in seconds
    calculate_cooldown = function(self, error_count)
        -- Calculate exponential backoff: base_cooldown * 2^(error_count - max_errors)
        -- This gives longer cooldowns for more frequent errors
        local excess_errors = math.max(0, error_count - self.max_errors)
        local cooldown = self.base_cooldown * math.pow(2, excess_errors)
        
        -- Cap at maximum cooldown
        return math.min(cooldown, self.max_cooldown)
    end,
    
    ---Capture game state for debugging if enabled
    ---@return table|nil Game state data or nil if disabled
    capture_game_state_if_enabled = function(self)
        if not self.capture_state then
            return nil
        end
        
        -- Capture minimal game state that's useful for debugging
        local state = {}
        
        -- Safe player capture
        pcall(function()
            local player = core.object_manager.get_local_player()
            if player then
                state.player = {
                    name = player.name,
                    class = player.class,
                    health_percent = player.health_percentage
                }
            end
        end)
        
        -- Safe target capture
        pcall(function()
            local target = core.object_manager.get_target()
            if target then
                state.target = {
                    name = target.name,
                    guid = target.guid,
                    health_percent = target.health_percentage
                }
            end
        end)
        
        -- Combat state
        pcall(function()
            state.in_combat = core.object_manager.is_in_combat()
        end)
        
        return state
    end,
    
    ---Clean up disabled components cache
    cleanup_disabled_cache = function(self)
        local current_time = core.game_time() / 1000
        for component, disabled_until in pairs(self.disabled_components) do
            if disabled_until <= current_time then
                self.disabled_components[component] = nil
            end
        end
    end,
    
    ---Get active errors for UI display
    ---@param max_count number|nil Maximum number of errors to return
    ---@return table[] List of errors for display
    get_errors_for_display = function(self, max_count)
        max_count = max_count or 10
        local current_time = core.game_time() / 1000
        local result = {}
        
        for component, error_data in pairs(self.errors) do
            if #error_data.instances > 0 then
                local latest = error_data.instances[1] -- Newest first
                local status = "Active"
                if error_data.disabled_until > current_time then
                    local remaining = math.floor(error_data.disabled_until - current_time)
                    status = "Disabled (" .. remaining .. "s)"
                end
                
                table.insert(result, {
                    component = component,
                    message = latest.message,
                    count = #error_data.instances,
                    timestamp = latest.timestamp,
                    status = status,
                    data = error_data -- Reference to full data for detailed view
                })
            end
        end
        
        -- Sort by newest first
        table.sort(result, function(a, b)
            return a.timestamp > b.timestamp
        end)
        
        -- Limit to max_count
        if #result > max_count then
            local tmp = {}
            for i = 1, max_count do
                tmp[i] = result[i]
            end
            result = tmp
        end
        
        return result
    end,
    
    ---Mark an error as reported to the user
    ---@param component string Component name
    mark_reported = function(self, component)
        if self.errors[component] then
            self.errors[component].last_reported = core.game_time() / 1000
        end
    end,
    
    ---Get detailed error information for a component
    ---@param component string Component name
    ---@return error_data|nil Error data or nil if not found
    get_error_details = function(self, component)
        return self.errors[component]
    end,
    
    ---Reset error counts for testing/debugging
    reset = function(self)
        self.errors = {}
        self.disabled_components = {}
    end,
    
    ---Safe execute function with error handling
    ---@param func function Function to execute
    ---@param component string Component name for error reporting
    ---@param ... any Arguments to pass to the function
    ---@return boolean success Whether the function executed successfully
    ---@return any result The result from the function if successful
    safe_execute = function(self, func, component, ...)
        -- Check if component is allowed to run
        if not self:can_run(component) then
            return false, nil
        end
        
        -- Execute with error handling
        local success, result = pcall(func, ...)
        if not success then
            -- Record error with correct stack level (2 to skip this function)
            self:record(component, result, 2)
            return false, nil
        end
        
        return true, result
    end
}