local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_ns)

require("neotest").setup({
	status = { virtual_text = true },
	output = { open_on_run = true },
	adapters = {
		require("neotest-vitest")({
			filter_dir = function(name, rel_path, root)
				return name ~= "node_modules"
			end,
		}),
		require("rustaceanvim.neotest"),
		require("neotest-golang")({
			runner = "gotestsum",
		}),
	},
})

-- Test keybindings
vim.keymap.set("n", "<leader>ta", function()
	require("neotest").run.attach()
end, { desc = "Attach to Test (Neotest)" })

vim.keymap.set("n", "<leader>tt", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run File (Neotest)" })

vim.keymap.set("n", "<leader>tT", function()
	require("neotest").run.run(vim.uv.cwd())
end, { desc = "Run All Test Files (Neotest)" })

vim.keymap.set("n", "<leader>tr", function()
	require("neotest").run.run()
end, { desc = "Run Nearest (Neotest)" })

vim.keymap.set("n", "<leader>tl", function()
	require("neotest").run.run_last()
end, { desc = "Run Last (Neotest)" })

vim.keymap.set("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle Summary (Neotest)" })

vim.keymap.set("n", "<leader>to", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Show Output (Neotest)" })

vim.keymap.set("n", "<leader>tO", function()
	require("neotest").output_panel.toggle()
end, { desc = "Toggle Output Panel (Neotest)" })

vim.keymap.set("n", "<leader>tS", function()
	require("neotest").run.stop()
end, { desc = "Stop (Neotest)" })

vim.keymap.set("n", "<leader>tw", function()
	require("neotest").watch.toggle(vim.fn.expand("%"))
end, { desc = "Toggle Watch (Neotest)" })

vim.keymap.set("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug Nearest" })
