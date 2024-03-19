local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<C-space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "copilot", group_index = 2 },
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "nvim_lsp_signature_help" },
	}, {
		{ name = "buffer" },
		{
			name = "rg",
			-- Try it when you feel cmp performance is poor
			-- keyword_length = 3
		},
		-- { name = "crates" },
	}),
	completion = {
		completeopt = "menu,menuopt,noinsert",
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline('/', {
-- sources = {
--  { name = 'buffer' }
-- }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline(':', {
-- sources = cmp.config.sources({
--  { name = 'path' }
--}, {
-- { name = 'cmdline' }
-- })
--})
--
--

local copilot = require("copilot")
copilot.setup({
	suggestion = {
		enabled = false,
		auto_trigger = true,
		debounce = 75,
	},
	panel = {
		enabled = false,
		auto_refresh = true,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
		layout = {
			position = "right", -- | top | left | right
			ratio = 0.3,
		},
	},
	copilot_node_command = "node", -- Node.js version must be > 18.x
	server_opts_overrides = {},
})
local copilot_cmp = require("copilot_cmp")
copilot_cmp.setup()

vim.api.nvim_set_keymap("n", "<space>ce", "<CMD>:Copilot toggle<CR>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap(
	"n",
	"<space>ct",
	"<cmd>:lua require('copilot.suggestion').toggle_auto_trigger()<cr>",
	{ noremap = false, nowait = true }
)

require("CopilotChat").setup({
	debug = false, -- Enable debugging
	-- See Configuration section for rest
	prompts = {
		BetterNamings = "Please provide better names for the following variables and functions.",
		Documentation = "Please provide documentation for the following code.",
		-- Text related prompts
		Summarize = "Please summarize the following text.",
		Spelling = "Please correct any grammar and spelling errors in the following text.",
		Wording = "Please improve the grammar and wording of the following text.",
		Concise = "Please rewrite the following text to make it more concise.",
	},
	event = "VeryLazy",
})

-- local chat = require("CopilotChat")
-- local select = require("CopilotChat.select")
-- -- Use unnamed register for the selection
-- opts.selection = select.unnamed
--
-- -- Inline chat with Copilot
-- vim.api.nvim_create_user_command("CopilotChatInline", function(args)
-- 	chat.ask(args.args, {
-- 		selection = select.visual,
-- 		window = {
-- 			layout = "float",
-- 			relative = "cursor",
-- 			width = 1,
-- 			height = 0.4,
-- 			row = 1,
-- 		},
-- 	})
-- end, { nargs = "*", range = true })
--

vim.api.nvim_create_user_command("CopilotChatTelescopePromptActions", function(args)
	local actions = require("CopilotChat.actions")
	require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { nargs = "*", range = true })
--
vim.api.nvim_create_user_command("CopilotChatTelescopeHelpActions", function(args)
	local actions = require("CopilotChat.actions")
	require("CopilotChat.integrations.telescope").pick(actions.help_actions())
end, { nargs = "*", range = true })

vim.api.nvim_set_keymap("n", "<leader>cce", "<cmd>CopilotChatExplain<cr>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<leader>ccn", "<cmd>CopilotChatBetterNaming<cr>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>cct", "<cmd>CopilotChatTests<cr>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>ccw", "<cmd>CopilotChatToggle<cr>", { noremap = false, nowait = true })
vim.api.nvim_set_keymap(
	"n",
	"<space>ccp",
	"<cmd>CopilotChatTelescopePromptActions<cr>",
	{ noremap = false, nowait = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<space>cch",
	"<cmd>CopilotChatTelescopeHelpActions<cr>",
	{ noremap = false, nowait = true }
)
-- Code related commands
-- { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
-- { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
-- { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
-- { "<leader>ccn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
