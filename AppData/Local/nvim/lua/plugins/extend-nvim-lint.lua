return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- 移除 markdown 的 linter 配置
    opts.linters_by_ft.markdown = nil

    return opts
  end,
}
