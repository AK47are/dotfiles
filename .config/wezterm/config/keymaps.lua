local act = WezTerm.action
Config.key_tables = {}

local function extend_key_table(mode, keys)
  local target = WezTerm.gui.default_key_tables()[mode]
  for _, k in ipairs(keys) do
    table.insert(target, {
      key = k[1],
      mods = k[2],
      action = k[3],
    })
  end
  Config.key_tables[mode] = target
end

extend_key_table("copy_mode", {
  {
    "y",
    "NONE",
    act.Multiple({
      act.CopyTo("ClipboardAndPrimarySelection"),
      act.CopyMode("ClearSelectionMode"),
    }),
  },
  {
    "i",
    "NONE",
    act.Multiple({
      act.ScrollToBottom,
      act.CopyMode("Close"),
    }),
  },
  { "Escape", "NONE", act.CopyMode("ClearSelectionMode") },
})

extend_key_table("search_mode", {
  {
    "Escape",
    "NONE",
    act.Multiple({
      act.CopyMode("ClearPattern"),
      act.CopyMode("Close"),
    }),
  },
})
