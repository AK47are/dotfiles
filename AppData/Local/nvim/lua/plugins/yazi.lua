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
        require("yazi").yazi(nil, vim.g.yazi_last_directory or LazyVim.root())
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
    -- log_level = vim.log.levels.DEBUG,
    keymaps = {
      show_help = "<f1>",
    },
    hooks = {
      yazi_closed_successfully = function(_, _, state)
        vim.g.yazi_last_directory = tostring(state.last_directory)
      end,
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
