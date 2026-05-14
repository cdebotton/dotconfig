require("conform").setup({
	formatters_by_ft = {
		css = { "stylelint" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "oxfmt", "eslint_d" },
		javascriptreact = { "oxfmt", "eslint_d" },
		typescript = { "oxfmt", "eslint_d" },
		typescriptreact = { "oxfmt", "eslint_d" },
		svelte = { "eslint_d", "oxfmt", "stylelint" },
		scss = { "stylelint" },
		less = { "stylelint" },
		sass = { "stylelint" },
		postcss = { "stylelint" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})
