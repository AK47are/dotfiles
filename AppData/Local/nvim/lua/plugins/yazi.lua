return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "folke/snacks.nvim",
    "MagicDuck/grug-far.nvim",
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    {
      "<leader>e",
      function()
        local yazi = require("yazi")
        local path = yazi.previous_state and yazi.previous_state.last_hovered
        if path then
          yazi.yazi(nil, path, { reveal_path = path })
        else
          yazi.yazi(nil, LazyVim.root())
        end
      end,
      desc = "Resume Yazi (or Root)",
    },
    {
      "<leader>fe",
      function()
        require("yazi").yazi(nil, LazyVim.root())
      end,
      desc = "Explorer Yazi (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Explorer Yazi (cwd)",
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
