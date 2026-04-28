return {
  "coder/claudecode.nvim",
  opts = {
    terminal = {
      cwd = LazyVim.root(),
      provider = require("plugins.claudecode.wezterm-provider"),
    },
  },
}
