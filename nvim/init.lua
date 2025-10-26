-- Vim settings
vim.g.mapleader = " "
vim.g.completion = true

vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.splitright = true
vim.o.splitbelow = true

-- Add packages
vim.pack.add({
	"https://github.com/smjonas/live-command.nvim",
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
	"https://github.com/theHamsta/nvim-dap-virtual-text",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/windwp/nvim-autopairs",
})

-- Setup Live Command for previewing motions
require("live-command").setup({
	enable_highlighting = true,
	inline_highlighting = true,
	hl_groups = {
		insertion = "DiffAdd",
		deletion = "DiffDelete",
		change = "DiffChange",
	},
	commands = {
		Norm = { cmd = "norm" },
	},
})

-- Color scheme
vim.cmd([[
	colorscheme catppuccin-mocha
]])

-- Enable virtual text for diagnostics (autocomplete)
vim.diagnostic.config({
	virtual_text = true,
})

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- Setup LSPs
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
vim.lsp.enable("ts_ls")
vim.lsp.enable("svelte")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")

-- Autocomplete chars that come in pairs (ie: "(", "[", "`", etc)
require("nvim-autopairs").setup({})

-- Autocomplete and suggestions
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

-- Treesitter (syntax highlighting)
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
	modules = {},
	sync_install = true,
	ignore_install = {},
	auto_install = true,
	autoinstall = true,
	highlight = {
		enable = true,
	},
})

-- Configure linters
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

-- Run lint on auto commands
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave", "BufEnter", "TextChanged" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- Setup formatters
require("conform").setup({
	formatters_by_ft = {
		css = { "stylelint" },
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "eslint_d", "prettier" },
		svelte = { "eslint_d", "prettier" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})

-- Basic keymap
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>Q", ":quitall<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Split vertical" })

-- Telescope keymap
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Tmux keymap
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })

-- DAP
local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Breakpoint Condition" })

vim.keymap.set("n", "<leader>db", function()
	dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<leader>dc", function()
	dap.continue()
end, { desc = "Run/Continue" })

vim.keymap.set("n", "<leader>da", function()
	dap.continue({ before = get_args })
end, { desc = "Run with Args" })

vim.keymap.set("n", "<leader>dC", function()
	dap.run_to_cursor()
end, { desc = "Run to Cursor" })

vim.keymap.set("n", "<leader>dg", function()
	dap.goto_()
end, { desc = "Go to Line (No Execute)" })

vim.keymap.set("n", "<leader>di", function()
	dap.step_into()
end, { desc = "Step Into" })

vim.keymap.set("n", "<leader>dj", function()
	dap.down()
end, { desc = "Down" })

vim.keymap.set("n", "<leader>dk", function()
	dap.up()
end, { desc = "Up" })

vim.keymap.set("n", "<leader>dl", function()
	dap.run_last()
end, { desc = "Run Last" })

vim.keymap.set("n", "<leader>do", function()
	dap.step_out()
end, { desc = "Step Out" })

vim.keymap.set("n", "<leader>dO", function()
	dap.step_over()
end, { desc = "Step Over" })

vim.keymap.set("n", "<leader>dP", function()
	dap.pause()
end, { desc = "Pause" })

vim.keymap.set("n", "<leader>dr", function()
	dap.repl.toggle()
end, { desc = "Toggle REPL" })

vim.keymap.set("n", "<leader>ds", function()
	dap.session()
end, { desc = "Session" })

vim.keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate" })

vim.keymap.set("n", "<leader>dw", function()
	require("dap.ui.widgets").hover()
end, { desc = "Widgets" })

vim.keymap.set("n", "<leader>du", function()
	dapui.toggle({})
end, { desc = "Toggle DAP UI" })

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▸", texthl = "DiagnosticInfo", numhl = "" })

dapui.setup({
	layouts = {
		{
			elements = { "scopes", "breakpoints", "stacks", "watches" },
			size = 40,
			position = "left",
		},
		{
			elements = { "repl", "console" },
			size = 10,
			position = "bottom",
		},
	},
	controls = { enabled = true },
	floating = { border = "rounded" },
})

-- Auto open/close UI on start/stop
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Virtual text
require("nvim-dap-virtual-text").setup({
	commented = true,
	virt_text_pos = "inline",
	highlight_changed_variables = true,
})
require("yanky").setup()
require("mini.icons").setup()
require("nvim-web-devicons").setup()
require("oil").setup()
require("telescope").setup()
require("which-key").setup({
	preset = "helix",
})

require("dapui").setup()
