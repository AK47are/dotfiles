return {
  "folke/flash.nvim",
  keys = {
    -- 禁用默认的 s 和 S
    { "s", false },
    { "S", false },
    { "<c-space>", false },

    -- 添加新的键位绑定
    {
      "<A-s>",
      mode = { "n", "i", "o", "x" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "<A-S>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "<c-l>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<c-l>"] = "next",
            ["<BS>"] = "prev",
          },
        })
      end,
      desc = "Treesitter Incremental Selection",
    },
  },
}
