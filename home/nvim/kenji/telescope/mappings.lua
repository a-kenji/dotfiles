if not pcall(require, "telescope") then
	return
end

local sorters = require("telescope.sorters")

vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

-- LSP management
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { silent = true })
vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { silent = true })
vim.keymap.set("n", "<leader>ls", ":LspStart<CR>", { silent = true })
vim.keymap.set("n", "<leader>lt", ":LspStop<CR>", { silent = true })

-- Files
vim.api.nvim_set_keymap("n", "<space>lf", ":lua require'telescope.builtin'.git_files()<CR>", { silent = false })
vim.api.nvim_set_keymap("n", "<space>lg", ":lua require'telescope.builtin'.multi_rg()<CR>", { silent = false })
-- Git
vim.api.nvim_set_keymap("n", "<space>gs", ":lua require'telescope.builtin'.git_status()<CR>", { silent = false })
vim.api.nvim_set_keymap("n", "<space>gc", ":lua require'telescope.builtin'.git_commits()<CR>", { silent = false })
-- Misc
vim.api.nvim_set_keymap("n", "<space>fh", ":lua require'telescope.builtin'.help_tags()<CR>", { silent = false })
vim.api.nvim_set_keymap("n", "<space>wt", ":lua require'telescope.builtin'.treesitter()<CR>", { silent = false })
vim.api.nvim_set_keymap("n", "<space>bo", ":lua require'telescope.builtin'.vim_options()<CR>", { silent = false })
