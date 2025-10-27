-- Basic keymap
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>Q", ":quitall<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Split vertical" })
