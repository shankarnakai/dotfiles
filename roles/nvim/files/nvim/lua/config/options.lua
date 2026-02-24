-- ********************************************************************
-- Author: Shankar Nakai Goncalves dos Santos
--
-- OPTIONS
-- ********************************************************************

-- =====================================
-- == COMMON SETTINGS / BASIC OPTIONS ==
-- =====================================

-- Enable syntax highlighting
-- (Neovim generally has `syntax on` by default, but you can force it)
vim.cmd('syntax enable')

-- Display / UI settings
vim.opt.wrap = true               -- Do not wrap lines
vim.opt.number = true              -- Show absolute line numbers
vim.opt.relativenumber = true      -- Show relative line numbers
vim.opt.ruler = true               -- Show cursor position in status bar
vim.opt.title = true               -- Show file name in the title bar
vim.opt.wildmenu = true            -- Enhanced command-line completion
vim.opt.laststatus = 2             -- Always display status line
vim.opt.autoread = true            -- Automatically re-read changed files

-- No bells
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.cmd('set t_vb=')               -- Disable beep

-- Encoding
vim.opt.encoding = 'utf-8'
vim.cmd('set fileencodings=')      -- Disable any file encoding conversions

-- Backup / swap
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Ignore patterns for filename completion, ctrlp, etc.
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

-- Indentation
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.shiftround = true        -- Uncomment if you want shift commands to use multiples of shiftwidth

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.expandtab = true           -- Use spaces instead of tabs

-- Folding
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

-- Use system clipboard for yank/paste
vim.opt.clipboard:append { 'unnamedplus', 'unnamed' }

-- Terminal colors / background
if vim.env.TERM and vim.env.TERM:match('256color') then
  vim.cmd("set t_ut=")
end
vim.opt.background = 'dark'

