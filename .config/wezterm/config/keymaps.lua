local act = WezTerm.action
local function extend_copy_mode(keys)
  local copy_mode = WezTerm.gui.default_key_tables().copy_mode
  for _, k in ipairs(keys) do
    table.insert(copy_mode, {
      key = k.key,
      mods = k.mods,
      action = k.action,
    })
  end
  Config.key_tables = {
    copy_mode = copy_mode,
  }
end

extend_copy_mode({
  {
    key = "y",
    mods = "NONE",
    action = act.Multiple({
      act.CopyTo("ClipboardAndPrimarySelection"),
      act.CopyMode("ClearSelectionMode"),
    }),
  },
  { key = "Escape", mods = "NONE", action = act.CopyMode("ClearSelectionMode") },
  {
    key = "i",
    mods = "NONE",
    action = act.Multiple({
      act.ScrollToBottom,
      act.CopyMode("Close"),
    }),
  },
})
