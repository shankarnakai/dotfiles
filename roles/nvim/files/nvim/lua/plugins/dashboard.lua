return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local logo = [[
      ███████╗██╗  ██╗ █████╗ ███╗   ██╗██╗  ██╗ █████╗ ██████╗     ███╗   ██╗ █████╗ ██╗  ██╗ █████╗ ██╗
      ██╔════╝██║  ██║██╔══██╗████╗  ██║██║ ██╔╝██╔══██╗██╔══██╗    ████╗  ██║██╔══██╗██║ ██╔╝██╔══██╗██║
      ███████╗███████║███████║██╔██╗ ██║█████╔╝ ███████║██████╔╝    ██╔██╗ ██║███████║█████╔╝ ███████║██║
      ╚════██║██╔══██║██╔══██║██║╚██╗██║██╔═██╗ ██╔══██║██╔══██╗    ██║╚██╗██║██╔══██║██╔═██╗ ██╔══██║██║
      ███████║██║  ██║██║  ██║██║ ╚████║██║  ██╗██║  ██║██║  ██║    ██║ ╚████║██║  ██║██║  ██╗██║  ██║██║
      ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝

      WELCOME, ByteMaster!
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")

    dashboard.config.opts.noautocmd = true
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file",       "<cmd>FzfLua files<cr>"),
      dashboard.button("n", "  New file",        [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", "  Recent files",    "<cmd>FzfLua oldfiles<cr>"),
      dashboard.button("g", "  Find text",       "<cmd>FzfLua live_grep<cr>"),
      dashboard.button("c", "  Config",          "<cmd>FzfLua files cwd=~/.config/nvim<cr>"),
      dashboard.button("s", "  Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      dashboard.button("x", "  Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "  Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", "  Quit",            "<cmd> qa <cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    dashboard.opts.layout[1].val = 8

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function() end,
    })

    alpha.setup(dashboard.config)
  end,
}

--- https://www.lazyvim.org/extras/ui/alpha
