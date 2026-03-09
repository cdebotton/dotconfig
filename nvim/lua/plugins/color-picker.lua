require("oklch-color-picker").setup({})

vim.keymap.set("n", "<leader>vC", function()
	require("oklch-color-picker").pick_under_cursor()
end, { desc = "Open OKLCH color picker" })

local ccc = require("ccc")

ccc.setup({
	highlight_mode = "background",
	highlighter = {
		auto_enable = true,
	},
})
vim.keymap.set("n", "<leader>vc", vim.cmd.CccPick, { desc = "Open color picker" })
