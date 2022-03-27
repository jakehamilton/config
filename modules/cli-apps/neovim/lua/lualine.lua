require("lualine").setup {
	options = {
		theme = "nord",
		component_separators = "|",
    section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2 },
    },
    lualine_b = { "filename", "branch" },
    lualine_c = { "fileformat", "lsp_progress" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = {
      { "location", separator = { right = "" }, left_padding = 2 },
    },
	},
	inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
	tabline = {},
	extensions = {}
}
