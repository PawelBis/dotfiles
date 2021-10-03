-- Config types:
-- vim.g  - global variables
-- vim.o  - global config
-- vim.bo - config local to buffer
-- vim.wo - config local to window


vim.wo.number = true
vim.wo.relativenumber = true

-- Auto install package manager - packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Install packages
require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'dracula/vim'
end)

-- nvim-cmp autocomplete setup
vim.g.completeopt = "menu,menuone,noselect"
require'cmp'.setup{
	sources = {
		{ name = 'nvim_lsp' }
	}
}

-- Lua LSP setup
local lua_lsp_path = "C:/tools/lua-language-server/"
local lua_lsp_bin = "C:/tools/lua-language-server/bin/Windows/lua-language-server.exe"
require'lspconfig'.sumneko_lua.setup{
	cmd = { lua_lsp_bin, "-E", lua_lsp_path .. "/main.lua"};
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				globals = {'vim', 'use'},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

require'lspconfig'.rust_analyzer.setup{}


-- Fix background in dracula theme
vim.cmd [[au ColorScheme * hi Normal ctermbg=None]]
vim.g.colors_name = 'dracula'


-- Modes:
-- i - insert
-- n - normal
-- v - visual
-- keymap('mode', 'keybinding', 'mapped binding', { options })
-- options for example: '{ noremap = true }'
local keymap = vim.api.nvim_set_keymap
local noremap = { noremap = true }
keymap('i', 'jk', '<ESC>', {})
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', noremap)
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', noremap)
keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', noremap)
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', noremap)
keymap('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', noremap)
keymap('n', '<C-k>',  '<cmd>lua vim.lsp.buf.signature_help()<CR>', noremap)
keymap('n', '<C-p>',  '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', noremap)
keymap('n', '<C-n>',  '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', noremap)
