local query = vim.treesitter.parse_query(
	"json",
	[[
(pair
key: (string (string_content) @content (#eq? @content "lastModified"))
value: (number) @value
)
]]
)

local Job = require("plenary.job")

local add_lastModified_date = function(bufnr)
	if not bufnr then
		bufnr = vim.api.nvim_get_current_buf()
	end

	if vim.bo[bufnr].filetype ~= "json" then
		vim.notify("Is used for nix lockfiles")
		return
	end

	local parser = vim.treesitter.get_parser(bufnr, "json", {})
	local tree = parser:parse()[1]
	-- Finds sql-format-via-python somewhere in your nvim config path
	local bin = vim.api.nvim_get_runtime_file("date", false)[1]

	local changes = {}
	for id, node, metadata in query:iter_captures(tree:root(), bufnr, 0, -1) do
		-- print(id)
		-- print(query.captures[id])
		-- print(vim.treesitter.get_node_text(node, bufnr))
		if id == 2 then
			local text = vim.treesitter.get_node_text(node, bufnr)
			-- local split = vim.split(text, "\n")
			-- local result = table.concat(vim.list_slice(split, 2, #split - 1), "\n")
			local result = "date -d @" .. text .. 
print(text)
			print(result)
			-- local j = Job:new({
			-- 	command = "bash",
			-- 	args = { bin , result},
			-- 	writer = { text },
			-- })
			-- local j = os.capture(result)
			local handle = io.popen(result)
			if handle then
				local output = handle:read("r")
				if handle then
					handle:close()
				print(output)
				end
			end

			-- local range = { node:range() }
			--
			-- local formatted = j:sync()
			-- local rep = string.rep(" ", range[2])
			-- for idx, line in ipairs(formatted) do
			-- 	formatted[idx] = rep .. line
		end

		-- table.insert(changes, 1, { start = range[1] + 1, final = range[3], formatted = formatted })
	end
end

-- for _, change in ipairs(changes) do
-- 	vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
-- end
-- end
--
vim.api.nvim_create_user_command("JsonDate", function()
	add_lastModified_date()
end, {})
