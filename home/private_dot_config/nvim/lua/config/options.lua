-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Tabs & indentation (carry forward from vimrc)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Whitespace visualization
vim.opt.list = true
vim.opt.listchars = { eol = "¬", tab = ">-", trail = "~", extends = ">", precedes = "<", nbsp = "·" }
