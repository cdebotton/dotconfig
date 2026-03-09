local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Breakpoint Condition" })

vim.keymap.set("n", "<leader>db", function()
	dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<leader>dc", function()
	dap.continue()
end, { desc = "Run/Continue" })

vim.keymap.set("n", "<leader>da", function()
	dap.continue({ before = get_args })
end, { desc = "Run with Args" })

vim.keymap.set("n", "<leader>dC", function()
	dap.run_to_cursor()
end, { desc = "Run to Cursor" })

vim.keymap.set("n", "<leader>dg", function()
	dap.goto_()
end, { desc = "Go to Line (No Execute)" })

vim.keymap.set("n", "<leader>dj", function()
	dap.down()
end, { desc = "Down" })

vim.keymap.set("n", "<leader>dk", function()
	dap.up()
end, { desc = "Up" })

vim.keymap.set("n", "<leader>dl", function()
	dap.run_last()
end, { desc = "Run Last" })

vim.keymap.set("n", "<leader>dP", function()
	dap.pause()
end, { desc = "Pause" })

vim.keymap.set("n", "<leader>dr", function()
	dap.repl.toggle()
end, { desc = "Toggle REPL" })

vim.keymap.set("n", "<leader>ds", function()
	dap.session()
end, { desc = "Session" })

vim.keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate" })

vim.keymap.set("n", "<leader>dw", function()
	require("dap.ui.widgets").hover()
end, { desc = "Widgets" })

vim.keymap.set("n", "<leader>du", function()
	dapui.toggle({})
end, { desc = "Toggle DAP UI" })

vim.keymap.set("n", "<leader>dN", function()
	vim.ui.input({ prompt = "Services (space seperated): " }, function(input)
		if not input or input == "" then
			return
		end
		vim.cmd("DapNew " .. input)
	end)
end)

-- Conditional keymaps that only work when debugging is active
-- Change these to customize the keys
local debug_keys = {
	step_over = "<Right>",
	step_out = "<Up>",
	step_into = "<Down>",
	continue = "<Space>",
}

local debugging_keymaps_set = false
local saved_keymaps = {}

local function save_keymap(key)
	local existing = vim.fn.maparg(key, "n", false, true)
	if existing and existing.lhs then
		saved_keymaps[key] = existing
	else
		saved_keymaps[key] = nil
	end
end

local function restore_keymap(key)
	pcall(vim.keymap.del, "n", key)
	local saved = saved_keymaps[key]
	if saved then
		local opts = {
			noremap = saved.noremap == 1,
			silent = saved.silent == 1,
			expr = saved.expr == 1,
			nowait = saved.nowait == 1,
			desc = saved.desc,
		}
		if saved.callback then
			vim.keymap.set("n", key, saved.callback, opts)
		elseif saved.rhs then
			vim.keymap.set("n", key, saved.rhs, opts)
		end
	end
end

local function set_debugging_keymaps()
	if debugging_keymaps_set then
		return
	end
	debugging_keymaps_set = true

	-- Save existing keymaps before overwriting
	for _, key in pairs(debug_keys) do
		save_keymap(key)
	end

	vim.keymap.set("n", debug_keys.step_over, function()
		dap.step_over()
	end, { desc = "DAP Step Over" })

	vim.keymap.set("n", debug_keys.step_out, function()
		dap.step_out()
	end, { desc = "DAP Step Out" })

	vim.keymap.set("n", debug_keys.step_into, function()
		dap.step_into()
	end, { desc = "DAP Step Into" })

	vim.keymap.set("n", debug_keys.continue, function()
		dap.continue()
	end, { desc = "DAP Continue" })
end

local function clear_debugging_keymaps()
	if not debugging_keymaps_set then
		return
	end
	debugging_keymaps_set = false

	-- Restore original keymaps
	for _, key in pairs(debug_keys) do
		restore_keymap(key)
	end
end

-- Set keymaps when stopped at breakpoint
dap.listeners.after.event_stopped["dap_keymaps"] = function()
	set_debugging_keymaps()
end

-- Clear keymaps when debug session ends
dap.listeners.before.event_terminated["dap_keymaps"] = function()
	clear_debugging_keymaps()
end

dap.listeners.before.event_exited["dap_keymaps"] = function()
	clear_debugging_keymaps()
end
