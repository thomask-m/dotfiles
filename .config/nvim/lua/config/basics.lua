-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
--
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- setting up tabs to spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- map jk to esc
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('v', 'jk', '<esc>')

-- map ,vv
vim.keymap.set('n', '<leader>vv', vim.cmd.Ex)

-- show line number in editor
vim.opt.number = true

-- show current line highlight
vim.opt.cursorline = true
