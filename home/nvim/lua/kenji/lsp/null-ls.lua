require("null-ls").setup({
	log_level = "warn",
	sources = {
		-- require("null-ls").builtins.diagnostics.eslint,
		-- require("null-ls").builtins.completion.spell,
		-- if vim.fn.executable('rg') == 1 then
		--     vim.o.grepprg="rg --vimgrep --hidden --glob ‘!.git’"
		-- end
		-- require("null-ls").builtins.completion.luasnip,

		-- require("null-ls").builtins.code_actions.gitsigns,
		require("null-ls").builtins.code_actions.proselint,
		require("null-ls").builtins.code_actions.shellcheck,

		require("null-ls").builtins.diagnostics.actionlint,
		require("null-ls").builtins.diagnostics.checkmake,
		require("null-ls").builtins.diagnostics.chktex,
		-- require("null-ls").builtins.diagnostics.codespell,
		require("null-ls").builtins.diagnostics.deadnix,
		require("null-ls").builtins.diagnostics.editorconfig_checker.with({
			generator_opts = { command = "editorconfig-checker" },
		}),
		require("null-ls").builtins.diagnostics.fish,
		-- require("null-ls").builtins.diagnostics.flake8,
		-- .with,
		-- ({
		-- 	condition = function(utils)
		-- 		-- return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		-- 		if vim.fn.executable("flake8") ~= 1 then
		-- 			return false
		-- 		end
		-- 		return true
		-- 	end,
		-- }),
		require("null-ls").builtins.diagnostics.luacheck,
		-- require("null-ls").builtins.diagnostics.markdownlint,
		-- .with,
		-- ({
		-- 	condition = function(utils)
		-- 		-- return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		-- 		if vim.fn.executable("markdownlint") ~= 1 then
		-- 			return false
		-- 		end
		-- 		return true
		-- 	end,
		-- }),
		require("null-ls").builtins.diagnostics.mdl,
		-- .with,
		-- ({
		-- 	condition = function(utils)
		-- 		-- return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		-- 		if vim.fn.executable("mdl") ~= 1 then
		-- 			return false
		-- 		end
		-- 		return true
		-- 	end,
		-- }),
		-- require("null-ls").builtins.diagnostics.misspell,
		-- require("null-ls").builtins.diagnostics.mypy,
		require("null-ls").builtins.diagnostics.proselint,
		require("null-ls").builtins.diagnostics.protolint,

		require("null-ls").builtins.formatting.alejandra,
		-- require("null-ls").builtins.formatting.autopep8,
		require("null-ls").builtins.formatting.bibclean,
		-- require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.buf,
		-- require("null-ls").builtins.formatting.codespell,
		require("null-ls").builtins.formatting.fish_indent,
		-- require("null-ls").builtins.formatting.just,
		-- 	.with({
		-- 	condition = function(utils)
		-- 		-- return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		-- 		return utils.is_executable({ "just" })
		-- 	end,
		-- }),
		require("null-ls").builtins.formatting.latexindent,
		require("null-ls").builtins.formatting.nixfmt,
		require("null-ls").builtins.formatting.nixpkgs_fmt,
		-- require("null-ls").builtins.formatting.ocdc,
		-- .with
		-- ({
		-- 	condition = function(utils)
		-- 		-- return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		-- 		if vim.fn.executable("ocdc") ~= 1 then
		-- 			return false
		-- 		end
		-- 		return true
		-- 	end,
		-- }),
		require("null-ls").builtins.formatting.protolint,
		require("null-ls").builtins.formatting.rustfmt,
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.shellharden,
		require("null-ls").builtins.formatting.shfmt,
		-- require("null-ls").builtins.formatting.textlint,
		require("null-ls").builtins.formatting.zigfmt,

		-- require("null-ls").builtins.hover.dictionary,
	},
})
