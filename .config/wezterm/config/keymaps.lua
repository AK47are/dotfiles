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

-- Ctrl+1..8 → jump to tab 1-8; Ctrl+9 → jump to last tab
local keys = WezTerm.gui.default_keys()
for i = 1, 8 do
  table.insert(keys, {
    key = tostring(i),
    mods = "CTRL",
    action = act.ActivateTab(i - 1),
  })
end
table.insert(keys, {
  key = "9",
  mods = "CTRL",
  action = act.ActivateTab(-1),
})
Config.keys = keys
