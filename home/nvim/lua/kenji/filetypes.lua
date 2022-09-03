-- Custom filetype detection logic with the new Lua filetype plugin
vim.filetype.add({
	extension = {
		png = "image",
		jpg = "image",
		jpeg = "image",
		gif = "image",
		es6 = "javascript",
	},
	filename = {
		[".eslintrc"] = "json",
		[".prettierrc"] = "json",
		[".babelrc"] = "json",
		[".stylelintrc"] = "json",
		[".envrc"] = "sh",
		[".mob"] = "sh",
	},
	pattern = {
		[".*config/git/config"] = "gitconfig",
		[".env.*"] = "sh",
	},
})
