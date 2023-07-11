require("lualine").setup()
vim.g.edge_style = "default"
vim.g.everforest_style = "medium"
vim.g.edge_enable_italic = 1
--vim.g:edge_disable_italic_comment = 1
vim.g.lightline_theme = "edge"
-- can't be set in lua yet
vim.cmd([[
colorscheme sonokai
]])

-- depends on telescope-nvim
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local dropdown = require("telescope.themes").get_dropdown()

function getTableKeys(tab)
	local keyset = {}
	for k, v in pairs(tab) do
		keyset[#keyset + 1] = k
	end
	table.sort(keyset)
	return keyset
end

local theme_cmd = {}
theme_cmd["edge default"] = [[
let g:edge_style = 'default'
colorscheme edge
]]
theme_cmd["edge aura"] = [[
set background=dark
let g:edge_style = 'aura'
colorscheme edge
]]
theme_cmd["edge neon"] = [[
set background=dark
let g:edge_style = 'neon'
colorscheme edge
]]
theme_cmd["edge default light"] = [[
set background=light
let g:edge_style = 'default'
colorscheme edge
]]
theme_cmd["edge neon light"] = [[
set background=light
let g:edge_style = 'neon'
colorscheme edge
]]
theme_cmd["sonokai default"] = [[
set background=dark
let g:sonokai_style = 'default'
colorscheme sonokai
]]
theme_cmd["sonokai atlantis"] = [[
set background=dark
let g:sonokai_style = 'atlantis'
colorscheme sonokai
]]
theme_cmd["sonokai andromeda"] = [[
set background=dark
let g:sonokai_style = 'andromeda'
colorscheme sonokai
]]
theme_cmd["sonokai shusia"] = [[
set background=dark
let g:sonokai_style = 'shusia'
colorscheme sonokai
]]
theme_cmd["sonokai maia"] = [[
set background=dark
let g:sonokai_style = 'maia'
colorscheme sonokai
]]
theme_cmd["sonokai espresso"] = [[
set background=dark
let g:sonokai_style = 'espresso'
colorscheme sonokai
]]
theme_cmd["everforest hard dark"] = [[
let g:everforest_background = 'hard'
set background=dark
colorscheme everforest
]]
theme_cmd["everforest soft dark"] = [[
let g:everforest_background = 'soft'
set background=dark
colorscheme everforest
]]
theme_cmd["everforest medium dark"] = [[
let g:everforest_background = 'medium'
set background=dark
colorscheme everforest
]]
theme_cmd["everforest hard light"] = [[
let g:everforest_background = 'hard'
set background=light
colorscheme everforest
]]
theme_cmd["everforest soft light"] = [[
let g:everforest_background = 'soft'
set background=light
colorscheme everforest
]]
theme_cmd["everforest medium light"] = [[
let g:everforest_background = 'medium'
set background=light
colorscheme everforest
]]

local function enter(prompt_bufnr)
	local selected = action_state.get_selected_entry()
	local cmd = theme_cmd[selected[1]]
	vim.cmd(cmd)
	actions.close(prompt_bufnr)
end

local function next_colo(prompt_bufnr)
	actions.move_selection_next(prompt_bufnr)
	local selected = action_state.get_selected_entry()
	local cmd = theme_cmd[selected[1]]
	vim.cmd(cmd)
end

local function previous_colo(prompt_bufnr)
	actions.move_selection_previous(prompt_bufnr)
	local selected = action_state.get_selected_entry()
	local cmd = theme_cmd[selected[1]]
	vim.cmd(cmd)
end

local theme_table = getTableKeys(theme_cmd)

local opts = {
	finder = finders.new_table(theme_table),
	sorter = sorters.get_generic_fuzzy_sorter(),

	attach_mappings = function(prompt_bufnr, map)
		map("i", "<CR>", enter)
		map("i", "<C-J>", next_colo)
		map("i", "<C-K>", previous_colo)
		return true
	end,
}

local colors = pickers.new(dropdown, opts)

vim.keymap.set("n", "<space>lq", function()
	colors:find()
end)
