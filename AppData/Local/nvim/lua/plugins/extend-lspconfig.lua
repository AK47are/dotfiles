-- 配置 Neovim 使用的 Java 版本，jdtls 需要 Java 21+
vim.env.JAVA_HOME = vim.fn.system("scoop prefix openjdk"):gsub("%s+$", "")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      html = {},
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      },
    },
  },
}
