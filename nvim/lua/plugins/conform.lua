require("conform").setup({
	formatters_by_ft = {
		css = { "stylelint" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "oxfmt", "oxlint" },
		typescript = { "oxfmt", "oxlint" },
		svelte = { "eslint_d", "prettierd", "stylelint" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})
