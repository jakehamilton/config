local which_key = require("which-key")

which_key.setup {}

which_key.register({
	f = {
		name = "File",
		f = { "<cmd>Telescope find_files<cr>", "Find File"},
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" }
	},
}, { mode = "n", prefix = "<leader>"})
