local colors = require("nord.named_colors")
local theme = require("lualine.themes.nord")


-- Color the mode of the status line.
theme.visual.a.bg = colors.purple
theme.visual.a.fg = colors.white

-- Color the info area of the status line.
theme.normal.b.bg = colors.dark_gray
theme.normal.b.fg = colors.white

-- Color the center area of the status line.
theme.normal.c.bg = colors.black
theme.inactive.c.bg = colors.black

-- This is a workaround for coloring not working on the ends of
-- the status line. Without this, the background of the first and
-- last characters are not written correctly.
local empty = {
  function() return ' ' end,
  padding = 0,
  color = 'Normal',
}

require("lualine").setup {
  extensions = { "quickfix", "nvim-tree", "toggleterm", "fzf" },
  options = {
    theme = theme,
    component_separators = "",
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      empty,
      { "mode", separator = { left = "", right = "" }, right_padding = 2 },
    },
    lualine_b = { "filename", "branch" },
    lualine_c = { "fileformat", "diagnostics", "lsp_progress" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = {
      { "location", separator = { left = "", right = "" }, left_padding = 2,
        color = { fg = colors.white, bg = colors.off_blue } },
      empty,
    },
  },
  inactive_sections = {
    lualine_a = {
      empty,
      { "mode", separator = { left = "", right = "" }, right_padding = 2 },
    },
    lualine_b = { "filename", "branch" },
    lualine_c = { "fileformat", "diagnostics", "lsp_progress" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = {
      { "location", separator = { left = "", right = "" }, left_padding = 2,
        color = { fg = colors.white, bg = colors.off_blue } },
      empty,
    },
  },
  tabline = {},
}
