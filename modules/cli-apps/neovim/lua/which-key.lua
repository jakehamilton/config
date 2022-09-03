local which_key = require("which-key")

which_key.setup {}

which_key.register({
	b = {
		name = "Buffer",
		d = { "<cmd>:BD<cr>", "Delete Buffer" },
		n = { "<cmd>:bnext<cr>", "Next Buffer" },
		p = { "<cmd>:bprevious<cr>", "Previous Buffer" },
	},
	t = {
		name = "Toggle",
		h = {
			function()
				if vim.o.hlsearch then
					vim.o.hlsearch = false
				else
					vim.o.hlsearch = true
				end
			end,
			"Highlight"
		},
	},
	s = {
		name = "Session",
		s = { "<cmd>SessionSave<cr>", "Save" },
		l = { "<cmd>SessionLoad<cr>", "Load" },
	},
}, { mode = "n", prefix = "<leader>" })
