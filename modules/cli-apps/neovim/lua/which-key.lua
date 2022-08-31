local which_key = require("which-key")

which_key.setup {}

which_key.register({
	f = {
		name = "File",
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" }
	},
	b = {
		name = "Buffer",
		d = { "<cmd>:BD<cr>", "Delete Buffer" },
		n = { "<cmd>:bnext<cr>", "Next Buffer" },
		p = { "<cmd>:bprevious<cr>", "Previous Buffer" },
	},
}, { mode = "n", prefix = "<leader>" })
