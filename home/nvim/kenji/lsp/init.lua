vim.api.nvim_set_keymap("n", "<space>vd", ":lua vim.lsp.buf.definition()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vi", ":lua vim.lsp.buf.implementation()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vrr", ":lua vim.lsp.buf.references()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vrn", ":lua vim.lsp.buf.rename()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vca", ":lua vim.lsp.buf.code_action()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vsd", ":lua vim.diagnostic.open_float()<CR>", { noremap = false, nowait = true })

--nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
--nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
--nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
--nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
--nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
--" Goto previous/next diagnostic warning/error
--nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
--nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
---- Add nvim-lspconfig plugin
local lspconfig = require("lspconfig")
local on_attach = function(client, bufnr)
	require("completion").on_attach(client)
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local handlers = {
  ['textDocument/hover'] = function(...)
    local bufnr, _ = vim.lsp.handlers.hover(...)
    if bufnr then
      vim.keymap.set('n', 'K', '<Cmd>wincmd p<CR>', { silent = true, buffer = bufnr })
    end
  end,
}

require("lspconfig").rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importMergeBehavior = "last",
				importPrefix = "by_self",
			},
			diagnostics = {
				disabled = { "unresolved-import" },
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

-- bash lsp
require("lspconfig").bashls.setup({})
-- nix lsp
require("lspconfig").rnix.setup({})

require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
	handlers = handlers,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				maxPreload = 2000,
				preloadFileSize = 1000,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
		additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})
