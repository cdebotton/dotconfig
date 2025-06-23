-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.svelte" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("MyAutocmds", {}),
})
