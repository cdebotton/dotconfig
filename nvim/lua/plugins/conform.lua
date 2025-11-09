require("conform").setup({
	formatters_by_ft = {
		css = { "stylelint" },
		json = { "prettier" },
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "eslint_d", "prettier" },
		svelte = { "eslint_d", "prettier", "stylelint" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})
