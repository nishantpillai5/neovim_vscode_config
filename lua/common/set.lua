local HOME = require('common.env').HOME

vim.opt.wrap = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.list = true
vim.opt.listchars:append 'space:⋅'
-- vim.opt.listchars:append "eol:↴"

-- Undo
vim.opt.undofile = true
vim.opt.undodir = HOME .. '/.nvim/undodir'

-- Backups
-- vim.opt.backup = false
-- vim.opt.swapfile = false
vim.opt.backupdir = HOME .. '/.nvim/backupdir'

-- Search
-- vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Colors
vim.opt.termguicolors = true

-- Scrolling
vim.opt.scrolloff = 8

-- Leader
vim.g.mapleader = ' '

-- jk as esc
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Split windows
vim.o.splitright = true
vim.o.splitbelow = true

-- Force show tabline
vim.o.showtabline = 2

-- Use system clipboard
-- vim.o.clipboard = "unnamedplus"

-- Faster operation
-- vim.opt.updatetime = 300

-- Disable browser input plugin autostart
vim.g.nvim_ghost_autostart = 0
