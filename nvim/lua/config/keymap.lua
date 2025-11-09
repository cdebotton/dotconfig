-- Basic keymap
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>Q", ":quitall<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename" })
