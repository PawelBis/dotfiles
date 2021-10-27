-- Config types:
-- vim.g  - global variables
-- vim.o  - global config
-- vim.bo - config local to buffer
-- vim.wo - config local to window

-- Auto install package manager - packer
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
  vim.cmd "packadd packer.nvim"
end

-- Theme
vim.cmd [[au ColorScheme * hi Normal ctermbg=None]]
vim.g.colors_name = 'dracula'
vim.o.guifont = "JetBrainsMono Nerd Font:h15"

-- Global tabs
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Numbers
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true

vim.g.cursorhold_updatetime = 100
