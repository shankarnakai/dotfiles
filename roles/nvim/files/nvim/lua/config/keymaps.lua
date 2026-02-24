-- ********************************************************************
-- Author: Shankar Nakai Goncalves dos Santos
--
-- KEY MAPS
-- ********************************************************************

-- =====================================
-- == LEADER AND KEYMAPS ==
-- =====================================
vim.g.mapleader = ","

-- Quickly edit init.lua (equivalent to :e $MYVIMRC)
vim.keymap.set('n', '<leader>,', ':e $MYVIMRC<CR>', { silent = true })

-- Reload config (if you want)
vim.keymap.set("n", "<leader>V", function()
    local ok, err = pcall(dofile, vim.env.MYVIMRC)
    if ok then
        vim.notify("Config reloaded successfully!", vim.log.levels.INFO)
    else
        vim.notify("Error reloading config:\n" .. err, vim.log.levels.ERROR)
    end
end, { desc = "Reload config", silent = true })

-- Toggle between relative and absolute line numbers
local function toggle_line_numbers()
    local is_relative = vim.wo.relativenumber
    vim.wo.number = true
    vim.wo.relativenumber = not is_relative
end

-- Create a user command to call the function
vim.api.nvim_create_user_command('ToggleLineNumbers', toggle_line_numbers, {})


-- Function to trim trailing whitespace in the whole buffer
local function trim_whitespace()
  vim.cmd([[%s/\s\+$//e]])
end

-- Create the command :TrimWhiteSpace
vim.api.nvim_create_user_command("TrimWhiteSpace", trim_whitespace, {})

-- :Rg command using fzf-lua live grep
vim.api.nvim_create_user_command("Rg", function(opts)
  require("fzf-lua").grep({ search = opts.args })
end, { nargs = "?", desc = "Ripgrep search via fzf-lua" })


-- Wrapped lines goes down/up to next row, rather than next line in file.
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true, desc = "Move down by screen line" })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true, desc = "Move up by screen line" })

-- Visual shifting (does not exit Visual mode)
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Shift left and reselect" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Shift right and reselect" })

-- Map gb and gB move between buffers
vim.keymap.set("n", "gb", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "gB", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })


-- keep the yanked text on paste
vim.keymap.set("x", "p", function()
  return 'pgv"' .. vim.v.register .. 'y'
end, { expr = true, noremap = true, desc = "Paste over selection without losing register" })

-- visual shifting (does not exit Visual mode)
vim.keymap.set("v", "//", function()
  -- Yank visual selection into register z
  vim.cmd('normal! "zy')

  -- Escape special characters in the yanked text
  local text = vim.fn.getreg("z")
  text = text:gsub("\\", "\\\\")
             :gsub("/", "\\/")
             :gsub("([%^%$%.%*%~%[%]])", function(c)
                  return "\\" .. c
             end)

  -- Set the search register and trigger search
  vim.fn.setreg("/", text)
  vim.cmd("normal! n")
end, { noremap = true, silent = true, desc = "Search for selected text" })


-- Normal mode: Move current line up/down
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })

-- Insert mode: Move current line and return to insert
vim.keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move line down (insert)" })
vim.keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move line up (insert)" })

-- Visual mode: Move selected lines and reselect
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- <leader>j/k for moving in normal and visual modes
vim.keymap.set("n", "<leader>j", ":m+1<CR>", { noremap = true, silent = true, desc = "Move line down (leader)" })
vim.keymap.set("n", "<leader>k", ":m-2<CR>", { noremap = true, silent = true, desc = "Move line up (leader)" })
vim.keymap.set("v", "<leader>j", ":m'>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down (leader)" })
vim.keymap.set("v", "<leader>k", ":m'<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up (leader)" })


-- Normal mode: Duplicate current line below
vim.keymap.set("n", "<leader>d", ":t.<CR>", { noremap = true, silent = true, desc = "Duplicate line below" })

-- Visual mode: Duplicate selected block below
vim.keymap.set("v", "<leader>d", ":t'>.<CR>gv=gv", { noremap = true, silent = true, desc = "Duplicate selection below" })
