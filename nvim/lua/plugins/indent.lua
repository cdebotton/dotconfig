vim.api.nvim_set_hl(0, "IndentMauve", { fg = "#cba6f7" })
vim.api.nvim_set_hl(0, "IndentMauveUnderline", { sp = "#cba6f7", underdouble = true })

vim.api.nvim_set_hl(0, "IndentPink", { fg = "#f5c2e7" })
vim.api.nvim_set_hl(0, "IndentPinkUnderline", { sp = "#f5c2e7", underdouble = true })

vim.api.nvim_set_hl(0, "IndentSapphire", { fg = "#74c7ec" })
vim.api.nvim_set_hl(0, "IndentSapphireUnderline", { sp = "#74c7ec", underdouble = true })

vim.api.nvim_set_hl(0, "IndentBlue", { fg = "#89b4fa" })
vim.api.nvim_set_hl(0, "IndentBlueUnderline", { sp = "#89b4fa", underdouble = true })

vim.api.nvim_set_hl(0, "IndentLavender", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "IndentLavenderUnderline", { sp = "#b4befe", underdouble = true })

require("blink.indent").setup({
	scope = {
		enabled = true,
		char = "▎",
		priority = 1000,
		highlights = { "IndentBlue", "IndentLavender", "IndentMauve", "IndentSapphire" },
		underline = {
			enabled = true,
			highlights = {
				"IndentBlueUnderline",
				"IndentLavenderUnderline",
				"IndentMauveUnderline",
				"IndentSapphireUnderline",
			},
		},
	},
})
