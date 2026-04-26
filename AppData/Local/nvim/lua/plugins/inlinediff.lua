return {
  "YouSame2/inlinediff-nvim",
  event = "VeryLazy",
  cmd = "InlineDiff",
  opts = {},
  config = function(_, opts)
    require("inlinediff").setup(opts)
    Snacks.toggle({
      name = "Inline Diff",
      get = function()
        return require("inlinediff").enabled
      end,
      set = function(state)
        local m = require("inlinediff")
        if state ~= m.enabled then
          m.toggle()
        end
      end,
    }):map("<leader>up")

    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("InlineDiffUser", { clear = true }),
      callback = function()
        local m = require("inlinediff")
        if m.enabled then
          m.refresh()
        end
      end,
    })
  end,
}
