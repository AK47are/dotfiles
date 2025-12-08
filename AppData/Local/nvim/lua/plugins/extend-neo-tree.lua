return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  opts = {
    filesystem = {
      -- 折叠空文件夹
      group_empty_dirs = true,
      scan_mode = "deep",
    },
  },
}
