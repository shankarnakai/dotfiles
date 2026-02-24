return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- recommended (floating window library)
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("go").setup({
        lsp_cfg = true,      -- use go.nvim's default gopls setup
        lsp_codelens = true,
        lsp_gofumpt = true,  -- if you want gofumpt instead of gofmt
        test_runner = "go",  -- or "richgo", "dlv", "ginkgo"
      })
      -- Optional: run gofmt + goimport on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local ok, err = pcall(require("go.format").goimport)
          if not ok then
            vim.notify("goimport error: " .. tostring(err), vim.log.levels.WARN)
          end
        end,
      })

      -- Example keymaps
      vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", { desc = "Go Test" })
      vim.keymap.set("n", "<leader>gf", ":GoTestFunc<CR>", { desc = "Go Test Current Func" })
      vim.keymap.set("n", "<leader>gi", ":GoImpl<CR>", { desc = "Implement interface" })
      vim.keymap.set("n", "<leader>gc", ":GoCmt<CR>", { desc = "Add comment" })
    end,
    build = ":GoInstallBinaries", -- to install all necessary Go tools
    ft = { "go", "gomod" },
  },
}
