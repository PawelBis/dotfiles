vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.wrapmargin = 80
vim.opt_local.linebreak = true

local idhl = vim.api.nvim_get_hl(0, { name = "Identifier" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "none", fg = idhl.fg })

vim.diagnostic.config({
	virtual_text = {
		prefix = "|",
		spacing = 0,
	},
	underline = false,
	signs = false,
	update_in_insert = true,
})
