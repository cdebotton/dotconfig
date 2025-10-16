return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier", "eslint_d" },
      typescript = { "prettier", "eslint_d" },
      svelte = { "prettier", "eslint_d", "stylelint" },
      css = { "stylelint" },
      python = { "black" },
      -- Add more file types and their respective formatters
    },
  },
}
