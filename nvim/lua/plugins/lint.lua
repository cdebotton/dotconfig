require("lint").linters_by_ft = {
	markdown = { "vale" },
	lua = { "luacheck" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	svelte = { "eslint_d", "stylelint" },
	css = { "stylelint" },
	scss = { "stylelint" },
	less = { "stylelint" },
	sass = { "stylelint" },
	postcss = { "stylelint" },
	go = { "golangcilint" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave", "BufEnter", "TextChanged" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
