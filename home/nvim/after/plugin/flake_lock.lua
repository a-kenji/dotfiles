-- parsing lastModified value from the flake.lock file
local query = vim.treesitter.query.parse(
	"json",
	[[
(pair
key: (string (string_content) @content (#eq? @content "lastModified"))
value: (number) @value
)
]]
)
-- (apply_expression
-- function: (apply_expression (select_expression))
-- argument: (indented_string_expression) @value
-- )

local Job = require("plenary.job")

local ns = vim.api.nvim_create_namespace("flake-lock-date")

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
	local bin = vim.api.nvim_get_runtime_file("date", false)[1]
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local changes = {}
	for id, node, metadata in query:iter_captures(tree:root(), bufnr, 0, -1) do
		if id == 2 then
			local text = vim.treesitter.get_node_text(node, bufnr)
			local node_start = node:start()
			local node_end = node:end_()
			local result = "date -d @" .. text .. " --rfc-3339=date"
			local handle = io.popen(result)
			if handle then
				local output = handle:read("*a")
				if handle then
					handle:close()
					output = output:sub(1, -2)
					text = { output }
					vim.api.nvim_buf_set_extmark(bufnr, ns, node_start, 0, {
						virt_text = { text },
					})
				end
			end
		end
	end
end

-- expose the function to the user
vim.api.nvim_create_user_command("JsonDate", function()
	add_lastModified_date()
end, {})

-- create augroup for the conversion
local group = vim.api.nvim_create_augroup("json-date-conversion", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = "flake.lock",
	callback = function()
		add_lastModified_date()
	end,
})
