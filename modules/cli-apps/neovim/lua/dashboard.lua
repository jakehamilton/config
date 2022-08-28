local home = os.getenv("HOME")
local db = require("dashboard")

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
		shortcut = "SPC f h",
		action = "DashboardFindHistory",
	},
	{
		icon = "  ",
		desc = "Open File                            ",
		shortcut = "SPC f b",
		action = "Telescope file_browser",
	},
	{
		icon = "  ",
		desc = "Open Dotfiles                        ",
		shortcut = "SPC f d",
		action = "Telescope path=" .. home .. "/work/config",
	},
}
