local dap = require("dap")
local dapui = require("dapui")

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▸", texthl = "DiagnosticInfo", numhl = "" })

dapui.setup({
	layouts = {
		{
			elements = { "scopes", "breakpoints", "stacks", "watches" },
			size = 40,
			position = "left",
		},
		{
			elements = { "repl", "console" },
			size = 10,
			position = "bottom",
		},
	},
	controls = { enabled = true },
	floating = { border = "rounded" },
})

-- Auto open/close UI on start/stop
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Virtual text
require("nvim-dap-virtual-text").setup({
	commented = true,
	virt_text_pos = "inline",
	highlight_changed_variables = true,
})

require("plugins.dap.keymap")
require("plugins.dap.adapters")
