---@alias on_render fun()

---@type on_render
function FS.entry_helper.on_render()
  -- Check if script is enabled
  if not FS.variables.enabled then
    return
  end
  
  -- Render core debug UIs
  if FS.events_debug then
    FS.events_debug:on_render()
  end
  
  -- Render spec module if available
  if FS.spec_config and FS.spec_config.on_render then
    FS.error_handler:safe_execute(FS.spec_config.on_render, "spec_module.on_render")
  end
  
  -- Emit render event
  FS.events:emit("system.render", {timestamp = core.game_time() / 1000}, "entry.on_render")
end
