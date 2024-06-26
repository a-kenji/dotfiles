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

require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
vim.g.direnv_silent_load = 1
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" },
})
--require("surround").setup({ mappings_style = "sandwich" })
require("nvim-surround").setup()
-- TODO: remove once fixed: https://github.com/neovim/neovim/issues/23291
require("vim.lsp._watchfiles")._watchfunc = function(_, _, _)
	return true
end
-- TODO: remove once fixed: https://github.com/neovim/neovim/issues/23291

require("kenji.vimtex")
require("kenji.theme")
require("kenji.telescope.setup")
require("kenji.telescope.mappings")
require("kenji.lsp")
require("kenji.lsp.null-ls")
require("kenji.snippets")
require("kenji.completion")
require("kenji.terminal")
require("kenji.filetypes")
require("kenji.harpoon")
require("kenji.trouble")
require("luasnip.loaders.from_vscode").lazy_load()
require("kenji.tree-sitter")
require("kenji.quickfix")
require("kenji.git")

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
"nnoremap <Tab> %

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
"set winbar=%f
" use jj to escape insert mode.
let g:better_escape_shortcut = 'fd'

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
"TODO: revisit once it is less experimental
"set cmdheight=0
]])

--- this needs to be run late in the initialization process
vim.cmd([[
autocmd VimEnter * TSToggle rainbow
]])
-- autocmd FileType python colorscheme edge
-- autocmd FileType bash colorscheme edge
require("aerial").setup({
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
	end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>la", "<cmd>AerialToggle!<CR>")

require("todo-comments").setup({})
require("glance").setup({})
vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

require("nvim-lightbulb").setup({
	autocmd = { enabled = true },
})
require("leap").add_default_mappings()

-- require("neotest").setup({
-- 	adapters = {
-- 		require("neotest-rust"),
-- 	},
-- })
--
--

-- setup neo-tree
vim.keymap.set("n", "<Leader>e", ":Neotree position=current reveal<CR>")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neo-tree").setup({
	filesystem = {
		hijack_netrw_behavior = "open_current",
	},
	buffers = {
		follow_current_file = {
			enabled = true,
			leave_dirs_open = true,
		},
		group_empty_dirs = true,
	},
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function(arg)
				vim.cmd([[
          setlocal relativenumber
        ]])
			end,
		},
	},
})
