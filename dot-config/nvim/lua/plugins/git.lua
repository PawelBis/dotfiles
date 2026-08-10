return {
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ibhagwan/fzf-lua",
			"echasnovski/mini.icons",
		},
		opts = {
			picker = "fzf-lua",
			-- octo escapes hyphens in these keys itself, so no `%-` here
			ssh_aliases = { ["github-personal"] = "github.com" },
			-- right side of review diffs reads from disk, so LSP attaches
			use_local_fs = true,
			file_panel = {
				-- octo defaults to nvim-web-devicons, we use mini.icons
				icons = function(name)
					return require("mini.icons").get("file", name)
				end,
			},
		},
		keys = {
			{ "<leader>oi", "<cmd>Octo issue list<CR>", desc = "List issues" },
			{ "<leader>op", "<cmd>Octo pr list<CR>", desc = "List pull requests" },
			{ "<leader>od", "<cmd>Octo discussion list<CR>", desc = "List discussions" },
			{ "<leader>on", "<cmd>Octo notification list<CR>", desc = "List notifications" },
			{
				"<leader>os",
				function()
					require("octo.utils").create_base_search_command({ include_current_repo = true })
				end,
				desc = "Search GitHub",
			},
		},
	},
}
