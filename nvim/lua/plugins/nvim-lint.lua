return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- Add linters for various file types
    opts.linters_by_ft = opts.linters_by_ft or {}

    -- JavaScript/TypeScript linters
    opts.linters_by_ft.javascript = { "eslint" }
    opts.linters_by_ft.javascriptreact = { "eslint" }
    opts.linters_by_ft.typescript = { "eslint" }
    opts.linters_by_ft.typescriptreact = { "eslint" }
    opts.linters_by_ft.svelte = { "eslint", "stylelint" }

    -- CSS linters
    opts.linters_by_ft.css = { "stylelint" }
    opts.linters_by_ft.scss = { "stylelint" }
    opts.linters_by_ft.less = { "stylelint" }
    opts.linters_by_ft.sass = { "stylelint" }
    opts.linters_by_ft.postcss = { "stylelint" }

    -- Other linters
    opts.linters_by_ft.go = { "golangcilint" }

    -- Optional: Add condition to only run when config exists
    opts.linters = opts.linters or {}

    -- Configure eslint_d to use local eslint if eslint_d is not available
    opts.linters.eslint = {
      condition = function(ctx)
        -- Check if eslint config exists
        local has_config = vim.fs.find({
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
        }, { path = ctx.filename, upward = true })[1]

        if not has_config then
          return false
        end

        -- Check if eslint_d or eslint is available
        return vim.fn.executable("eslint_d") == 1
          or vim.fn.executable("./node_modules/.bin/eslint") == 1
          or vim.fn.executable("eslint") == 1
      end,
    }

    -- Configure golangci-lint to only run when config exists
    opts.linters.golangcilint = {
      condition = function(ctx)
        return vim.fs.find({
          ".golangci.yml",
          ".golangci.yaml",
          ".golangci.json",
        }, { path = ctx.filename, upward = true })[1] ~= nil
      end,
    }

    opts.linters.stylelint = opts.linters.stylelint or {}
    opts.linters.stylelint = {
      condition = function(ctx)
        return vim.fs.find({
          ".stylelintrc",
          ".stylelintrc.json",
          ".stylelintrc.js",
          ".stylelintrc.cjs",
          ".stylelintrc.mjs",
          ".stylelintrc.yaml",
          ".stylelintrc.yml",
          "stylelint.config.js",
          "stylelint.config.cjs",
          "stylelint.config.mjs",
        }, { path = ctx.filename, upward = true })[1]
      end,
    }

    opts.linters.stylelint.stdin = false
    opts.linters.stylelint.args = {
      "--formatter",
      "json",
      function()
        return vim.fn.expand("%:p")
      end,
    }

    local function find_stylelint()
      -- Check if we're in a project with local stylelint
      if vim.fn.executable("./node_modules/.bin/stylelint") == 1 then
        return "./node_modules/.bin/stylelint"
      end

      -- Check global installation
      if vim.fn.executable("stylelint") == 1 then
        return "stylelint"
      end

      -- Return nil if not found
      return nil
    end

    opts.linters.stylelint = opts.linters.stylelint or {}
    opts.linters.stylelint.cmd = find_stylelint()

    -- Auto-lint on save and other events
    -- vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    --   callback = function()
    --     require("lint").try_lint()
    --   end,
    -- })
    --
    -- vim.api.nvim_create_autocmd("BufWritePost", {
    --   pattern = { "*.css", "*.scss", "*.sass", "*.less", "*.svelte" },
    --   callback = function()
    --     -- Fix errors first
    --     local file = vim.fn.expand("%:p")
    --     local cmd = "./node_modules/.bin/stylelint --fix " .. vim.fn.shellescape(file)
    --     vim.fn.system(cmd)
    --
    --     -- Then lint for remaining issues
    --     require("lint").try_lint()
    --   end,
    -- })
    --
    -- vim.api.nvim_create_autocmd("BufWritePost", {
    --   pattern = { "*.go" },
    --   callback = function()
    --     require("lint").try_lint()
    --   end,
    -- })
  end,
}
