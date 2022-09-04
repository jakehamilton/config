local which_key = require("which-key");

require("icon-picker").setup {
	disable_legacy_commands = true,
}

which_key.register({
	["i"] = {
		name = "Icon Picker",
		i = { "<cmd>IconPickerInsert emoji nerd_font alt_font symbols<cr>", "Insert Icon" },
		y = { "<cmd>IconPickerYank emoji nerd_font alt_font symbols<cr>", "Yank Icon" },
	},
}, { mode = "n", prefix = "<leader>", silent = true })
