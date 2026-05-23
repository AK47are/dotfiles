return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "omp",
      acp_providers = {
        omp = {
          command = "omp",
          args = { "acp" },
          env = {
            HOME = vim.fn.getenv("HOME"),
            PATH = vim.fn.getenv("PATH"),
          },
        },
      },
    },
  },
}
