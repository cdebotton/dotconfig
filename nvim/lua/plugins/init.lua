local M = {}

function M.install()
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/antoinemadec/FixCursorHold.nvim",
		"https://github.com/nvim-telescope/telescope.nvim",
		"https://github.com/smjonas/live-command.nvim",
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
		"https://github.com/tree-sitter/tree-sitter-go",
		"https://github.com/catppuccin/nvim",
		{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/mfussenegger/nvim-lint",
		"https://github.com/stevearc/conform.nvim",
		"https://github.com/gbprod/yanky.nvim",
		"https://github.com/stevearc/oil.nvim",
		"https://github.com/nvim-neotest/nvim-nio",
		"https://github.com/nvim-mini/mini.nvim",
		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/folke/which-key.nvim",
		"https://github.com/mfussenegger/nvim-dap",
		"https://github.com/theHamsta/nvim-dap-virtual-text",
		"https://github.com/rcarriga/nvim-dap-ui",
		"https://github.com/leoluz/nvim-dap-go",
		"https://github.com/fredrikaverpil/neotest-golang",
		"https://github.com/marilari88/neotest-vitest",
		"https://github.com/mrcjkb/rustaceanvim",
		"https://github.com/nvim-neotest/neotest",
		"https://github.com/christoomey/vim-tmux-navigator",
		"https://github.com/windwp/nvim-autopairs",
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/mason-org/mason-lspconfig.nvim",
		"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
		"https://github.com/jay-babu/mason-nvim-dap.nvim",
		"https://github.com/kylechui/nvim-surround",
		"https://github.com/jake-stewart/multicursor.nvim",
		"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
		"https://github.com/windwp/nvim-ts-autotag",
		"https://github.com/saghen/blink.indent",
		"https://github.com/folke/todo-comments.nvim",
		"https://github.com/b0o/SchemaStore.nvim",
	})
end

function M.setup()
	require("plugins.telescope")
	require("plugins.lsp")
	require("plugins.dap")
	require("plugins.neotest")
	require("plugins.autopairs")
	require("plugins.blink")
	require("plugins.lint")
	require("plugins.live-command")
	require("plugins.treesitter")
	require("plugins.conform")
	require("plugins.mason")
	require("plugins.yanky")
	require("plugins.oil")
	require("plugins.whick-key")
	require("plugins.vim-tmux-navigator")
	require("plugins.surround")
	require("plugins.multicursor")
	require("plugins.diagnostics")
	require("plugins.nvim-ts-autotag")
	require("plugins.indent")
	require("plugins.todo")
end

return M
