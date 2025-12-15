return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI: Toggle Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI: Select Action" },
      { "<leader>ai", mode = { "n", "v" }, "<cmd>CodeCompanion<cr>", desc = "AI: Inline Chat" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = {
            name = "deepseek",
            model = "deepseek-chat",
          },
          auto_scroll = false,
          opts = {
            system_prompt = (function()
              local file = io.open(vim.fn.stdpath("config") .. "/assets/ai-rules.md", "r")
              if not file then
                return ""
              end
              local content = file:read("*all")
              file:close()
              return content
            end)(),
          },
        },
        inline = { adapter = "deepseek" },
        cmd = { adapter = "deepseek" },
      },
      adapters = {
        acp = { opts = { show_defaults = false } },
        http = { opts = { show_defaults = false } },
      },
      display = { action_palette = { provider = "snacks" } },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
