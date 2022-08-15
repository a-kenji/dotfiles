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
