---@alias on_render fun()

---@type on_render
function FS.entry_helper.on_render()
  -- Check if script is enabled
  if not FS.variables.enabled then
    return
  end

  -- Render spec module if available
  if FS.spec_config and FS.spec_config.on_render then
    FS.spec_config.on_render()
  end
end
