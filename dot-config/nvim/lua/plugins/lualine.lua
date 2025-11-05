return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"SmiteshP/nvim-navic",
		},
		config = function()
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

			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal} >",
				-- The following line is needed to fix the background color
				-- Set it to the lualine section you want to use
				hl_group = "lualine_c_normal",
			})

			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", file_status = true, path = 1 }, { symbols.get, cond = symbols.has } },
					lualine_d = { { symbols.get, cond = symbols.has } },
					lualine_x = {
						"searchcount",
						"selectioncount",
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = "#ff9e64" },
						},
					},
					lualine_y = { "lsp_status", "filetype" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
