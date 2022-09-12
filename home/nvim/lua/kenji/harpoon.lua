require("harpoon").setup({})
vim.api.nvim_set_keymap(
	"n",
	"<leader>a",
	":lua require('harpoon.mark').add_file()<CR>",
	{ noremap = false, nowait = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-b>",
	":lua require('harpoon.ui').toggle_quick_menu()<CR>",
	{ noremap = false, nowait = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-h>",
	":lua require('harpoon.ui').nav_file(1)<CR>",
	{ noremap = false, nowait = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-j>",
	":lua require('harpoon.ui').nav_file(2)<CR>",
	{ noremap = false, nowait = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-k>",
	":lua require('harpoon.ui').nav_file(3)<CR>",
	{ noremap = false, nowait = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-l>",
	":lua require('harpoon.ui').nav_file(4)<CR>",
	{ noremap = false, nowait = true, silent = true }
)
