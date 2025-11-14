return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "frappe",
      background = {
        light = "latte",
        dark = "frappe",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = Settings.colorscheme or "catppuccin",
    },
  },
}
