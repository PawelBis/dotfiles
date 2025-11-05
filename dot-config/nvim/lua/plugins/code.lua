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
					rust = { require("formatter.filetypes.rust").rustfmt },
					sh = { require("formatter.filetypes.sh").shfmt },
					zsh = { require("formatter.filetypes.zsh").beautysh },
					["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
				},
			})
		end,
	},
}
