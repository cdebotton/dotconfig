require("blink.cmp").setup({
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	completion = {
		ghost_text = { enabled = true },
	},
	keymap = {
		["<CR>"] = { "accept", "fallback" },
	},
})
