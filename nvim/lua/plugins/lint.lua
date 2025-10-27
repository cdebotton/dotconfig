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

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave", "BufEnter", "TextChanged" }, {
	callback = function(args)
		local lint = require("lint")
		local opts = { ignore_errors = args.event ~= "BufWritePost" }

		-- Find clients for monorepo
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local key, client = next(clients)
		while key do
			if client.workspace_folders then
				for _, dir in pairs(client.workspace_folders) do
					if vim.fs.relpath(dir.name, vim.api.nvim_buf_get_name(0)) then
						opts.cwd = dir.name
					end
				end
			elseif client.root_dir then
				opts.cwd = client.root_dir
			end
			if opts.cwd then
				break
			end
			key, client = next(clients, key)
		end

		lint.try_lint(nil, opts)
	end,
})
