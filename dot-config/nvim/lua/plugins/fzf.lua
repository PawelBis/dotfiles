return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			local fzf_lua = require("fzf-lua")
			fzf_lua.register_ui_select()
			local config = require("fzf-lua.config")
			local actions = require("trouble.sources.fzf").actions
			config.defaults.actions.files["ctrl-q"] = actions.open
		end,
	},
}
