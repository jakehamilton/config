vim.api.nvim_create_augroup("bufcheck", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = "bufcheck",
	pattern = { "gitcommit", "gitrebase" },
	command = "startinsert | 1",
})
