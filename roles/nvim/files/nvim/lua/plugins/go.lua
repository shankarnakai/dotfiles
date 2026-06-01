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

    -- Use gci for import ordering, gofumpt for formatting
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gci", "gofumpt" },
            },
            formatters = {
                gci = {
                    command = "gci",
                    args = {
                        "write",
                        "--skip-generated",
                        "--section", "standard",
                        "--section", "default",
                        "--section", "prefix(fetchrewards.com)",
                        "--section", "prefix(bitbucket.org/fetchrewards)",
                        "--section", "prefix(github.com/fetch-rewards)",
                        "--section", "prefix(github.com/fetch-rewards/button-transaction-service)",
                        "$FILENAME",
                    },
                    stdin = false,
                },
            },
        },
    },
}
