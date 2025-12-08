return {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
  },
  opts = {
    cmake_build_directory = "build",
    cmake_runner = {
      name = "terminal",
      opts = {
        split_direction = "vertical",
        split_size = 30,
        -- 避免移动窗口后，运行 CMakeBuild 会导致窗口混乱
        auto_resize = false,
      },
    },
  },
  config = function(_, opts)
    require("cmake-tools").setup(opts)
    require("which-key").add({ "<leader>m", group = "+cmake" })
    local keys = {
      { "<leader>mb", "<cmd>CMakeBuild<cr>", desc = "CMake: Build" },
      { "<leader>mr", "<cmd>CMakeRun<cr>", desc = "CMake: Run" },
      { "<leader>md", "<cmd>CMakeDebug<cr>", desc = "CMake: Debug" },
      { "<leader>mt", "<cmd>CMakeRunTest<cr>", desc = "CMake: Test" },
      { "<leader>mc", "<cmd>CMakeClean<cr>", desc = "CMake: Clean" },
      { "<leader>me", "<cmd>CMakeCloseExecutor<cr>", desc = "CMake: Close Executor" },
      { "<leader>mE", "<cmd>CMakeOpenExecutor<cr>", desc = "CMake: Open Executor" },
      { "<leader>mw", "<cmd>CMakeCloseRunner<cr>", desc = "CMake: Close Runner" },
      { "<leader>mW", "<cmd>CMakeOpenRunner<cr>", desc = "CMake: Oepn Runner" },
    }
    for _, key in ipairs(keys) do
      vim.keymap.set("n", key[1], key[2], { desc = key.desc, silent = true })
    end
  end,
}
