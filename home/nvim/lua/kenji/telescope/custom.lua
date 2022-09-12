local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local M = {}

M.terraform = function()
	pickers
		.new({
			results_title = "Resources",
			-- Run an external command and show the results in the finder window
			finder = finders.new_oneshot_job({ "terraform", "show" }),
			sorter = sorters.get_fuzzy_file(),
			previewer = previewers.new_buffer_previewer({
				define_preview = function(self, entry, status)
					-- Execute another command using the highlighted entry
					return require("telescope.previewers.utils").job_maker(
						{ "terraform", "state", "list", entry.value },
						self.state.bufnr,
						{
							callback = function(bufnr, content)
								if content ~= nil then
									require("telescope.previewers.utils").regex_highlighter(bufnr, "terraform")
								end
							end,
						}
					)
				end,
			}),
		})
		:find()
end

M.get_pods = function()
	pickers
		.new({
			results_title = "K8s Pods",
			finder = finders.new_oneshot_job({ "kubectl", "get", "pods" }),
			sorter = sorters.get_fuzzy_file(),
			previewer = previewers.new_termopen_previewer({
				get_command = function(entry)
					return { "kubectl", "describe", "pods", entry.value }
				end,
			}),
		})
		:find()
end

M.logs = function()
	pickers
		.new({
			results_title = "K8s Pod Logs",
			finder = finders.new_oneshot_job({ "kubectl", "get", "pods" }),
			sorter = sorters.get_fuzzy_file(),
			previewer = previewers.new_termopen_previewer({
				get_command = function(entry)
					return { "kubectl", "logs", entry.value }
				end,
			}),
		})
		:find()
end

M.just = function()
	pickers
		.new({
			results_title = "Just Recipes",
			finder = finders.new_oneshot_job({ "just", "--list", "--list-heading=", "--list-prefix=" }),
			sorter = sorters.get_fuzzy_file(),
			previewer = previewers.new_termopen_previewer({
				get_command = function(entry)
					local words = {}
					for word in entry.value:gmatch("%w+") do
						table.insert(words, word)
					end
					return { "just", "--dry-run", words[0] }
				end,
			}),
		})
		:find()
end

return M
