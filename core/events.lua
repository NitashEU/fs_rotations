-- Event System for FS Rotations
-- Implements a publish/subscribe pattern for decoupled component communication
-- Provides event registration, subscription, and debugging capabilities
--
-- DEPRECATION NOTICE:
-- This event-based communication system is DEPRECATED for class rotations.
-- All modules should use direct function calls instead of events for class rotations.
-- This provides more explicit and maintainable communication between components.

---@class EventListener
---@field id string Unique identifier for this listener
---@field callback function Function to call when event is triggered
---@field once boolean Whether this listener should be removed after first trigger
---@field priority number Priority of this listener (higher executes first)

---@class EventData
---@field name string Name of the event
---@field source string|nil Source component that triggered the event
---@field timestamp number When the event was triggered
---@field data any Event-specific data

---@class EventSystem
FS.events = {
  -- Registry of all event listeners grouped by event name
  ---@type table<string, EventListener[]>
  listeners = {},
  
  -- Configuration
  debug_enabled = FS.config:get("core.events.debug_enabled", false),
  debug_log_limit = FS.config:get("core.events.debug_log_limit", 100),
  
  -- Debug history for event tracing
  ---@type EventData[]
  debug_history = {},
  
  -- Generate a unique ID for a listener
  ---@return string
  generate_id = function(self)
    return tostring(math.floor(core.game_time())) .. "_" .. tostring(math.random(1000000))
  end,
  
  -- Register a listener for an event
  ---@param event_name string Name of the event to listen for
  ---@param callback function Function to call when event is triggered
  ---@param options? {id?: string, once?: boolean, priority?: number} Optional configuration
  ---@return string listener_id Unique ID for this listener (use to unregister)
  -- DEPRECATED: For class rotations, use direct function calls instead of event listeners
  on = function(self, event_name, callback, options)
    -- Parameter validation
    if not FS.validator.check_string(event_name, "event_name", "events.on") then
      return self:generate_id() -- Return dummy ID on error
    end
    
    if not FS.validator.check_function(callback, "callback", "events.on") then
      return self:generate_id() -- Return dummy ID on error
    end
    
    -- Initialize options
    options = options or {}
    local listener_id = options.id or self:generate_id()
    
    -- Initialize event group if it doesn't exist
    self.listeners[event_name] = self.listeners[event_name] or {}
    
    -- Create listener entry
    local listener = {
      id = listener_id,
      callback = callback,
      once = options.once or false,
      priority = options.priority or 0,
    }
    
    -- Add to listener array
    table.insert(self.listeners[event_name], listener)
    
    -- Sort by priority (higher first)
    table.sort(self.listeners[event_name], function(a, b)
      return a.priority > b.priority
    end)
    
    -- Return ID for unsubscribing
    return listener_id
  end,
  
  -- Register a one-time listener for an event
  ---@param event_name string Name of the event to listen for
  ---@param callback function Function to call when event is triggered
  ---@param options? {id?: string, priority?: number} Optional configuration
  ---@return string listener_id Unique ID for this listener
  once = function(self, event_name, callback, options)
    options = options or {}
    options.once = true
    return self:on(event_name, callback, options)
  end,
  
  -- Remove a listener by ID
  ---@param event_name string Name of the event
  ---@param listener_id string ID of the listener to remove
  ---@return boolean success Whether the listener was found and removed
  off = function(self, event_name, listener_id)
    -- Check if event group exists
    if not self.listeners[event_name] then
      return false
    end
    
    -- Find and remove the listener
    for i, listener in ipairs(self.listeners[event_name]) do
      if listener.id == listener_id then
        table.remove(self.listeners[event_name], i)
        return true
      end
    end
    
    return false
  end,
  
  -- Remove all listeners for an event
  ---@param event_name string Name of the event to clear
  off_all = function(self, event_name)
    self.listeners[event_name] = {}
  end,
  
  -- Emit an event to all registered listeners
  ---@param event_name string Name of the event to trigger
  ---@param data any Data to pass to listeners
  ---@param source? string Source component that triggered the event
  -- DEPRECATED: For class rotations, use direct function calls instead of event emission
  emit = function(self, event_name, data, source)
    -- Check for valid event name
    if type(event_name) ~= "string" then
      FS.error_handler:record("events.emit", "Invalid event name type: " .. type(event_name))
      return
    end
    
    -- Create event data
    local event_data = {
      name = event_name,
      source = source,
      timestamp = core.game_time() / 1000,
      data = data
    }
    
    -- Debug logging
    if self.debug_enabled then
      self:log_event(event_data)
    end
    
    -- Skip if no listeners
    if not self.listeners[event_name] then
      return
    end
    
    -- Create a copy of listeners array to allow modification during iteration
    local listeners_to_execute = {}
    local listeners_to_remove = {}
    
    -- Copy listeners and mark single-use ones for removal
    for i, listener in ipairs(self.listeners[event_name]) do
      table.insert(listeners_to_execute, listener)
      if listener.once then
        table.insert(listeners_to_remove, i)
      end
    end
    
    -- Execute listeners
    for _, listener in ipairs(listeners_to_execute) do
      -- Use safe_execute for error handling
      FS.error_handler:safe_execute(
        listener.callback,
        data,
        "events.listener." .. event_name
      )
    end
    
    -- Remove one-time listeners (in reverse order to maintain indices)
    for i = #listeners_to_remove, 1, -1 do
      table.remove(self.listeners[event_name], listeners_to_remove[i])
    end
  end,
  
  -- Emit an event that might be dispatched to a parent event as well
  ---@param event_name string Name of the event to trigger
  ---@param data any Data to pass to listeners
  ---@param source? string Source component that triggered the event
  -- DEPRECATED: For class rotations, use direct function calls instead of hierarchical events
  emit_hierarchical = function(self, event_name, data, source)
    -- Emit to specific handler
    self:emit(event_name, data, source)
    
    -- Emit to parent events (if any)
    local parent_event = event_name:match("^(.+)%.[^%.]+$")
    if parent_event then
      self:emit(parent_event, data, source)
    end
  end,
  
  -- Check if an event has any listeners
  ---@param event_name string Name of the event to check
  ---@return boolean has_listeners Whether the event has any listeners
  has_listeners = function(self, event_name)
    return self.listeners[event_name] ~= nil and #self.listeners[event_name] > 0
  end,
  
  -- Count listeners for a specific event
  ---@param event_name string Name of the event to count listeners for
  ---@return number count Number of registered listeners
  count_listeners = function(self, event_name)
    if not self.listeners[event_name] then
      return 0
    end
    return #self.listeners[event_name]
  end,
  
  -- Log an event to the debug history
  ---@param event_data EventData Event data to log
  log_event = function(self, event_data)
    -- Add to history
    table.insert(self.debug_history, 1, event_data)
    
    -- Trim if too large
    if #self.debug_history > self.debug_log_limit then
      table.remove(self.debug_history)
    end
  end,
  
  -- Enable event debugging
  enable_debug = function(self)
    self.debug_enabled = true
  end,
  
  -- Disable event debugging
  disable_debug = function(self)
    self.debug_enabled = false
  end,
  
  -- Clear debug history
  clear_debug_history = function(self)
    self.debug_history = {}
  end,
  
  -- Get debug history
  ---@return EventData[] history Array of recent events (newest first)
  get_debug_history = function(self)
    return self.debug_history
  end,
  
  -- Render debug information to the screen
  render_debug = function(self)
    if not self.debug_enabled then return end
    
    local event_counts = {}
    
    -- Count events by type
    for event_name, listeners in pairs(self.listeners) do
      event_counts[event_name] = #listeners
    end
    
    -- Render counts
    FS.api.gui.window("Event System Debug", 300, 400, function()
      FS.api.gui.text("Event Listeners:")
      FS.api.gui.separator()
      
      for event_name, count in pairs(event_counts) do
        FS.api.gui.text(event_name .. ": " .. count)
      end
      
      FS.api.gui.separator()
      FS.api.gui.text("Recent Events:")
      FS.api.gui.separator()
      
      -- Show most recent events first
      for i = 1, math.min(20, #self.debug_history) do
        local event = self.debug_history[i]
        local time_ago = math.floor(core.game_time() / 1000 - event.timestamp)
        FS.api.gui.text_colored(event.name, 1, 0.8, 0.2, 1)
        FS.api.gui.same_line()
        FS.api.gui.text(" (" .. time_ago .. "s ago)")
        
        if event.source then
          FS.api.gui.text("  Source: " .. event.source)
        end
      end
      
      FS.api.gui.separator()
      if FS.api.gui.button("Clear History") then
        self:clear_debug_history()
      end
      
      FS.api.gui.same_line()
      if FS.api.gui.button("Disable Debug") then
        self:disable_debug()
      end
    end)
  end
}

-- Return the module for proper loading
-- NOTE: This event system is being phased out for class rotations in favor of direct function calls.
-- If your module uses FS.events for class rotations, please refactor to use direct communication.
return FS.events
