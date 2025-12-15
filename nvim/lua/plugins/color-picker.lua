-- require("oklch-color-picker").setup({})
--
-- vim.keymap.set("n", "<leader>v", function()
-- 	require("oklch-color-picker").pick_under_cursor()
-- end, { desc = "Color pick under cursor" })
--

local ccc = require("ccc")

ccc.setup({
	pickers = { ccc.picker.css_oklch, ccc.picker.css_hex },
	inputs = { ccc.input.oklch, ccc.input.hex },
	outputs = { ccc.output.css_oklch, ccc.output.hex },
	highlight_mode = "background",
	highlighter = {
		auto_enable = true,
	},
})
vim.keymap.set("n", "<leader>v", vim.cmd.CccPick)
