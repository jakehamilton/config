require("todo-comments").setup {
	keywords = {
		FIX = {
			icon = " ", -- icon used for the sign, and in search results
			color = "error", -- can be a hex color, or a named color (see below)
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
			-- signs = false, -- configure signs for some keywords individually
		},
		TODO = { icon = " ", color = "info" },
		HACK = { icon = " ", color = "warning", alt = { "HACK", "DRAGONS" } },
		WARN = { icon = " ", color = "warning", alt = { "WARNING", "WARNING", "WARN" } },
		PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "PERF", "PERFORMANCE" } },
		NOTE = { icon = " ", color = "hint", alt = { "INFO", "NOTE", "INFO" } },
	},
	merge_keywords = false,
	highlight = {
		pattern = [[.*(@)?(KEYWORDS)\(\s*\)\s*]],
		after = ""
	},
	search = {
		pattern = [[\b@(KEYWORDS)(\(\s*\))\s*:]]
	}
}
