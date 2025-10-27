require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	highlight = {
		enable = true,
	},
})

require("nvim-treesitter").install({ "javascript", "typescript", "svelte", "rust", "go", "lua", "css", "sql", "html" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "rust", "svelte", "typescript", "javascript", "lua", "python", "css", "sql", "html" },
	callback = function()
		vim.treesitter.start()
	end,
})
