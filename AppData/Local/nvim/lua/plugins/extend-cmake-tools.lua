return {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
  },
  keys = {
    { "<localleader>c", "<cmd>CMakeQuickStart<cr>", desc = "CMake: QuickStart" },
  },
  opts = {
    cmake_build_directory = "build\\${variant:buildType}",
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
      { "<leader>mc", "<cmd>CMakeClean<cr>", desc = "CMake: Clean" },
      { "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake: Select Launch Target" },
      { "<leader>mt", "<cmd>CMakeRunTest<cr>", desc = "CMake: Test" },
      { "<leader>mT", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake: Select Build Type" },

      { "<leader>mb", "<cmd>CMakeQuickBuild<cr>", desc = "CMake: Quick Build" },
      { "<leader>mB", "<cmd>CMakeBuild<cr>", desc = "CMake: Build" },
      { "<leader>mr", "<cmd>CMakeQuickRun<cr>", desc = "CMake: Quick Run" },
      { "<leader>mR", "<cmd>CMakeRun<cr>", desc = "CMake: Run" },
      { "<leader>md", "<cmd>CMakeQuickDebug<cr>", desc = "CMake: Quick Debug" },
      { "<leader>mD", "<cmd>CMakeDebug<cr>", desc = "CMake: Debug" },
      { "<leader>ms", "<cmd>CMakeStopRunner<cr>", desc = "CMake: Stop Runner" },
      { "<leader>mS", "<cmd>CMakeStopExecutor<cr>", desc = "CMake: Stop Executor" },
      { "<leader>me", "<cmd>CMakeCloseExecutor<cr>", desc = "CMake: Close Executor" },
      { "<leader>mE", "<cmd>CMakeOpenExecutor<cr>", desc = "CMake: Open Executor" },
      { "<leader>mw", "<cmd>CMakeCloseRunner<cr>", desc = "CMake: Close Runner" },
      { "<leader>mW", "<cmd>CMakeOpenRunner<cr>", desc = "CMake: Open Runner" },
    }
    for _, key in ipairs(keys) do
      vim.keymap.set("n", key[1], key[2], { desc = key.desc, silent = true })
    end
  end,
}
