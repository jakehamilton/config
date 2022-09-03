local home = os.getenv("HOME")
local db = require("dashboard")

db.session_directory = home .. "/.config/dashboard-nvim/";

db.custom_center = {
	{
		icon = "  ",
		desc = "Last session                         ",
		shortcut = "SPC s l",
		action = "SessionLoad",
	},
	{
		icon = "  ",
		desc = "Recent Files                         ",
		shortcut = "SPC f r",
		action = "Telescope oldfiles",
	},
	{
		icon = "  ",
		desc = "Open File                            ",
		shortcut = "SPC f f",
		action = "Telescope find_files",
	},
	{
		icon = "  ",
		desc = "Open Dotfiles                        ",
		shortcut = "SPC f d",
		action = "Telescope path=" .. home .. "/work/config",
	},
}
