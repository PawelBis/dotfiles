return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			-- GO
			dap.adapters.go = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/Tools/vscode-go/extension/dist/debugAdapter.js" },
			}
			dap.configurations.go = {
				{
					type = "go",
					name = "Debug",
					request = "launch",
					showLog = true,
					program = "${file}",
					dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
					arg,
				},
				{
					type = "go",
					name = "Debug2",
					request = "launch",
					showLog = true,
					program = "${file}",
					dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
					arg,
				},
			}

			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

				-- On windows you may have to uncomment this:
				-- detached = false,
			}
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Define breakpoint hl groups and icons
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })

			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#c53b53", bold = true })
			vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bold = true })
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bold = true })
		end,
	},
}
