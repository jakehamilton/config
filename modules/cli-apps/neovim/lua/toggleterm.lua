local colors = require("nord.named_colors")

if vim.bo.filetype ~= "pager" and vim.bo.filetype ~= "man" then
	require("toggleterm").setup {
		open_mapping = [[<c-\>]],
		close_on_exit = true,
		shell = vim.o.shell,
		auto_scroll = true,
		direction = "float",
		shade_terminals = false,
		size = function(term)
			if term.direction == "horizontal" then
				return 20
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		float_opts = {
			border = "curved",
			winblend = 3,
		},
	}
end
