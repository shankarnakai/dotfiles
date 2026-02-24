-- ********************************************************************
-- Author: Shankar Nakai Goncalves dos Santos
--
-- ********************************************************************

-- # Used to debug VIM client start
-- local old_start = vim.lsp.start
-- vim.lsp.start = function(config, opts)
--   print("LSP.start called for:", config.name, debug.traceback())
--   return old_start(config, opts)
-- end

require('config.options')   -- Basic options (like `vim.opt.xxx`)
require('config.keymaps')   -- Keymaps
require('config.autocmds')  -- Autocmds 
require('config.lazyvim')   -- Plugin manager setup & plugin configurations
