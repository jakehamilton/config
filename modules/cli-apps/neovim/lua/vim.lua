vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.timeoutlen = 250
-- vim.opt.ttimeoutlen = 0

vim.opt.autoindent = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable spell checking.
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{
		pattern = { "*.txt", "*.md", "*.tex" },
		command = "setlocal spell",
	}
)

-- Use <C-Space> to open up autocompletion.
-- @NOTE(jakehamilton): This is now handled by cmp-nvim.
-- vim.api.nvim_set_keymap("i", "<C-Space>", "<C-x><C-o>", {
-- 	silent = true,
-- 	noremap = true,
-- })
