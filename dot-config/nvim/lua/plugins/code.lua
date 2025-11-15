return {
	{
		"mhartington/formatter.nvim",
		config = function()
			-- local util = require("formatter.util")
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = { require("formatter.filetypes.lua").stylua },
					go = { require("formatter.filetypes.go").gofmt },
					gdscript = {
						function()
							return {
								exe = "gdformat",
								args = { "-" },
								stdin = true,
							}
						end
					},
					python = { require("formatter.filetypes.python").ruff },
					rust = { require("formatter.filetypes.rust").rustfmt },
					sh = { require("formatter.filetypes.sh").shfmt },
					zsh = { require("formatter.filetypes.zsh").beautysh },
					["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				go = { "golangcilint" },
				gdscript = { "gdlint" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()
				end,
			})
		end,
	},
}
