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
          keymaps = {
            previous_header = {
              modes = { n = "[[" },
              index = 14,
              callback = function()
                local api = vim.api
                local bufnr = api.nvim_get_current_buf()
                local cursor = api.nvim_win_get_cursor(0)
                local current_row = cursor[1] - 1

                local parser = vim.treesitter.get_parser(bufnr, "markdown")
                if parser == nil then
                  vim.notify("Couldn't find the 'markdown' treesitter parser!")
                  return
                end

                local root_tree = parser:parse()[1]:root()
                local query = vim.treesitter.query.parse("markdown", [[(atx_heading) @heading]])

                local from_row = 0
                local to_row = current_row
                local found_headings = {}
                for id, node in query:iter_captures(root_tree, bufnr, from_row, to_row) do
                  if query.captures[id] == "heading" then
                    local _, _, node_end, _ = node:range()
                    if node_end < current_row then
                      table.insert(found_headings, node)
                    end
                  end
                end

                if #found_headings > 0 then
                  local target_node = found_headings[#found_headings]
                  vim.cmd("normal! m'")
                  local start_row, start_col, _, _ = target_node:range()
                  api.nvim_win_set_cursor(0, { start_row + 1, start_col })
                end
              end,
              description = "Previous header",
            },
            next_header = {
              modes = { n = "]]" },
              index = 13,
              callback = function()
                local api = vim.api
                local bufnr = api.nvim_get_current_buf()
                local cursor = api.nvim_win_get_cursor(0)
                local current_row = cursor[1] - 1

                local parser = vim.treesitter.get_parser(bufnr, "markdown")
                if parser == nil then
                  vim.notify("Couldn't find the 'markdown' treesitter parser!")
                  return
                end

                local root_tree = parser:parse()[1]:root()
                local query = vim.treesitter.query.parse("markdown", [[(atx_heading) @heading]])

                local from_row = current_row + 1
                local to_row = -1
                for id, node in query:iter_captures(root_tree, bufnr, from_row, to_row) do
                  if query.captures[id] == "heading" then
                    vim.cmd("normal! m'")
                    local start_row, start_col, _, _ = node:range()
                    api.nvim_win_set_cursor(0, { start_row + 1, start_col })
                    return
                  end
                end
              end,
              description = "Next header",
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
