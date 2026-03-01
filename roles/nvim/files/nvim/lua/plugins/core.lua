return {
    -- LazyVim configuration
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

    -- Lualine theme customization (LazyVim provides lualine, we just override opts)
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "horizon",
                section_separators = "",
                component_separators = "",
            },
        },
    },

    -- Custom fzf-lua keymaps (LazyVim fzf extra provides the plugin, we add keymaps)
    {
        "ibhagwan/fzf-lua",
        keys = {
            { "<C-p>",      "<cmd>FzfLua files<cr>",       desc = "Find files" },
            { "<leader>fg", "<cmd>FzfLua live_grep<cr>",    desc = "Live grep" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>",      desc = "Find buffers" },
            { "<leader>fh", "<cmd>FzfLua help_tags<cr>",    desc = "Help tags" },
            { "<leader>gc", "<cmd>FzfLua git_commits<cr>",  desc = "Git commits" },
        },
    },

    -- File explorer keymap (LazyVim provides neo-tree, we add <C-f> shortcut)
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            { "<C-f>", "<cmd>Neotree toggle reveal<CR>", desc = "Toggle file explorer" },
        },
    },

    -- Buffer delete (LazyVim uses mini.bufremove, but user prefers X -> Bdelete)
    {
        "famiu/bufdelete.nvim",
        keys = {
            { "X", "<cmd>Bdelete<CR>", desc = "Delete current buffer" },
        },
    },

    -- Neogit (magit-like git interface, not provided by LazyVim)
    {
        "NeogitOrg/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<CR>", desc = "Neogit status" },
        },
        config = true,
    },

    -- Disable unwanted LazyVim plugins
    { "folke/noice.nvim", enabled = false },
    { "folke/which-key.nvim", enabled = false },

    -- Keep markdown rendering but show backticks instead of hiding them
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            anti_conceal = {
                enabled = true,
            },
        },
    },
}
