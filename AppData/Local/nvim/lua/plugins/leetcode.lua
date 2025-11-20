local leet_arg = "leetcode"

local opts = {
  -- lang = "cpp",
  lang = "java",
  -- kotlin LSP 暂时无法使用
  -- lang = "kotlin",
  arg = leet_arg,
  cn = {
    enabled = true,
  },
  injector = {
    ["cpp"] = {
      imports = function()
        -- 欺骗 LSP，让它不要随意 #include 和添加 std::
        return {
          "#include <iostream>",
          "#include <vector>",
          "#include <string>",
          "#include <algorithm>",
          "#include <map>",
          "#include <set>",
          "#include <queue>",
          "#include <stack>",
          "#include <unordered_map>",
          "#include <unordered_set>",
          "using namespace std;",
        }
      end,
    },
    -- java 一开始可以检测到 Vector 等包，但添加了后面注释语句就会在格式化后失效
    -- 可能是 LSP 的 Bug，重启 LSP 可修复，仅在首次格式化后会失效，修复后再格式化就没事
    -- 似乎是被缓存了。
    ["java"] = {
      imports = function()
        return { "import java.util.*;", "import java.lang.*;" }
      end,
    },
    --   kotlin 未测试
    -- ["kotlin"] = {
    --   imports = function()
    --     return { "import java.util.*", "import kotlin.math.*" }
    --   end,
    -- },
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

    require("which-key").add({ "<leader>l", group = "leetcode" })
    local keys = {
      { "<leader>lc", "<Cmd>Leet console<Cr>", desc = "Leet: Console" },
      { "<leader>lt", "<Cmd>Leet test<Cr>", desc = "Leet: Test" },
      { "<leader>ls", "<Cmd>Leet submit<Cr>", desc = "Leet: Submit" },
      { "<leader>ll", "<Cmd>Leet list status=notac<Cr>", desc = "Leet: Select question (in progress)" },
      { "<leader>lL", "<Cmd>Leet list status=ac<Cr>", desc = "Leet: Select question (ac)" },
      { "<leader>lm", "<Cmd>Leet menu<Cr>", desc = "Leet: Menu" },
      { "<leader>lo", "<Cmd>Leet open<Cr>", desc = "Leet: Open in browser" },
      { "<leader>ly", "<Cmd>Leet yank<Cr>", desc = "Leet: Yank code" },
      { "<leader>ld", "<Cmd>Leet desc<Cr>", desc = "Leet: Toggle description" },
    }
    for _, key in ipairs(keys) do
      vim.keymap.set("n", key[1], key[2], { desc = key.desc, silent = true })
    end
  end,
}
