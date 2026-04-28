return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- stylua: ignore start
    { "<A-Left>", function() require("smart-splits").resize_left() end, mode = { "n", "t" },desc = "Smart Splits: Resize Left" },
    { "<A-Down>", function() require("smart-splits").resize_down() end, mode = { "n", "t" },desc = "Smart Splits: Resize Down" },
    { "<A-Up>", function() require("smart-splits").resize_up() end, mode = { "n", "t" }, desc = "Smart Splits: Resize Up" },
    { "<A-Right>", function() require("smart-splits").resize_right() end, mode = { "n", "t" }, desc = "Smart Splits: Resize Right" },
    { "<A-h>", function() require("smart-splits").move_cursor_left() end, mode = { "n", "t" }, desc = "Smart Splits: Move Cursor Left" },
    { "<A-j>", function() require("smart-splits").move_cursor_down() end, mode = { "n", "t" }, desc = "Smart Splits: Move Cursor Down" },
    { "<A-k>", function() require("smart-splits").move_cursor_up() end, mode = { "n", "t" }, desc = "Smart Splits: Move Cursor Up" },
    { "<A-l>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "t" }, desc = "Smart Splits: Move Cursor Right" },
    -- stylua: ignore end
  },
}
