-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Visuals
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
-- vim.o.signcolumn = "number"
vim.o.splitbelow = true
-- vim.o.laststatus = 3
vim.o.cursorline = true
-- Add match pair for '<' and '>'
vim.o.matchpairs = vim.o.matchpairs .. ",<:>"
-- Add match pair for `=` and `;`
vim.o.matchpairs = vim.o.matchpairs .. ",=:;"
-- Change updatetime so CursorHold autocommands trigger faster
vim.o.updatetime = 200

-- Set relative numbers + number of current line instead of 0
vim.o.number = true
vim.o.relativenumber = true

-- Set case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable mouse support
vim.opt.mouse = ""
vim.opt.mousescroll = "ver:0,hor:0"

-- Folding setup
vim.wo.foldlevel = 20
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Disable virtual test diagnostics
vim.diagnostic.config({
	virtual_text = false,
	float = {
		source = true,
		border = "rounded", -- none/single/double/rounded/solid/shadow
	},
})

vim.o.colorcolumn = "100"
