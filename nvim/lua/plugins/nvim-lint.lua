return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave" },
  config = function()
    require("lint").linters_by_ft = {
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

    local function get_root(ctx)
      local current_file = ctx and ctx.filename or vim.fn.expand("%:p")
      local root = vim.fs.find("node_modules", { path = current_file, upward = true, type = "directory" })[1]

      if root then
        return vim.fs.dirname(root)
      end

      return nil
    end

    local function find_stylelint(ctx)
      local root = get_root(ctx)

      if root then
        local local_stylelint = root .. "/node_modules/.bin/stylelint"
        if vim.fn.executable(local_stylelint) == 1 then
          return local_stylelint
        end
      end

      if vim.fn.executable("stylelint") == 1 then
        return "stylelint"
      end

      return nil
    end

    local function find_eslint_d(ctx)
      local root = get_root(ctx)

      if root then
        local local_eslint_d = root .. "/node_modules/.bin/eslint_d"
        if vim.fn.executable(local_eslint_d) == 1 then
          return local_eslint_d
        end
      end

      if vim.fn.executable("eslint_d") == 1 then
        return "eslint_d"
      end

      return nil
    end

    require("lint").linters.stylelint.cwd = get_root()
    require("lint").linters.stylelint.cmd = find_stylelint() or "stylelint"
    require("lint").linters.eslint_d.cwd = get_root()
    require("lint").linters.eslint_d.cmd = find_eslint_d() or "eslint_d"

    vim.api.nvim_create_autocmd({ "TextChanged" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
