vim.g.mapleader = " "
vim.g.completion = true

vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.winborder = "rounded"

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/catppuccin/nvim",
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/gbprod/yanky.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/nvim-nio",
})

vim.cmd([[
	colorscheme catppuccin-mocha
]])

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("svelte")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")

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

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"typescript",
		"svelte",
		"rust",
		"go",
		"lua",
		"css",
		"sql",
		"html",
		"css",
	},
	autoinstall = true,
	highlight = {
		enable = true,
	},
})

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

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave", "TextChanged" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("conform").setup({
	formatters_by_ft = {
		css = { "stylelint" },
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})

vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>Q", ":quitall<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

require("yanky").setup()
require("mini.icons").setup()
require("nvim-web-devicons").setup()
require("oil").setup()
require("telescope").setup()
require("which-key").setup({
	preset = "helix",
})

require("dapui").setup()
