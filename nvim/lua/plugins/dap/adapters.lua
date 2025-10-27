require("mason-nvim-dap").setup({
	automatic_installation = true,
	ensure_installed = { "delve", "js-debug-adapter", "gotestsum", "tree-sitter-cli" },
})

-- Javascript Debugging

for _, adapter in pairs({ "pwa-node", "pwa-chrome" }) do
	require("dap").adapters[adapter] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "js-debug-adapter",
			args = { "${port}" },
		},
	}
end

for _, language in pairs({ "javascript", "typescript", "svelte" }) do
	require("dap").configurations[language] = {
		{
			name = "Debug node",
			type = "pwa-node",
			request = "launch",
			sourceMaps = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			runtimeExecutable = "npm",
			runtimeArgs = { "run", "dev" },
			rootPath = "${workspaceFolder}",
			cwd = function()
				local util = require("lspconfig.util")
				return util.root_pattern("package.json")(vim.fn.expand("%:p")) or vim.fn.getcwd()
			end,
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			skipFiles = {
				"<node_internals>/**",
				"${workspaceFolder}/node_modules/**/*.js",
				"**/node_modules/**",
				"**/@vite/**",
				"**/vite/dist/**",
			},
		},
		{
			type = "pwa-node",
			request = "attach",
			processId = require("dap.utils").pick_process,
			name = "Attach debugger to existing node --inspect",
			sourceMaps = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			cwd = "${workspaceFolder}/src",
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
		},
		{
			type = "pwa-chrome",
			name = "Launch Chrome to debug client",
			request = "launch",
			url = "http://localhost:5173",
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}/src",
			skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
		},
		language == "javascript" and {
			type = "pwa-node",
			request = "launch",
			name = "Launch file in new node process",
			program = "${file}",
			cwd = "${workspaceFolder}",
		} or nil,
	}
end

-- Go Debugging
require("dap-go").setup({
	dap_configurations = {
		{
			type = "go",
			name = "Debug (Build Flags & Arguments)",
			request = "launch",
			program = "${file}",
			args = require("dap-go").get_arguments,
			buildFlags = require("dap-go").get_build_flags,
		},
		{
			type = "go",
			name = "Attach remote",
			mode = "remote",
			request = "attach",
		},
	},
})
