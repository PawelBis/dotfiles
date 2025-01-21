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

	-- Color schemes
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd.colorscheme("oxocarbon")
		end,
	},
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
				},
			})
		end,
	},
	{
		"mhartington/formatter.nvim",
		config = function()
			-- local util = require("formatter.util")
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = { require("formatter.filetypes.lua").stylua },
					["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"SmiteshP/nvim-navic",
		},
		config = function()
			local function navis_is_avail()
				return require("nvim-navic").is_available(vim.fn.bufnr())
			end
			navis_is_avail()

			local function navic_get_location()
				return require("nvim-navic").get_location({ click = true }, vim.fn.bufnr())
			end

			local function context()
				local buffname = vim.fn.expand("%")
				local buffname_to_context = {}
				buffname_to_context["Trouble"] = "Diagnostics"
				buffname_to_context["NvimTree_1"] = "File Explorer"
				local ctx = buffname_to_context[buffname]
				if ctx == nil then
					ctx = "Context"
				end

				return ctx
			end

			require("lualine").setup({
				option = { theme = "oxocarbon" },
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", file_status = true, path = 1 } },
					lualine_x = { "lsp_progress", "filetype" },
					lualine_y = {},
					lualine_z = {},
				},
				winbar = {
					lualine_a = { { context } },
					lualine_b = { { navic_get_location, cond = navic_is_avail } },
				},
				inactive_winbar = {
					lualine_a = { { context } },
				},
			})
		end,
	},
}
