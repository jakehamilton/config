require("nvim-treesitter.configs").setup {
	indent = {
		enable = true,
	},
}

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.o.foldenable = false
vim.o.foldlevel = 99
