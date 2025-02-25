-- Error handling system for FS Rotations
-- Tracks errors and provides recovery mechanisms

FS.error_handler = {
    errors = {},
    max_errors = FS.config:get("core.error_handler.max_errors", 5),  -- Maximum errors before disabling
    cooldown_period = FS.config:get("core.error_handler.cooldown_period", 60), -- Seconds to disable
    error_window = FS.config:get("core.error_handler.error_window", 300), -- Time window for counting errors
    
    -- Record an error and determine if component should be disabled
    -- @param component string Name of the component (module/function)
    -- @param error_msg string Error message
    -- @return boolean If false, component should be temporarily disabled
    record = function(self, component, error_msg)
        local current_time = core.game_time() / 1000 -- convert to seconds
        local key = component .. "_" .. error_msg
        
        self.errors[key] = self.errors[key] or {
            count = 0,
            first_seen = current_time,
            last_seen = current_time,
            disabled_until = 0
        }
        
        local error_data = self.errors[key]
        error_data.count = error_data.count + 1
        error_data.last_seen = current_time
        
        -- Log the error
        core.log_error("Error in " .. component .. ": " .. error_msg)
        
        -- Disable problematic component if error threshold reached
        if error_data.count >= self.max_errors and 
           current_time - error_data.first_seen <= self.error_window then
           
            error_data.disabled_until = current_time + self.cooldown_period
            core.log_warning("Temporarily disabled " .. component .. " due to repeated errors")
            return false -- should disable
        end
        
        return true -- can continue
    end,
    
    -- Check if component is allowed to run
    -- @param component string Name of the component
    -- @return boolean True if allowed to run
    can_run = function(self, component)
        local current_time = core.game_time() / 1000
        
        -- Check all errors related to this component
        for key, error_data in pairs(self.errors) do
            if key:find(component, 1, true) == 1 and
               error_data.disabled_until > current_time then
                return false
            end
        end
        
        return true
    end,
    
    -- Reset error counts for testing/debugging
    reset = function(self)
        self.errors = {}
    end
}