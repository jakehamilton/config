local which_key = require("which-key")

require("telescope").setup {
	defaults = {
		mappings = {
			i = {
				["<C-h>"] = "which_key"
			},
		},
	},
}

which_key.register({
	f = {
		name = "File",
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
		g = { "<cmd>Telescope live_grep<cr>", "Grep" },
		b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
	},
}, { mode = "n", prefix = "<leader>", silent = true })
