require("toggleterm").setup()

vim.cmd([[
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd VimEnter * FloatermNew --silent
"tnoremap <Esc> <C-\><C-n>
tnoremap <C-;> <C-\><C-n>
" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm direction=vertical size=35"<CR>
nnoremap <silent><F11> <Cmd>exe v:count1 . "ToggleTerm direction=vertical size=35"<CR>
tnoremap <silent><F11> <Cmd>exe v:count1 . "ToggleTerm direction=vertical size=35"<CR>
nnoremap <silent><F10> <Cmd>exe v:count1 . "ToggleTerm direction=horizontal size=10"<CR>
tnoremap <silent><F10> <Cmd>exe v:count1 . "ToggleTerm direction=horizontal size=10"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent><leader><sl> <Cmd>exe v:count1 . "ToggleTermSendCurrentLine"<CR>
nnoremap <silent><leader><sv> <Cmd>exe v:count1 . "ToggleTermSendVisualLines"<CR>
nnoremap <silent><leader><ss> <Cmd>exe v:count1 . "ToggleTermSendVisualSelection"<CR>
	]])

vim.g.floaterm_height = 0.999
vim.g.floaterm_width = 0.999
vim.g.floaterm_height = 0.99
vim.g.floaterm_keymap_new = "<F7>"
vim.g.floaterm_keymap_prev = "<F8>"
vim.g.floaterm_keymap_next = "<F9>"
vim.g.floaterm_keymap_toggle = "<F12>"
vim.g.floaterm_gitcommit = "floaterm"
vim.g.floaterm_title = "($1|$2)"

-- mappings
vim.api.nvim_set_keymap("n", "<Leader>pg", "<cmd>FloatermNew lazygit<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>ph", "<cmd>FloatermNew htop<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>pn", "<cmd>FloatermNew<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>pp", "<cmd>FloatermNew<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>px", "<cmd>FloatermToggle<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>to", "<cmd>terminal<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<Leader>pl",
	"<cmd>FloatermNew --disposable gh issue list<CR>",
	{ silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>pr",
	"<cmd>FloatermNew --disposable gh issue reference<CR>",
	{ silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>pv",
	"<cmd>FloatermNew --disposable gh repo view -w<CR>",
	{ silent = true, noremap = true }
)

-- function _G.set_terminal_keymaps()
-- 	local opts = { buffer = 0 }
-- 	vim.keymap.set("t", "<esc>", "<ESC>", opts)
-- 	vim.keymap.set("t", "\\\\", "<C-\\><C-n>", opts)
-- 	vim.keymap.set("t", "<C-LEFT>", [[<Cmd>wincmd h<CR>]], opts)
-- 	vim.keymap.set("t", "<C-DOWN>", [[<Cmd>wincmd j<CR>]], opts)
-- 	vim.keymap.set("t", "<C-UP>", [[<Cmd>wincmd k<CR>]], opts)
-- 	vim.keymap.set("t", "<C-RIGHT>", [[<Cmd>wincmd l<CR>]], opts)
-- end
--
-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
--
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "double",
	},
	-- function to run on opening the terminal
	on_open = function(term)
		-- vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function(term)
		-- vim.cmd("Closing terminal")
	end,
})

function _lazygit_toggle()
	lazygit:toggle()
end

-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>terminal lazygit <CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>nt", "<cmd>terminal<CR>", { noremap = true, silent = true })
