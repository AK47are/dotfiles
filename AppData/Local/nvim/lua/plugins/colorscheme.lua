return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "frappe",
      background = {
        light = "latte",
        dark = "frappe",
      },
      -- terminal must support and enable
      transparent_background = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
