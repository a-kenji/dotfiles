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

vim.opt.listchars = {
	space = "_",
	tab = "▸\\",
	extends = "⟩",
	precedes = "⟨",
	trail = "·",
	eol = "¬",
	nbsp = "·",
}

-- Set completeopt
vim.o.completeopt = "menuone,noinsert"

require("kenji.builtin_plugins")

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

--- clear search results
map("n", "//", ":noh<CR>", { silent = true })
map("v", "//", ":noh<CR>", { silent = true })

-- repeatedly allow to shift
map("v", "<", "<gv")
map("v", ">", ">gv")
vim.o.scrolloff = 5

--Add spellchecking
local spell_group = vim.api.nvim_create_augroup("Spellcheck", { clear = true })
vim.api.nvim_create_autocmd(
	"FileType",
	{ command = "setlocal spell", group = "Spellcheck", pattern = { "gitcommit", "markdown" } }
)

require("diffview").setup({})
require("Comment").setup({})
vim.g.gitblame_enabled = 0
vim.g.direnv_silent_load = 1
map("n", "<leader>gb", ":GitBlameToggle<CR>")
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" },
})
--require("surround").setup({ mappings_style = "sandwich" })
require("nvim-surround").setup()

vim.cmd([[
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_types = {
\ 'sections' : {'parse_levels': 1},
\}
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_indent_enabled=0
highlight Conceal guifg=#F8F8F0 guibg=#5A5475
au FileType tex nmap <leader>d <Plug>(vimtex-doc-package)
au FileType tex nmap <leader>t ;VimtexTocToggle
let g:vimtex_compiler_latexmk = {
"\ 'backend' : DEPENDS ON SYSTEM (SEE BELOW),
\ 'background' : 1,
"\ 'build_dir' : ' ',
\ 'callback' : 1,
\ 'continuous' : 1,
\ 'executable' : 'latexmk',
\ 'hooks' : [],
\ 'options' : [
\   '-verbose',
\   '-file-line-error',
\    '--shell-escape',
\   '-synctex=1',
\   '-interaction=nonstopmode',
\ ],
\}

" Close the error window after writing a bit
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
    " Configure table of contents
" - Hide the help
" - Disable the label list by default
" - Resize too automatically
" - Increase size from 30 to 50
" - Reduce from 3 levels (4 parts) to 2 (3 parts)
let g:vimtex_toc_config = {
			\ 'show_help': 0,
			\ 'layer_status': {'content': 1, 'todo': 1, 'label': 1, 'fixme': 1},
			\ 'split_width': 50,
			\ 'tocdepth': 2
			\}
			" - Do not show preamble in the list
let g:vimtex_toc_show_preamble = 0

let s:lbl_todo  = '✅D: '
let s:lbl_warn  = '⚡W: '
let s:lbl_fixme = '⛔F: '

let g:vimtex_toc_todo_labels = {
			\ 'TODO': s:lbl_todo,
			\ 'FIXME': s:lbl_fixme, }
]])

require("kenji.telescope.setup")
require("kenji.telescope.mappings")
require("kenji.theme")
require("kenji.lsp")
require("kenji.snippets")
require("kenji.completion")
require("luasnip.loaders.from_vscode").lazy_load()
-- require('gitsigns').setup()

vim.cmd([[
" Close location list or quickfix list if they are present,
" see https://superuser.com/q/355325/736190
nnoremap<silent> \x :<C-U>windo lclose <bar> cclose<CR>

" Close a buffer and switching to another buffer, do not close the
" window, see https://stackoverflow.com/q/4465095/6064933
nnoremap <silent> \d :<C-U>bprevious <bar> bdelete #<CR>

" Insert a blank line below or above current line (do not move the cursor),
" see https://stackoverflow.com/a/16136133/6064933
nnoremap <expr> <Space>o printf('m`%so<ESC>``', v:count1)
nnoremap <expr> <Space>O printf('m`%sO<ESC>``', v:count1)

" Insert a space after current character
nnoremap <Space><Space> a<Space><ESC>h

" Jump to matching pairs easily in normal mode
nnoremap <Tab> %

" Go to start or end of line easier
nnoremap H ^
xnoremap H ^
nnoremap L g_
xnoremap L g_

" insert semicolon in the end
inoremap <A-;> <ESC>miA;<ESC>`ii

" Do not move my cursor when joining lines.
nnoremap J mzJ`z
nnoremap gJ mzgJ`z

set splitright
set splitbelow
set laststatus=3
highlight WinSeparator guibg=None
]])
