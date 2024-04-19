require("diffview").setup({})
require("gitsigns").setup()
require("neogit").setup({})
vim.g.gitblame_enabled = 0
vim.api.nvim_set_keymap("n", "<leader>gb", ":lua vim.diagnostic.goto_next()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<leader>gb", ":GitBlameToggle<CR>", { noremap = false, nowait = true })
