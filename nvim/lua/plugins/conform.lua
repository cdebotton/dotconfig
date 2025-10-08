return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier", "eslint" },
      typescript = { "prettier", "eslint" },
      svelte = { "prettier", "eslint", "stylelint" },
      css = { "stylelint" },
      python = { "black" },
      -- Add more file types and their respective formatters
    },
  },
}
