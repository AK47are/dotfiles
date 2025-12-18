local adapter_name = "aliyun_deepseek"
local adapter_model = "deepseek-v3.2"

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
      prompt_library = {
        markdown = { dirs = { vim.fn.stdpath("config") .. "/assets/prompts" } },
      },
      interactions = {
        chat = {
          adapter = {
            name = adapter_name,
            model = adapter_model,
          },
        },
        inline = {
          adapter = {
            name = adapter_name,
            model = adapter_model,
          },
        },
        cmd = {
          adapter = {
            name = adapter_name,
            model = adapter_model,
          },
        },
        background = {
          adapter = {
            name = adapter_name,
            model = adapter_model,
          },
        },
      },
      adapters = {
        http = {
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
