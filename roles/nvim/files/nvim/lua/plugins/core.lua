return {
    { "folke/lazy.nvim", version = false },
    { "folke/tokyonight.nvim" },
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Debugging (replaces vim-delve) - nvim-dap
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
        },
        ft = { "go"},
        keys = {
            { "<leader>ds", function() require("dap-go").debug_test() end, desc = "Debug Go test" },
            { "<leader>dt", "<cmd>lua require('dap').terminate()<CR>", desc = "Terminate DAP" },
        },
        config = function()
            -- Basic DAP config
            require("dap-go").setup()
        end,
    },


    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-neotest/nvim-nio" },
    { "jay-babu/mason-nvim-dap.nvim" },

    {
        "ibhagwan/fzf-lua",
        init = function()
            local map = vim.keymap.set
            map("n", "<C-p>",      "<cmd>FzfLua files<cr>",       { desc = "Find files (fzf-lua)" })
            map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>",   { desc = "Live grep (fzf-lua)" })
            map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>",     { desc = "Find buffers (fzf-lua)" })
            map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>",   { desc = "Help (fzf-lua)" })
            map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git commits (fzf-lua)" })
        end,
        opts = { "fzf-vim" },
    },

    -- Surround (replaces tpope/vim-surround)
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
    },

    -- Targets (replaces wellle/targets.vim)
    -- mini.ai provides enhanced text objects (around quotes, brackets, etc.)
    {
        "nvim-mini/mini.ai",
        version = "*",
        event = "VeryLazy",
    },

    -- Commenting (replaces tpope/vim-commentary)
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
            -- Example keymaps:
            -- `gcc` -> toggle comment on the current line
            -- `gc` in visual mode -> toggle comment on selection
        end,
    },

    -- Buffer delete (replaces moll/vim-bbye)
    {
        "famiu/bufdelete.nvim",
        keys = {
            { "X", "<cmd>Bdelete<CR>", desc = "Bdelete current buffer" },
        },
    },

    -- File explorer (replaces preservim/nerdtree)
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "<C-f>", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle Nvim-Tree" },
        },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Linting/Formatting + LSP (replaces ALE & coc.nvim)
    -- For a simpler setup, let's just do LSP + null-ls for lint/format
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- auto-install LSP servers
            {
                "mason-org/mason.nvim",
                config = true,
            },
            {
                "mason-org/mason-lspconfig.nvim",
                config = function()
                    require("mason-lspconfig").setup({
                        ensure_installed = { "pyright", "ts_ls", "gopls", "rust_analyzer" },
                        automatic_enable = false,
                        automatic_installation = true,
                        automatic_setup = false,
                    })
                end,
            },
            {
              "nvimtools/none-ls.nvim",
              event = { "BufReadPre", "BufNewFile" },
              config = function()
                local none_ls = require("null-ls") -- it's still called `null-ls` internally

                none_ls.setup({
                  sources = {
                    none_ls.builtins.formatting.prettier,
                    none_ls.builtins.diagnostics.eslint,
                    -- add other sources as needed
                  },
                })
              end,
            },
        },
        config = function()
          local lspconfig = require("lspconfig")

          -- buffer-local LSP keymaps
          local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, desc = "Go to definition" }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          end

          local capabilities = vim.lsp.protocol.make_client_capabilities()

          for _, server in ipairs({ "ts_ls", "pyright", "gopls", "rust_analyzer" }) do
            lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
          end
        end,
    },
    -- Statusline (replaces vim-airline)
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "horizon",
                    section_separators = "",
                    component_separators = "",
                },
            })
        end,
    },

    -- Snippets (replaces Ultisnips)
    {
        "L3MON4D3/LuaSnip",
        version = "*",
        config = function()
            -- You can load snippet collections like this:
            require("luasnip.loaders.from_vscode").lazy_load() -- loads friendly-snippets
        end,
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },

    -- Indent detection (replaces tpope/vim-sleuth)
    {
        "nmac427/guess-indent.nvim",
        event = "BufReadPost",
        config = function()
            require("guess-indent").setup({})
        end,
    },

    -- Yank highlighting (replaces vim-highlightedyank)
    {
        "gbprod/yanky.nvim",
        event = "VeryLazy",
        config = function()
            require("yanky").setup({})
            -- If you want highlight on yank, you can also do:
            vim.api.nvim_create_autocmd("TextYankPost", {
                callback = function()
                    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
                end,
            })
        end,
    },

    -- Git signs (replaces vim-gitgutter)
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup({
                -- Keymaps
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end
                    map("n", "<leader>gh", gs.stage_hunk, { desc = "Git stage hunk" })
                    map("n", "<leader>gH", gs.undo_stage_hunk, { desc = "Git undo stage hunk" })
                    map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
                    map("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
                end,
            })
        end,
    },

    -- Git (optionally replaces tpope/vim-fugitive)
    -- Neogit for a Magit-like interface
    {
        "TimUntersberger/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<CR>", desc = "Neogit status" },
        },
        config = function()
            require("neogit").setup({})
        end,
    },

    -- Code outline (replaces majutsushi/tagbar)
    {
        "stevearc/aerial.nvim",
        cmd = { "AerialToggle", "AerialOpen" },
        keys = {
            { "<leader>\\", "<cmd>AerialToggle<CR>", desc = "Toggle Aerial outline" },
        },
    },

    -- Treesitter (keep)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        main = "nvim-treesitter.configs",
        opts = {
          highlight = { enable = true },
          ensure_installed = { "lua","python","go","java","rust","typescript","json","javascript","html","css" },
        },
      },

    -- Example: Rust tools (replaces rust.vim)
    {
        "simrat39/rust-tools.nvim",
        ft = { "rust" },
        config = function()
            require("rust-tools").setup({})
        end,
    },

    {
        "LazyVim/LazyVim",
        version = false,
        opts = {
            colorscheme = "tokyonight",
            defaults = {
                autocmds = false,
                keymaps = false,
                options = false,
            },
        },
    },

    { "folke/noice.nvim", enabled = false },
    ---  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
    { "folke/which-key.nvim", enabled = false },

}
