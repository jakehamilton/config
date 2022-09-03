local which_key = require("which-key")

require("hop").setup()

which_key.register({
	["<leader>"] = {
		name = "Hop",
		a = {
			"<cmd>HopAnywhere<cr>",
			"Hop Anywhere"
		},
		c = {
			"<cmd>HopChar1<cr>",
			"Hop To Character"
		},
		C = {
			"<cmd>HopChar2<cr>",
			"Hop To Characters"
		},
		l = {
			"<cmd>HopLineStart<cr>",
			"Hop To Line Start"
		},
		L = {
			"<cmd>HopLine<cr>",
			"Hop To Line"
		},
		v = {
			"<cmd>HopVertical<cr>",
			"Hop Vertically"
		},
		p = {
			"<cmd>HopPattern<cr>",
			"Hop To Pattern"
		},
		b = {
			"<cmd>HopWordBC<cr>",
			"Hop To Previous Word"
		},
		w = {
			"<cmd>HopWordAC<cr>",
			"Hop To Next Word"
		},
		W = {
			"<cmd>HopWord<cr>",
			"Hop To Word"
		}
	},
}, {
	mode = "n",
	prefix = "<leader>",
	silent = true,
})
