local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd({ "BufWritePost" }, {
	group = "__formatter__",
	command = ":FormatWrite",
})

local function show_diagnostics()
	for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(winid).zindex then
			return
		end
	end
	vim.diagnostic.open_float({
		scope = "cursor",
		focusable = false,
		close_events = {
			"CursorMoved",
			"CursorMovedI",
			"BufHidden",
			"InsertCharPre",
			"WinLeave",
		},
	})
end

-- Show diagnostics on hover in normal mode
autocmd({ "CursorHold" }, {
	pattern = "*",
	callback = show_diagnostics,
})

-- Show diagnostics on hover in insert mode
autocmd({ "CursorHoldI" }, {
	pattern = "*",
	callback = show_diagnostics,
})
