local M = {}

local neovim_pane_id = nil
local claude_pane_id = nil

local wezterm_cmd = { "wezterm", "cli" }

local function wezterm(args)
  local cmd = vim.deepcopy(wezterm_cmd)
  for _, a in ipairs(args) do
    table.insert(cmd, a)
  end
  return cmd
end

local function get_all_panes()
  local cmd = wezterm({ "list", "--format", "json" })
  local result = vim.fn.system(cmd)
  local ok, data = pcall(vim.json.decode, result)
  if ok and data then
    return data
  end
  return {}
end

local function pane_exists(id)
  for _, pane in ipairs(get_all_panes()) do
    if pane.pane_id == id then
      return true
    end
  end
  return false
end

function M.setup(_) end

function M.open(cmd_string, env_table)
  if claude_pane_id and pane_exists(claude_pane_id) then
    vim.fn.system(wezterm({ "zoom-pane", "--unzoom", "--pane-id", neovim_pane_id }))
    return
  end

  neovim_pane_id = tonumber(vim.fn.getenv("WEZTERM_PANE"))

  local args = wezterm({
    "split-pane",
    "--right",
    "--percent",
    "40",
    "--cwd",
    LazyVim.root(),
    "pwsh",
    "-NoLogo",
    "-Command",
  })

  if env_table and next(env_table) then
    local env_parts = {}
    for k, v in pairs(env_table) do
      table.insert(env_parts, string.format("$env:%s='%s'", k, v))
    end
    table.insert(args, table.concat(env_parts, "; ") .. "; " .. cmd_string)
  else
    table.insert(args, cmd_string)
  end

  local output = vim.fn.system(args)
  claude_pane_id = tonumber(output:match("%d+"))
end

function M.close()
  if claude_pane_id then
    vim.fn.system(wezterm({ "kill-pane", "--pane-id", claude_pane_id }))
  end
  claude_pane_id = nil
  neovim_pane_id = nil
end

function M.simple_toggle(cmd_string, env_table)
  if neovim_pane_id and claude_pane_id and pane_exists(claude_pane_id) then
    vim.fn.system(wezterm({ "zoom-pane", "--toggle", "--pane-id", neovim_pane_id }))
  else
    M.open(cmd_string, env_table)
  end
end

function M.focus_toggle(cmd_string, env_table)
  if neovim_pane_id == tonumber(vim.fn.getenv("WEZTERM_PANE")) then
    vim.fn.system(wezterm({ "activate-pane", "--pane-id=" .. claude_pane_id }))
  else
    M.simple_toggle(cmd_string, env_table)
  end
end

function M.get_active_bufnr()
  return nil
end

function M.is_available()
  return vim.fn.executable("wezterm") ~= 0
end

function M.send(text)
  if not claude_pane_id or not pane_exists(claude_pane_id) then
    return false, "Claude pane not available"
  end

  local cmd = wezterm({ "send-text", "--pane-id", claude_pane_id, "--no-paste", "--", text })
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    return true
  else
    return false, "Failed to send text: " .. result
  end
end

return M
