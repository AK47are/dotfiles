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
    --   java 一开始可以检测到 Vector 等包，但添加了 import java.util.* 就会失效
    --   ["java"] = {
    --     imports = function()
    --       return { "import java.util.*;", "import java.lang.*;" }
    --     end,
    --   },
    --   kotlin 未测试
    -- ["kotlin"] = {
    --   imports = function()
    --     return { "import java.util.*", "import kotlin.math.*" }
    --   end,
    -- },
  },
}

return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "folke/snacks.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("leetcode").setup(opts)
    -- 关闭诊断显示
    vim.diagnostic.enable(false)
    -- 关闭保存文件格式化，如果本身 leetcode 模板格式和自己应用格式一样，则可以启用
    -- vim.g.autoformat = false
  end,
  lazy = leet_arg ~= vim.fn.argv(0, -1),
}
