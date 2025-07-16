return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- Add stylelint to CSS-related file types
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.css = { "stylelint" }
    opts.linters_by_ft.scss = { "stylelint" }
    opts.linters_by_ft.less = { "stylelint" }
    opts.linters_by_ft.sass = { "stylelint" }
    opts.linters_by_ft.svelte = { "stylelint" }

    -- Optional: Add condition to only run when config exists
    opts.linters = opts.linters or {}
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
      vim.notify("stylelint not found", vim.log.levels.WARN)
      return nil
    end

    opts.linters.stylelint = opts.linters.stylelint or {}
    opts.linters.stylelint.cmd = find_stylelint()

    -- Auto-lint on save and other events
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.css", "*.scss", "*.sass", "*.less", "*.svelte" },
      callback = function()
        -- Fix errors first
        local file = vim.fn.expand("%:p")
        local cmd = "./node_modules/.bin/stylelint --fix " .. vim.fn.shellescape(file)
        vim.fn.system(cmd)

        -- Then lint for remaining issues
        require("lint").try_lint()
      end,
    })
  end,
}
