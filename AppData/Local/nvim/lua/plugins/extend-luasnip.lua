return {
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_lua").lazy_load()

      -- LazyVim 默认的 <Esc> 会直接退出当前 snippet，退出去之后镜像（比如 soute 里的 <>）就再也不跟着更新了；
      -- 这里改成只在已经跳到最后一个位置、没得再跳时才退出
      vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
        vim.cmd("noh")
        local ls = require("luasnip")
        if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.jumpable(1) then
          ls.unlink_current()
        end
        return "<esc>"
      end, { expr = true, desc = "Escape and Clear hlsearch" })
    end,
  },
}
