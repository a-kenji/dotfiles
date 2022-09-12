vim.api.nvim_set_keymap("n", "<space>vd", ":lua vim.lsp.buf.definition()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vi", ":lua vim.lsp.buf.implementation()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vrr", ":lua vim.lsp.buf.references()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vsh", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vrn", ":lua vim.lsp.buf.rename()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>f", ":lua vim.lsp.buf.format()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vca", ":lua vim.lsp.buf.code_action()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>D", ":lua vim.lsp.buf.type_definition()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>vsd", ":lua vim.diagnostic.open_float()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "g[", ":lua vim.diagnostic.goto_next()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "g]", ":lua vim.diagnostic.goto_prev()<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap(
	"n",
	"<space>ca",
	":lua vim.lsp.buf.code_action({apply=true})<CR>",
	{ noremap = false, nowait = true }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>ca",
	":lua code_action_range({apply=true})<CR>",
	{ noremap = false, silent = true }
)

-- LSP management
vim.api.nvim_set_keymap("n", "<leader>lr", ":LspRestart<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>li", ":LspInfo<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>ls", ":LspStart<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>lt", ":LspStop<CR>", { silent = true })
-- vim.lsp.diagnostic.clear(0)

-- Tree Sitter management
vim.api.nvim_set_keymap("n", "<leader>tsp", ":TSPlaygroundToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>tsn", ":TSNodeUnderCursor<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>tsm", ":TSModuleInfo<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>tsc", ":TSHighlightCapturesUnderCursor<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>tst", ":TSToggle<CR>", { silent = true })

--nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
--nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
--nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
--" Goto previous/next diagnostic warning/error
--nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
--nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
---- Add nvim-lspconfig plugin
local lspconfig = require("lspconfig")
local on_attach = function(client, bufnr) end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local handlers = {
	["textDocument/hover"] = function(...)
		local bufnr, _ = vim.lsp.handlers.hover(...)
		if bufnr then
			vim.keymap.set("n", "K", "<Cmd>wincmd p<CR>", { silent = true, buffer = bufnr })
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
-- python lsp
require("lspconfig").pylsp.setup({})

-- nil lsp
-- local caps = vim.lsp.protocol.make_client_capabilities()
-- caps = require("cmp_nvim_lsp").update_capabilities(caps)
-- -- local lsp_path = vim.env.NIL_PATH or "target/debug/nil" or vim.env.HOME .. "/.nix-profile/bin/nil"
-- local lsp_path = vim.env.NIL_PATH or vim.env.HOME .. "/.nix-profile/bin/nil"
require("lspconfig").nil_ls.setup({
	-- autostart = true,
	-- capabilities = caps,
	-- cmd = { lsp_path },
})
-- end nil lsp

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

function code_action_range()
	-- Adapted from https://stackoverflow.com/a/6271254, for how to get visual styled
	-- selection. Not sure this is the best way but it seems to work.
	local cursor = vim.api.nvim_win_get_cursor(0)

	local cnum_start, lnum_start = unpack(vim.fn.getpos("'<"))
	local cnum_end, lnum_end = unpack(vim.fn.getpos("'>"))
	local lines = vim.api.nvim_buf_get_lines(0, lnum_start - 1, lnum_end, true)
	for line in ipairs(lines) do
		vim.api.nvim_win_set_cursor(0, { line + lnum_start - 1, 0 })
		vim.lsp.buf.code_action({
			-- context = {
			-- 	only = { "quickfix" },
			-- },
			apply = true,
		})
		vim.wait(20)
	end
	vim.api.nvim_win_set_cursor(0, cursor)
end

local diagnostics_active = true
local toggle_diagnostics = function()
	diagnostics_active = not diagnostivs_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

vim.api.nvim_set_keymap("n", "<leader>d", "toggle_diagnostics", { silent = true })
