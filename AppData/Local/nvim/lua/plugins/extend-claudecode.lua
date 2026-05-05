return {
  "coder/claudecode.nvim",
  opts = {
    terminal = {
      cwd = LazyVim.root(),
      provider = require("plugins.claudecode.wezterm-provider"),
    },
    diff_opts = {
      layout = "horizontal",
      open_in_new_tab = true,
    },
  },
  keys = {
    { "<leader>aq", "<cmd>ClaudeCodeClose<cr>", desc = "Quit Claude" },
    {
      "<leader>as",
      function()
        local visual_commands = require("claudecode.visual_commands")
        local is_visual, _ = visual_commands.validate_visual_mode()

        if is_visual then
          visual_commands.exit_visual_and_schedule(function()
            vim.cmd("'<,'>ClaudeCodeSend")
            vim.ui.input({ prompt = "Extra message: " }, function(input)
              if input and input ~= "" then
                require("plugins.claudecode.wezterm-provider").send(input .. "\x0D")
              end
            end)
          end)
        else
          vim.ui.input({ prompt = "Send to Claude: " }, function(input)
            if not input or input == "" then
              return
            end
            require("plugins.claudecode.wezterm-provider").send(input .. "\x0D")
          end)
        end
      end,
      mode = { "n", "v" },
      desc = "Send to Claude",
    },
  },
}
