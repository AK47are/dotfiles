return {
  {
    "olimorris/codecompanion.nvim",
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
      opts = {
        language = "Chinese",
      },
      interactions = {
        chat = {
          adapter = {
            name = "deepseek",
            model = "deepseek-chat",
          },
          variables = {
            ["buffer"] = {
              opts = {
                default_params = "diff",
              },
            },
          },
        },
        inline = {
          adapter = {
            name = "deepseek",
            model = "deepseek-chat",
          },
        },
        cmd = {
          adapter = {
            name = "deepseek",
            model = "deepseek-chat",
          },
        },
        background = {
          adapter = {
            name = "deepseek",
            model = "deepseek-chat",
          },
        },
      },
      adapters = {
        acp = { opts = { show_defaults = false } },
        http = { opts = { show_defaults = false } },
      },
      display = {
        chat = { auto_scroll = false },
        action_palette = { provider = "snacks" },
      },
    },
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
