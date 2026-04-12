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
			name = "Attach to node debugger (port)",
			port = function()
				local input = vim.fn.input("Debugger port: ", "9229")
				return tonumber(input)
			end,
			sourceMaps = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			cwd = function()
				local workspace = vim.fn.getcwd()

				local function find_monorepo_packages()
					local packages = {}
					-- Check for common monorepo indicators
					local indicators = { "pnpm-workspace.yaml", "lerna.json", "turbo.json", "nx.json" }
					local is_monorepo = false
					for _, file in ipairs(indicators) do
						if vim.fn.filereadable(workspace .. "/" .. file) == 1 then
							is_monorepo = true
							break
						end
					end
					if not is_monorepo then
						local pkg_json = workspace .. "/package.json"
						if vim.fn.filereadable(pkg_json) == 1 then
							local text = table.concat(vim.fn.readfile(pkg_json), "\n")
							if text:find('"workspaces"') then
								is_monorepo = true
							end
						end
					end
					if not is_monorepo then
						return nil
					end
					-- Collect packages from common monorepo dirs
					for _, dir in ipairs({ "packages", "apps", "libs", "services" }) do
						local full_dir = workspace .. "/" .. dir
						if vim.fn.isdirectory(full_dir) == 1 then
							for _, entry in ipairs(vim.fn.readdir(full_dir)) do
								local pkg_path = full_dir .. "/" .. entry
								if vim.fn.isdirectory(pkg_path) == 1 and vim.fn.filereadable(pkg_path .. "/package.json") == 1 then
									table.insert(packages, pkg_path)
								end
							end
						end
					end
					return #packages > 0 and packages or nil
				end

				local packages = find_monorepo_packages()
				if not packages then
					return workspace
				end

				local choices = { "Select package:" }
				for i, pkg in ipairs(packages) do
					table.insert(choices, i .. ". " .. pkg:gsub(workspace .. "/", ""))
				end
				local choice = vim.fn.inputlist(choices)
				if choice > 0 and choice <= #packages then
					return packages[choice]
				end
				return workspace
			end,
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
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
require("dap-go").setup()
-- require("dap-go").setup({
-- 	dap_configurations = {
-- 		{
-- 			type = "go",
-- 			name = "Debug (Build Flags)",
-- 			request = "launch",
-- 			program = "${file}",
-- 			buildFlags = require("dap-go").get_build_flags,
-- 		},
-- 		{
-- 			type = "go",
-- 			name = "Debug (Build Flags & Arguments)",
-- 			request = "launch",
-- 			program = "${file}",
-- 			args = require("dap-go").get_arguments,
-- 			buildFlags = require("dap-go").get_build_flags,
-- 		},
-- 		{
-- 			type = "go",
-- 			name = "Attach local",
-- 			mode = "local",
-- 			processId = function()
-- 				return require("dap.utils").pick_process({})
-- 			end,
-- 			request = "attach",
-- 		}
-- 	},
-- })
