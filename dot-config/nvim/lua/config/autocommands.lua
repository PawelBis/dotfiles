vim.api.nvim_create_augroup("__formatter__", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = "__formatter__",
	command = ":FormatWrite",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "help",
	command = "wincmd L",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	command = "wincmd =",
})
