require("mini.icons").setup()
require("nvim-web-devicons").setup()
require("oil").setup({
	default_file_explorer = true,
	view_options = {
		show_hidden = true,
	},
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
		["<C-x>"] = { "actions.select", opts = { horizontal = true } },
		["<C-r>"] = "actions.refresh",
	},
})
