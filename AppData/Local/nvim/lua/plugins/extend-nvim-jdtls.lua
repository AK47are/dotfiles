return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      on_attach = function(args)
        local buf = args.buf
        local filename = vim.fn.expand("#" .. buf .. ":t:r")
        if filename:match("Mapper") then
          vim.keymap.set("n", "<leader>cgm", function()
            local name = vim.fn.expand("%:t:r")
            local root = LazyVim.root()
            local search_dirs = {
              root .. "/src/main/resources/**/",
              root .. "/src/main/java/**/mapper/**/",
            }
            local files = {}
            for _, dir in ipairs(search_dirs) do
              local found = vim.fn.globpath(dir, name .. ".xml", false, true)
              vim.list_extend(files, found)
            end

            if #files == 0 then
              vim.notify("No matching XML file for " .. name, vim.log.levels.WARN)
            else
              if #files > 1 then
                vim.notify("Multiple XML files found, opening first: " .. #files, vim.log.levels.INFO)
              end
              vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
            end
          end, { buffer = buf, silent = true, desc = "Goto Mapper XML" })
        end

        if LazyVim.has("which-key.nvim") then
          require("which-key").add({ { "<leader>cg", group = "goto", buffer = buf } })
        end
      end,
    },
  },
}
