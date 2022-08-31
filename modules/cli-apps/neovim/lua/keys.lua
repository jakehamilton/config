local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }

	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- @NOTE(jakehamilton): This is now handled by Tilish.
-- Window movement.
-- map("n", "<C-h>", "<C-w>h", { silent = true })
-- map("n", "<C-j>", "<C-w>j", { silent = true })
-- map("n", "<C-k>", "<C-w>k", { silent = true })
-- map("n", "<C-l>", "<C-w>l", { silent = true })

-- Exit terminal mode.
map("t", "<C-o>", "<C-\\><C-n>", { silent = true })
