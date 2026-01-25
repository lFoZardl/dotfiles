return {
	-- [[
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
        dapui.setup()

		-- adapters
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
		}

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "/home/fozard/.local/share/nvim/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		-- configurations
		dap.configurations.zig = {
			{
				name = "Launch",
				type = "codelldb",
				request = "launch",
				program = function()
					local path = vim.fn.input({
						prompt = "Path to executable: ",
						default = vim.fn.getcwd() .. "/zig-out/bin/",
						completion = "file",
					})
					return (path and path ~= "") and path or dap.ABORT
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				arg = {},
			},
		}

		-- dap-ui
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

		-- dap
		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end)
		vim.keymap.set("n", "<F10>", function()
			dap.step_over()
		end)
		vim.keymap.set("n", "<F11>", function()
			dap.step_into()
		end)
		vim.keymap.set("n", "<F12>", function()
			dap.step_out()
		end)
		vim.keymap.set("n", "<Leader>b", function()
			dap.toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>B", function()
			dap.set_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		vim.keymap.set("n", "<Leader>dr", function()
			dap.repl.open()
		end)
		vim.keymap.set("n", "<Leader>dl", function()
			dap.run_last()
		end)
	end,
	--]]
}
