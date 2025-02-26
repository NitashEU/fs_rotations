-- Event System Debug UI
-- Provides visualization tools for event tracing and debugging

---@class EventsDebug
FS.events_debug = {
  -- Configuration
  show_debug_window = FS.config:get("core.events_debug.show_window", false),
  
  -- Initialize the debug module
  init = function(self)
    -- Create a setting to toggle debug window
    FS.settings_manager:register(
      "core", 
      "events_debug.show_window", 
      function() return self.show_debug_window end, 
      FS.settings_manager.TYPES.BOOLEAN,
      {}, -- No additional options
      false -- Default value
    )
    
    -- Register for settings changes
    FS.settings_manager:add_listener("core", "events_debug.show_window", function(value)
      self.show_debug_window = value
      
      -- Enable/disable event debugging based on setting
      if value then
        FS.events:enable_debug()
      else
        FS.events:disable_debug()
      end
    end)
    
    -- Register common event types for quick testing
    self:register_test_events()
  end,
  
  -- Update function called on render
  on_render = function(self)
    -- Conditionally render debug window
    if self.show_debug_window then
      self:render_debug_window()
    end
  end,
  
  -- Render the debug window with event information
  render_debug_window = function(self)
    FS.api.gui.window("Event System Debug", 400, 500, function()
      -- Header section with stats
      self:render_header()
      FS.api.gui.separator()
      
      -- Tabs for different views
      if FS.api.gui.begin_tab_bar("EventDebugTabs") then
        -- Event Monitor tab
        if FS.api.gui.begin_tab_item("Event Monitor") then
          self:render_event_monitor()
          FS.api.gui.end_tab_item()
        end
        
        -- Listeners tab
        if FS.api.gui.begin_tab_item("Listeners") then
          self:render_listener_list()
          FS.api.gui.end_tab_item()
        end
        
        -- Test Events tab
        if FS.api.gui.begin_tab_item("Test Events") then
          self:render_test_events()
          FS.api.gui.end_tab_item()
        end
        
        FS.api.gui.end_tab_bar()
      end
    end)
  end,
  
  -- Render header with statistics
  render_header = function(self)
    -- Total event count
    local total_events = 0
    local total_listeners = 0
    local event_types = 0
    
    for event_name, listeners in pairs(FS.events.listeners) do
      event_types = event_types + 1
      total_listeners = total_listeners + #listeners
    end
    
    total_events = #FS.events.debug_history
    
    FS.api.gui.text("Event Types: " .. event_types)
    FS.api.gui.same_line(150)
    FS.api.gui.text("Total Listeners: " .. total_listeners)
    FS.api.gui.same_line(300)
    FS.api.gui.text("Recorded Events: " .. total_events)
    
    -- Controls
    FS.api.gui.separator()
    if FS.api.gui.button("Clear History") then
      FS.events:clear_debug_history()
    end
    
    FS.api.gui.same_line()
    if FS.api.gui.button("Refresh") then
      -- No need to do anything, UI updates every frame
    end
  end,
  
  -- Render recent event list
  render_event_monitor = function(self)
    FS.api.gui.text("Recent Events:")
    FS.api.gui.separator()
    
    -- Create a scrollable region
    if FS.api.gui.begin_child("EventList", 0, 300, true) then
      -- Show most recent events first
      for i, event in ipairs(FS.events.debug_history) do
        -- Calculate time ago
        local time_ago = math.floor(core.game_time() / 1000 - event.timestamp)
        local time_text = time_ago .. "s ago"
        
        -- Event name with colored highlight
        FS.api.gui.text_colored(event.name, 1, 0.8, 0.2, 1)
        FS.api.gui.same_line()
        FS.api.gui.text(" (" .. time_text .. ")")
        
        -- Source information if available
        if event.source then
          FS.api.gui.text("  Source: " .. event.source)
        end
        
        -- Data preview if available
        if event.data then
          local data_preview = ""
          if type(event.data) == "table" then
            data_preview = "Table with " .. self:count_table_keys(event.data) .. " properties"
          elseif type(event.data) == "string" then
            data_preview = '"' .. self:truncate_string(event.data, 30) .. '"'
          elseif type(event.data) == "number" then
            data_preview = tostring(event.data)
          elseif type(event.data) == "boolean" then
            data_preview = event.data and "true" or "false"
          else
            data_preview = type(event.data)
          end
          
          FS.api.gui.text_colored("  Data: ", 0.7, 0.7, 0.7, 1)
          FS.api.gui.same_line()
          FS.api.gui.text(data_preview)
        end
        
        FS.api.gui.separator()
      end
      
      FS.api.gui.end_child()
    end
    
    -- Filter controls (basic implementation)
    FS.api.gui.text("Filter by event name:")
    -- In a real implementation, this would have filtering logic
    FS.api.gui.input_text("##EventFilter", "", 300)
  end,
  
  -- Render listener list
  render_listener_list = function(self)
    FS.api.gui.text("Registered Event Listeners:")
    FS.api.gui.separator()
    
    -- Create a scrollable region
    if FS.api.gui.begin_child("ListenerList", 0, 300, true) then
      -- Sort event names for consistent display
      local event_names = {}
      for event_name, _ in pairs(FS.events.listeners) do
        table.insert(event_names, event_name)
      end
      table.sort(event_names)
      
      -- Display each event and its listeners
      for _, event_name in ipairs(event_names) do
        local listeners = FS.events.listeners[event_name]
        
        -- Only show events with listeners
        if #listeners > 0 then
          -- Event name as a collapsible header
          if FS.api.gui.collapsing_header(event_name .. " (" .. #listeners .. ")") then
            -- List each listener
            for i, listener in ipairs(listeners) do
              local listener_desc = "Listener #" .. i .. " (ID: " .. listener.id .. ")"
              if listener.once then
                listener_desc = listener_desc .. " [once]"
              end
              if listener.priority ~= 0 then
                listener_desc = listener_desc .. " [priority: " .. listener.priority .. "]"
              end
              FS.api.gui.text(listener_desc)
            end
          end
        end
      end
      
      FS.api.gui.end_child()
    end
  end,
  
  -- Register common test events
  register_test_events = function(self)
    -- Event definitions for testing
    self.test_events = {
      {name = "player.state.changed", data = {health = 100, mana = 50}},
      {name = "combat.started", data = {target = "Target Dummy"}},
      {name = "combat.ended", data = {duration = 45.2}},
      {name = "spell.cast.started", data = {spell_id = 12345, target = "Enemy"}},
      {name = "spell.cast.success", data = {spell_id = 12345, target = "Enemy"}},
      {name = "module.loaded", data = {module_name = "heal_engine"}},
      {name = "system.error", data = {component = "events", message = "Test error"}}
    }
  end,
  
  -- Render test events UI
  render_test_events = function(self)
    FS.api.gui.text("Test Event Emission:")
    FS.api.gui.separator()
    
    -- Create a scrollable region
    if FS.api.gui.begin_child("TestEvents", 0, 250, true) then
      for _, event in ipairs(self.test_events) do
        if FS.api.gui.button("Emit##" .. event.name) then
          -- Emit this test event
          FS.events:emit(event.name, event.data, "events_debug")
        end
        
        FS.api.gui.same_line()
        FS.api.gui.text(event.name)
        
        -- Listen buttons
        FS.api.gui.same_line(300)
        if FS.api.gui.button("Listen##" .. event.name) then
          -- Register a test listener
          FS.events:on(event.name, function(data)
            core.log("Test listener received event: " .. event.name)
          end)
        end
      end
      
      -- Custom event emission
      FS.api.gui.separator()
      FS.api.gui.text("Custom Event:")
      
      -- Static variables for input
      if not self.custom_event_name then
        self.custom_event_name = ""
      end
      
      -- Input for event name
      FS.api.gui.input_text("Event Name", self.custom_event_name, 200, function(value)
        self.custom_event_name = value
      end)
      
      -- Emit button
      if FS.api.gui.button("Emit Custom Event") and self.custom_event_name ~= "" then
        FS.events:emit(self.custom_event_name, {custom = true}, "events_debug")
      end
      
      FS.api.gui.end_child()
    end
    
    FS.api.gui.separator()
    FS.api.gui.text("Testing Tips:")
    FS.api.gui.bullet_text("Click 'Emit' to send a test event")
    FS.api.gui.bullet_text("Click 'Listen' to register a test listener")
    FS.api.gui.bullet_text("Use the 'Event Monitor' tab to see events")
    FS.api.gui.bullet_text("Check the 'Listeners' tab to see registered listeners")
  end,
  
  -- Helper to count table keys
  ---@param t table Table to count keys for
  ---@return number count Number of keys
  count_table_keys = function(self, t)
    if type(t) ~= "table" then return 0 end
    
    local count = 0
    for _ in pairs(t) do
      count = count + 1
    end
    return count
  end,
  
  -- Helper to truncate long strings
  ---@param str string String to truncate
  ---@param max_length number Maximum length before truncation
  ---@return string truncated Truncated string
  truncate_string = function(self, str, max_length)
    if type(str) ~= "string" then return tostring(str) end
    if #str <= max_length then return str end
    
    return string.sub(str, 1, max_length) .. "..."
  end
}

-- Initialize the debug module
FS.events_debug:init()

-- Return the module for proper loading
return FS.events_debug