local leet_arg = "leetcode"

local opts = {
  lang = "java",
  arg = leet_arg,
  cn = {
    enabled = true,
  },
  editor = {
    reset_previous_code = false,
  },
}

return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  lazy = leet_arg ~= vim.fn.argv(0, -1),
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "folke/snacks.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/which-key.nvim",
  },
  config = function()
    require("leetcode").setup(opts)
    -- 关闭诊断显示
    vim.diagnostic.enable(false)
    -- 关闭保存文件格式化，如果本身 leetcode 模板格式和自己应用格式一样，则可以启用
    -- vim.g.autoformat = false

    -- 避免按太快触发 <leader>l 对应功能，延迟删除保证全部快捷键配置完毕
    vim.schedule(function()
      vim.defer_fn(function()
        vim.keymap.del("n", "<leader>l")
      end, 100)
    end)

    require("which-key").add({ "<leader>l", group = "+leetcode" })
    local keys = {
      { "<leader>lc", "<Cmd>Leet console<Cr>", desc = "Leet: Console" },
      { "<leader>lt", "<Cmd>Leet test<Cr>", desc = "Leet: Test" },
      { "<leader>lT", "<Cmd>Leet tabs<Cr>", desc = "Leet: Select tabs" },
      { "<leader>ls", "<Cmd>Leet submit<Cr>", desc = "Leet: Submit" },
      { "<leader>ll", "<Cmd>Leet list status=notac<Cr>", desc = "Leet: Select question (in progress)" },
      { "<leader>lL", "<Cmd>Leet list status=ac<Cr>", desc = "Leet: Select question (ac)" },
      { "<leader>lm", "<Cmd>Leet menu<Cr>", desc = "Leet: Menu" },
      { "<leader>lo", "<Cmd>Leet open<Cr>", desc = "Leet: Open in browser" },
      { "<leader>ly", "<Cmd>Leet yank<Cr>", desc = "Leet: Yank code" },
      { "<leader>ld", "<Cmd>Leet desc<Cr>", desc = "Leet: Toggle description" },
      { "<leader>lr", "<Cmd>Leet random status=ac<Cr>", desc = "Leet: Random question (ac)" },
      { "<leader>lR", "<Cmd>Leet reset<Cr>", desc = "Leet: Reset code" },
    }
    for _, key in ipairs(keys) do
      vim.keymap.set("n", key[1], key[2], { desc = key.desc, silent = true })
    end
  end,
}
