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
      display = {
        chat = { auto_scroll = false },
        action_palette = { provider = "snacks" },
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
          tools = {
            opts = {
              auto_submit_errors = true,
              auto_submit_success = true,
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
        http = {
          opts = { show_defaults = false },
          siliconflow_deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              name = "siliconflow_deepseek",
              url = "https://api.siliconflow.cn/v1/chat/completions",
              env = {
                api_key = "SILICONFLOW_API_KEY",
              },
              schema = {
                model = {
                  default = "deepseek-ai/DeepSeek-V3.2",
                  choices = {
                    ["deepseek-ai/DeepSeek-V3.2"] = {},
                  },
                },
              },
            })
          end,

          aliyun_deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              name = "aliyun_deepseek",
              url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
              env = {
                api_key = "DASHSCOPE_API_KEY",
              },
              schema = {
                model = {
                  default = "deepseek-v3.2",
                  choices = {
                    ["deepseek-v3.2"] = {},
                  },
                },
              },
            })
          end,
        },
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
