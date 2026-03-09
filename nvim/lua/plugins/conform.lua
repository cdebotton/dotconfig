require("conform").setup({
	formatters_by_ft = {
		css = { "oxfmt" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "oxfmt" },
		typescript = { "oxfmt" },
		svelte = { "oxlint", "oxfmt", "stylelint" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})
