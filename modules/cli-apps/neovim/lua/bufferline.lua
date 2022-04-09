-- local signs = { error = " ", warning = " ", hint = " ", info = " " }

-- local severities = {
-- 	"error",
-- 	"warning"
-- }

-- require("bufferline").setup {
-- 	show_close_icon = false,
-- 	show_buffer_close_icons = false,
-- 	persist_buffer_sort = true,
-- 	diagnostics = "nvim_lsp",
-- 	always_show_bufferline = false,
-- 	separator_style = "thick",
-- 	diagnostics_indicator = function (_, _, diagnostic)
-- 		local strs = {}
-- 		for _, severity in ipairs(severities) do
-- 			if diagnostic[severity] then
-- 				table.insert(strs, signs[severity] .. diagnostic[severity])
-- 			end
-- 		end

-- 		return table.concat(s, " ")
-- 	end,
-- 	offsets = {
-- 		{ filetype = "NvimTree", text = "NvimTree", highlight = "Directory", text_align = "left" }
-- 	}
-- }

-- local which_key = require("which-key")

-- which_key.register({
-- 	g = {
-- 		name = "Go",
-- 		b = { "<cmd>:BufferLinePick<CR>", "Go to buffer" }
-- 	}
-- }, { mode = "n", noremap = true, silent = true })
