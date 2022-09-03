local which_key = require("which-key")

require("twilight").setup {}

which_key.register({
	t = {
		name = "Toggle",
		T = { "<cmd>Twilight<cr>", "Toggle Twilight" }
	},
}, { mode = "n", prefix = "<leader>", silent = true })
