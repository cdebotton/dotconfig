-- Basic keymap
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>Q", ":quitall<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { noremap = true, silent = true })

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename" })

vim.keymap.set("n", "<leader>ar", function()
	-- local handle = io.popen("aws-vault exec sandbox-admin -- env | grep -E '^AWS_'")
	local handle = io.popen("aws-vault export --format=env sandbox-admin")
	if handle then
		local result = handle:read("*a")
		handle:close()

		local keys = {}
		for line in result:gmatch("[^\r\n]+") do
			local key, value = line:match("^([^=]+)=(.*)$")
			if key and value then
				table.insert(keys, key)
				vim.fn.setenv(key, value)
			end
		end

		vim.cmd("luafile ~/.config/nvim/init.lua")
		vim.notify(
			"AWS environment variables (" .. table.concat(keys, ", ") .. ") loaded and plugins reloaded",
			vim.log.levels.INFO
		)
	else
		vim.notify("Failed to execute aws-vault command", vim.log.levels.ERROR)
	end
end, { desc = "Load AWS env vars and reload plugins" })
