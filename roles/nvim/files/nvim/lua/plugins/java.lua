return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" }, -- only load for Java files
    dependencies = {
      -- You can optionally use Mason to install the JDTLS server
     -- {
     --   "mason-org/mason.nvim",
     --   config = true,
     -- },
     -- {
     --   "mason-org/mason-lspconfig.nvim",
     --   config = function()
     --     require("mason-lspconfig").setup({
     --       ensure_installed = { "jdtls" },
     --     })
     --   end,
     -- },
      -- Optional: for code completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      -- If you want Treesitter highlighting
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- 1. Find root of the project (using gradlew, mvnw, .git, etc.)
      local root_markers = { ".git", "mvnw", "gradlew", "build.gradle", "pom.xml" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == "" then
        return
      end

      -- 2. Setup workspace directory (unique to each project)
      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

      -- 3. Build the language server startup command
      -- Adjust this path to where JDTLS is installed (e.g., via Mason) 
      local jdtls_jar = vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
      local lombok_jar = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
      local config_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux"  -- or config_win, config_mac

      -- Make sure these exist and match your system’s Java/JDTLS layout
      local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. lombok_jar,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", jdtls_jar,
        "-configuration", config_dir,
        "-data", workspace_dir,
      }

      -- 4. Basic jdtls settings
      local jdtls = require("jdtls")
      local config = {
        cmd = cmd,
        root_dir = root_dir,
        settings = {
          java = {
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                "org.assertj.core.api.Assertions.*",
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
              },
            },
          },
        },
        -- If you’re using nvim-cmp
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        -- On_attach = function(client, bufnr) ... end  (keymaps, etc.)
      }

      -- 5. Start or attach JDTLS
      jdtls.start_or_attach(config)
    end,
  },
}
