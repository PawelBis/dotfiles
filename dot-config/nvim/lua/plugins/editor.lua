return {
	-- which-key helps you remember key bindings by showing a popup
	-- with the active keybindings of the command you started typing.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
		},
		-- Hydra mode for Windows manipulation
		keys = {

			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
				wk.register(opts.defaults)
			end
		end,
	},

	-- Yazi
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		opts = {
			open_for_directories = true,
			keymaps = {
				show_help = "<F1>",
			},
		},
	},
	-- Oil
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	-- Color schemes
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.opt.background = "dark"
			-- vim.cmd.colorscheme("oxocarbon")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			local noice = require("noice")
			local notify = require("notify").setup({
				stages = "static",
			})
			noice.setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						-- ["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = false,
					command_palette = true,
					long_message_to_split = false,
					inc_rename = true,
				},
				messages = {
					view = "notify",
				},
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require("ibl").setup()
		end,
	},
}
