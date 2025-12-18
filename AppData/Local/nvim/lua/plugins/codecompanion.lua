local adapter_name = "dashscope"
local adapter_model = "qwen-flash"

return {
  {
    "olimorris/codecompanion.nvim",
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
          dashscope = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "dashscope",
              formatted_name = "DashScope",
              env = {
                url = "https://dashscope.aliyuncs.com",
                api_key = "DASHSCOPE_API_KEY",
                chat_url = "/compatible-mode/v1/chat/completions",
              },
              schema = {
                ---@type CodeCompanion.Schema
                model = {
                  order = 1,
                  mapping = "parameters",
                  type = "enum",
                  desc = "ID of the model to use.",
                  ---@type string|fun(): string
                  default = "qwen-plus",
                  choices = {
                    ["qwen-plus"] = {
                      formatted_name = "DashScope",
                      opts = { can_reason = true, can_use_tools = false },
                    },
                    ["qwen-flash"] = {
                      formatted_name = "DashScope",
                      opts = { can_reason = true, can_use_tools = true },
                    },
                    ["qwen3-max"] = { formatted_name = "DashScope", opts = { can_use_tools = true } },
                    ["qwen3-coder-plus"] = { formatted_name = "DashScope", opts = { can_use_tools = true } },
                  },
                },
                ---@type CodeCompanion.Schema
                temperature = {
                  order = 2,
                  mapping = "parameters",
                  type = "number",
                  optional = true,
                  default = 0.7,
                  desc = "Sampling temperature controlling output diversity. Higher values increase diversity",
                  validate = function(n)
                    return n >= 0 and n < 2, "Must be between 0 and 2"
                  end,
                },
                ---@type CodeCompanion.Schema
                top_p = {
                  order = 3,
                  mapping = "parameters",
                  type = "number",
                  optional = true,
                  default = 0.95,
                  desc = "Nucleus sampling probability threshold. Range: (0, 1]",
                  validate = function(n)
                    return n > 0 and n <= 1, "Must be between 0 and 1"
                  end,
                },
                ---@type CodeCompanion.Schema
                top_k = {
                  order = 3,
                  mapping = "parameters",
                  type = "number",
                  optional = true,
                  default = 20,
                  desc = "Size of candidate set for sampling. Set to 0 or >100 to disable",
                  validate = function(n)
                    return n >= 0, "Must be greater than or equal to 0"
                  end,
                },
                ---@type CodeCompanion.Schema
                presence_penalty = {
                  order = 4,
                  mapping = "parameters",
                  type = "number",
                  optional = true,
                  default = 0,
                  desc = "Control repetition in generated text. Range: [-2.0, 2.0]",
                  validate = function(n)
                    return n >= -2 and n <= 2, "Must be between -2 and 2"
                  end,
                },
                ---@type CodeCompanion.Schema
                max_tokens = {
                  order = 5,
                  mapping = "parameters",
                  type = "integer",
                  optional = true,
                  default = 16384,
                  desc = "Maximum tokens to generate, limited by model context length",
                  validate = function(n)
                    return n > 0, "Must be greater than 0"
                  end,
                },
                ---@type CodeCompanion.Schema
                enable_thinking = {
                  order = 6,
                  mapping = "parameters",
                  type = "boolean",
                  optional = true,
                  default = true,
                  desc = "Whether to activate the thinking mode.",
                  subtype_key = {
                    type = "integer",
                  },
                },
                ---@type CodeCompanion.Schema
                thinking_budget = {
                  order = 7,
                  mapping = "parameters",
                  type = "integer",
                  optional = true,
                  default = nil,
                  desc = "The maximum length of the thinking process takes effect only when enable_thinking is true.",
                  validate = function(n)
                    return n > 0, "Must be greater than 0"
                  end,
                },
                ---@type CodeCompanion.Schema
                seed = {
                  order = 8,
                  mapping = "parameters",
                  type = "integer",
                  optional = true,
                  default = nil,
                  desc = "Random seed for deterministic generation. Range: [0, 2147483647]",
                  validate = function(n)
                    return n >= 0 and n <= 2147483647, "Must be between 0 and 2147483647"
                  end,
                },
                ---@type CodeCompanion.Schema
                logprobs = {
                  order = 9,
                  mapping = "parameters",
                  type = "boolean",
                  optional = true,
                  default = nil,
                  desc = "Whether to return log probabilities of output tokens",
                  subtype_key = {
                    type = "integer",
                  },
                },
                ---@type CodeCompanion.Schema
                top_logprobs = {
                  order = 10,
                  mapping = "parameters",
                  type = "integer",
                  optional = true,
                  default = nil,
                  desc = "Number of top candidate tokens to return per step. Range: [0, 5]",
                  validate = function(n)
                    return n >= 0 and n <= 5, "Must be between 0 and 5"
                  end,
                },
                ---@type CodeCompanion.Schema
                stop = {
                  order = 11,
                  mapping = "parameters",
                  type = "list",
                  optional = true,
                  default = nil,
                  subtype = {
                    type = "string",
                  },
                  desc = "Generation stops when specified strings or token_ids are about to be generated",
                  validate = function(l)
                    return #l >= 1 and #l <= 256, "Must have between 1 and 256 elements"
                  end,
                },
                ---@type CodeCompanion.Schema
                enable_search = {
                  order = 12,
                  mapping = "parameters",
                  type = "boolean",
                  optional = true,
                  default = true,
                  desc = "Whether the model uses Internet search results as a reference when generating text.",
                  subtype_key = {
                    type = "integer",
                  },
                },
                ---@type CodeCompanion.Schema
                user = {
                  order = 13,
                  mapping = "parameters",
                  type = "string",
                  optional = true,
                  default = nil,
                  desc = "A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. Learn more.",
                  validate = function(u)
                    return u:len() < 100, "Cannot be longer than 100 characters"
                  end,
                },
              },
            })
          end,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
      "folke/snacks.nvim",
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
