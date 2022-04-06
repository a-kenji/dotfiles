vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.relativenumber = true
vim.o.number = true
--Make line numbers default
vim.wo.number = true
--Save undo history
vim.opt.undofile = true
--Enable mouse mode
vim.o.mouse = "a"
vim.o.syntax = "on"
vim.o.termguicolors = true
--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
vim.wo.colorcolumn = "80"

--- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "Y", "$Y")
map("n", ";", ":", { noremap = true })
map("n", "<leader>w", ":w<CR>", { silent = true })
map("i", "fd", "<esc>", { silent = true })
map("n", "<leader>p", '"+p')
map("v", "<C-c>", '"+y')

require("diffview").setup({})
vim.g.gitblame_enabled = 0
map("n", "<leader>gb", ":GitBlameToggle<CR>")

require("kenji.telescope.setup")
require("kenji.telescope.mappings")
require("kenji.theme")
require("kenji.lsp")
require("kenji.snippets")
require("kenji.completion")
