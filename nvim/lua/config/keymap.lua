-- mapleader is set in `init.lua` because it should be set before `Lazy` is loaded
-----------------------------------------------------------
-- Keybindings
local keymap = vim.api.nvim_set_keymap
local noremaps = { noremap = true, silent = true }

vim.api.nvim_create_user_command("Google", function(o)
	local escaped = vim.uri_encode(o.args)
	local url = ("https://www.google.com/search?q=%s"):format(escaped)
	vim.ui.open(url)
end, { nargs = 1, desc = "just google it" })

vim.api.nvim_create_user_command("Godot", function(o)
	local escaped = vim.uri_encode(o.args)
	local url = ("https://docs.godotengine.org/en/stable/search.html?q=%s&check_keywords=yes&area=default"):format(
		escaped
	)
	vim.ui.open(url)
end, { nargs = 1, desc = "godot docs search" })

-- Improve .,!? with undo chain
keymap("i", ",", ",<C-g>u", {})
keymap("i", ".", ".<C-g>u", {})
keymap("i", "!", "!<C-g>u", {})
keymap("i", "?", "?<C-g>u", {})

-- Save jumps > 5 to jumplist
keymap("n", "k", '(v:count > 4 ? "m\'" . v:count : "") . \'gk\'', {
	noremap = true,
	expr = true,
	silent = true,
})
keymap("n", "j", '(v:count > 4 ? "m\'" . v:count : "") . \'gj\'', {
	noremap = true,
	expr = true,
	silent = true,
})

-- Bring Y inline with other commands
keymap("n", "Y", "y$", noremaps)

-- Better jumps
keymap("n", "n", "nzzzv", noremaps)
keymap("n", "N", "Nzzzv", noremaps)
keymap("n", "J", "mzJ'z", noremaps)
keymap("n", "*", "*zzzv", noremaps)
keymap("n", "#", "#zzzv", noremaps)
keymap("n", "<C-o>", "<C-o>zzzv", noremaps)
keymap("n", "<C-i>", "<C-i>zzzv", noremaps)

-- Clear highlighting with ESC
keymap("n", "<ESC>", ":noh<CR><ESC>", noremaps)
keymap("n", "s", "", noremaps)

-- Windows
keymap("n", "<C-w>v", "<C-w>v<C-w>l", noremaps)
keymap("n", "<C-w>o", "<C-w>v<C-w>l<cmd>Telescope find_files layout_config={width=0.8}<CR>", noremaps)

-- Debugging
keymap("n", "<C-l>", ":lua require('dap').step_over()<CR>", noremaps)
keymap("n", "<C-h>", ":lua require('dap').step_back()<CR>", noremaps)
keymap("n", "<C-j>", ":lua require('dap').step_into()<CR>", noremaps)
keymap("n", "<C-k>", ":lua require('dap').step_out()<CR>", noremaps)
keymap("n", "<C-.>", ":lua require('dap').down()<CR>", noremaps)
keymap("n", "<C-,>", ":lua require('dap').up()<CR>", noremaps)

-- Terminal
keymap("t", "<leader>tt", "<C-\\><C-n>:FloatermToggle<CR>", noremaps)

require("which-key").add({
	mode = { "n", "v" },
	{ "<leader><tab>", group = "Tabs" },

	{ "<leader>a", group = "Ai" },
	{ "<leader>aa", "<cmd>CodeCompanionActions<CR>", desc = "Actions" },
	{ "<leader>ap", "<cmd>CodeCompanion<CR>", desc = "Prompt" },
	{ "<leader>ac", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
	{ "<leader>aC", "<cmd>CodeCompanionCmd<CR>", desc = "Command" },

	{ "<leader>c", group = "Code" },
	{ "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", desc = "Code actions" },
	{ "<leader>cf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", desc = "Format" },
	{
		"<leader>cr",
		function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end,
		desc = "Rename",
		expr = true,
	},
	{ "<leader>ci", "<cmd>FzfLua lsp_incoming_calls<CR>", desc = "Calls" },
	{ "<leader>cd", ":lua vim.diagnostic.open_float()<CR>", desc = "Inline diagnostics" },
	{ "<leader>ct", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble global" },
	{ "<leader>cf", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble file" },
	{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", desc = "Swap cpp/h" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>tt", ":FloatermToggle<CR>", desc = "Terminal" },
	{ "<leader>tg", ":FloatermNew lazygit<CR>", desc = "Git" },
	{ "<leader>tr", ":set rnu!<CR>", desc = "Relative Numbers" },
	{ "<leader>tp", ":Yazi<CR>", desc = "Project Explorer" },
	{ "<leader>tn", ":Navbuddy<CR>", desc = "Navbuddy" },

	{ "<leader>d", group = "Debug" },
	{ "<leader>dc", ":lua require('dap').continue()<CR>", desc = "Start/Continue execution" },
	{ "<leader>dq", ":lua require('dap').close()<CR>", desc = "Quit execution" },
	{ "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
	{ "<leader>dd", ":lua require('dap').run_to_cursor()<CR>", desc = "Run to cursor" },
	{ "<leader>dp", group = "Profiler" },

	{ "<leader>f", group = "File/find" },
	{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "file" },
	{
		"<leader>fs",
		function()
			return ":Google "
		end,
		expr = true,
	},
	{
		"<leader>fg",
		function()
			return ":Godot "
		end,
		desc = "Godot Docs",
		expr = true,
	},

	{ "<leader>s", group = "Search" },
	{ "<leader>ss", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Workspace symbols" },
	{ "<leader>sS", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
	{ "<leader>sg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
	{ "<leader>sr", "<cmd>FzfLua resume<CR>", desc = "Resume last search" },

	{ "<leader>y", '"+y', desc = "Copy to clipboard" },
	{ "<leader>p", '"+p', desc = "Paste from clipboard" },
	{ "[", group = "Prev" },
	{ "]", group = "Next" },
	{ "g", group = "Goto" },
	{ "gr", "<cmd>FzfLua lsp_references<CR>", desc = "References" },
	{ "gd", "<cmd> lua vim.lsp.buf.definition()<CR>zz", desc = "Definition" },
	{ "gD", "<cmd> lua vim.lsp.buf.declaration()<CR>zz", desc = "Declaration" },
	{ "gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "Implementations" },
	{ "S", group = "Surround" },
	{ "sa", desc = "Add surround" },
	{ "sd", desc = "Delete surround" },
	{ "sr", desc = "Replace surround" },
	{ "sf", desc = "Find surround" },
	{ "sh", desc = "Highlight surround" },
	{ "z", group = "Fold" },
	{
		"<leader>b",
		group = "Buffer",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	{
		"<leader>w",
		group = "Windows",
		proxy = "<c-w>",
		expand = function()
			return require("which-key.extras").expand.win()
		end,
	},
	-- better descriptions
	{ "gx", desc = "Open with system app" },
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
