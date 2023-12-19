-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "org", "latex" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
		additional_vim_regex_highlighting = { "org", "latex" },
		-- Required since TS highlighter doesn't support all syntax features (conceal)
		-- set_custom_captures = {
		-- 	-- ["@"] = "Identifier",
		-- },
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
		swap = {
			enable = true,
			swap_next = {
				["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
				["<leader>nm"] = "@function.outer", -- swap function with next
			},
			swap_previous = {
				["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
				["<leader>pm"] = "@function.outer", -- swap function with previous
			},
		},
		-- move = {
		-- 	enable = true,
		-- 	set_jumps = true, -- whether to set jumps in the jumplist
		-- 	goto_next_start = {
		-- 		["]m"] = "@function.outer",
		-- 		["]]"] = "@class.outer",
		-- 	},
		-- 	goto_next_end = {
		-- 		["]M"] = "@function.outer",
		-- 		["]["] = "@class.outer",
		-- 	},
		-- 	goto_previous_start = {
		-- 		["[m"] = "@function.outer",
		-- 		["[["] = "@class.outer",
		-- 	},
		-- 	goto_previous_end = {
		-- 		["[M"] = "@function.outer",
		-- 		["[]"] = "@class.outer",
		-- 	},
		-- },
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			-- max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
			max_file_lines = nil,
			-- colors = {}, -- table of hex strings
			-- termcolors = {}, -- table of colour name strings
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		query_linter = {
			enable = true,
			use_virtual_text = true,
			lint_events = { "BufWrite", "CursorHold" },
		},
	},
})

-- configuration of RTP independend injections

-- nix injections
require("vim.treesitter.query").set(
	"nix",
	"injections",
	[[(
binding
attrpath: (attrpath attr: (identifier) @_test )
expression: (indented_string_expression) @python
(#eq? @_test "testScript")
)
]]
)
require("vim.treesitter.query").set(
	"nix",
	"injections",
	[[(
(binding
  (attrpath (identifier) @id)
  (indented_string_expression (string_fragment) @python)
) (#eq? @id "testScript")
)
]]
)

require("vim.treesitter.query").set(
	"lua",
	"injections",
	[[(
 function_call
 name: (dot_index_expression
	table: (function_call)
	field: (identifier) @_test
	)
 arguments: ((arguments
	(string)
	(string)
	(string
	  content: (string_content) @scheme)))
 (#eq? @_test "set")
)]]
)

require("vim.treesitter.query").set(
	"nix",
	"injections",
	[[(
apply_expression
function:  (apply_expression
function: (apply_expression
function: (variable_expression
name: (identifier) @_test)))
argument: (indented_string_expression) @bash
(#eq? @_test "runCommand")
)]]
)

require("vim.treesitter.query").set(
	"nix",
	"injections",
	[[(
binding
attrpath: (attrpath attr: (identifier) @_test)
expression: (indented_string_expression) @bash
(#any-of? @_test
"unpackPhase" "preUnpack" "postUnpack"
"patchPhase" "prePatch" "postPatch"
"configurePhase" "preConfigure" "postConfigure"
"buildPhase" "preBuild" "postBuild"
"checkPhase" "preCheck" "postCheck"
"installPhase" "preInstall" "postInstall"
"fixupPhase" "preFixup" "postFixup"
"installCheckPhase" "preInstallCheck" "postInstallCheck"
"distPhase" "preDist" "postDist" )
)]]
)

-- markdown
require("vim.treesitter.query").set(
	"markdown",
	"injections",
	[[(
(fenced_code_block
  (info_string) @_lang (#eq? @_lang "sh")
  (code_fence_content) @bash)
)]]
)
require("vim.treesitter.query").set(
	"markdown",
	"injections",
	[[(
(fenced_code_block
  (info_string) @_lang (#eq? @_lang "js")
  (code_fence_content) @javascript)
)]]
)

vim.api.nvim_set_keymap("n", "<space>lc", "<CMD> TSContextToggle <CR>", { silent = false })

-- Install necessary parsers using your plugin manager
-- For example, using Vim-Plug:
-- Plug 'nvim-treesitter/nvim-treesitter'
-- Plug 'nvim-treesitter/playground'

local M = {}

-- Function to inject a specified language into the current node
function inject_language(lang)
	local node = vim.treesitter.get_node()
	if node then
		local bufnr = vim.api.nvim_get_current_buf()

		-- Create a new buffer for the injected code
		local injected_bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_option(injected_bufnr, "filetype", lang)

		-- Insert the injected code into the new buffer
		vim.api.nvim_buf_set_lines(injected_bufnr, 0, -1, true, { "/* " .. lang .. " code */" })

		-- Use ts_utils to set the injected language for the current node
		-- require("nvim-treesitter.ts_utils").update_injected(bufnr, injected_bufnr, node)
		node.set("injections", "python")
	else
		print("No tree-sitter node found at the cursor position.")
	end
end

return M
