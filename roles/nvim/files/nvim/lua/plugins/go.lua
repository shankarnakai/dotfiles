return {
    -- Enable gofumpt in gopls
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            gofumpt = true,
                        },
                    },
                },
            },
        },
    },

    -- Use goimports for organizing imports on save
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },
            },
        },
    },
}
