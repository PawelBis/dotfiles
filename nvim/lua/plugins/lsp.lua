return {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		-- use a release tag to download pre-built binaries
		version = "1.*",
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "enter" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = true } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"saghen/blink.cmp",
		},
		opts = {
			lsp = { auto_attach = true },
			inlay_hints = { enabled = true },
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			local in_capabilities = require("blink.cmp").get_lsp_capabilities()
			local lsp = require("lspconfig")

			-- Rust
			lsp.rust_analyzer.setup({
				capabilities = in_capabilities,
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = false,
						},
						cargo = {
							features = "all",
						},
						check = {
							features = "all",
						},
					},
				},
			})

			-- Lua
			lsp.lua_ls.setup({
				capabilities = in_capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- C++
			lsp.clangd.setup({
				capabilities = in_capabilities,
			})

			-- Zig
			lsp.zls.setup({ capabilities = in_capabilities })

			-- Godot
			lsp.gdscript.setup({ capabilities = in_capabilities })

			-- Go
			lsp.gopls.setup({ capabilities = in_capabilities })

			-- Python
			lsp.gopls.setup({ capabilities = in_capabilities })

			-- JS TS
			lsp.ts_ls.setup({ capabilities = in_capabilities, filetypes = { "javascript", "typescript" } })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = "TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"rust",
					"c",
					"cpp",
					"go",
					"python",
					"sql",
					"bash",
					"zig",
					"vim",
					"regex",
					"lua",
					"markdown",
					"markdown_inline",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})
		end,
	},
}
