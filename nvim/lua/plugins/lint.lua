local lint = require("lint")

lint.linters_by_ft = {
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

-- Find the nearest package root by looking for linter-specific config files
local function find_linter_root()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		return nil
	end

	local filetype = vim.bo.filetype

	-- Define shared marker lists
	local eslint_markers =
		{ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yml", "eslint.config.js", "package.json" }
	local stylelint_markers =
		{ ".stylelintrc.json", ".stylelintrc.js", ".stylelintrc.cjs", "stylelint.config.js", "package.json" }

	-- Map filetypes to their linter markers
	local markers_by_ft = {
		-- JavaScript/TypeScript
		javascript = eslint_markers,
		javascriptreact = eslint_markers,
		typescript = eslint_markers,
		typescriptreact = eslint_markers,

		-- Svelte uses both eslint and stylelint
		svelte = vim.list_extend(vim.deepcopy(eslint_markers), stylelint_markers),

		-- CSS/Sass
		css = stylelint_markers,
		scss = stylelint_markers,
		less = stylelint_markers,
		sass = stylelint_markers,
		postcss = stylelint_markers,

		-- Go
		go = { "go.mod", ".golangci.yml", ".golangci.yaml", ".golangci.json" },

		-- Lua
		lua = { ".luacheckrc", ".luacheckrc.lua" },

		-- Markdown
		markdown = { ".vale.ini", "_vale.ini", ".vale" },
	}

	local markers = markers_by_ft[filetype]
	if not markers then
		return nil
	end

	-- Find the nearest marker walking up from current file
	local found = vim.fs.find(markers, {
		upward = true,
		path = vim.fs.dirname(bufname),
		stop = vim.env.HOME, -- Don't search beyond home directory
	})

	if found and #found > 0 then
		return vim.fs.dirname(found[1])
	end

	return nil
end

vim.api.nvim_create_autocmd(
	{ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave", "BufEnter", "TextChanged", "TextChangedI" },
	{
		callback = function(args)
			local opts = { ignore_errors = args.event ~= "BufWritePost" }

			-- Try to find package root based on linter config files
			local linter_root = find_linter_root()
			if linter_root then
				opts.cwd = linter_root
			else
				-- Fallback to LSP client root_dir if no linter config found
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				for _, client in pairs(clients) do
					if client.root_dir then
						opts.cwd = client.root_dir
						break
					end
				end
			end

			require("lint").try_lint(nil, opts)
		end,
	}
)
