require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	highlight = {
		enable = true,
	},
})

require("nvim-treesitter").install({ "javascript", "typescript", "svelte", "rust", "go", "lua", "css", "html", "sql" })

vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "rust", "svelte", "typescript", "javascript", "lua", "python", "css", "html", "sql" },
	callback = function()
		vim.treesitter.start()
	end,
})
