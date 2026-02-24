-- ********************************************************************
-- Author: Shankar Nakai Goncalves dos Santos
--
-- OPTIONS
-- ********************************************************************

-- =====================================
-- == COMMON SETTINGS / BASIC OPTIONS ==
-- =====================================

-- Display / UI settings
vim.opt.wrap = true               -- Enable line wrapping
vim.opt.number = true              -- Show absolute line numbers
vim.opt.relativenumber = true      -- Show relative line numbers
vim.opt.title = true               -- Show file name in the title bar
vim.opt.wildmenu = true            -- Enhanced command-line completion
vim.opt.autoread = true            -- Automatically re-read changed files

-- No bells
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = ''

-- Backup / swap
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Ignore patterns for filename completion
vim.opt.wildignore:append {
  '*.zip',
  '*.tar.gz',
  '*.tar.bz2',
  '*.rar',
  '*.tar.xz',
  '*.swp',
  '*.bak',
  '*~',
  '._*',
  '*.pyc',
  '*__pycache__*',
  '*.egg-info',
  '*.class'
}

-- History / undo
vim.opt.history = 1000             -- Remember more commands
vim.opt.undolevels = 1000          -- Many undo levels

-- Searching
vim.opt.hlsearch = true            -- Highlight search terms
vim.opt.incsearch = true           -- Incremental search
vim.opt.ignorecase = true          -- Case-insensitive search...
vim.opt.smartcase = true           -- ... but switch to case-sensitive if uppercase is used
vim.o.grepprg = "rg --vimgrep"

-- Indentation
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.expandtab = true           -- Use spaces instead of tabs

-- Folding
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

-- Use system clipboard for yank/paste
vim.opt.clipboard:append { 'unnamedplus', 'unnamed' }

-- Background
vim.opt.background = 'dark'
