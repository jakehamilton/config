local colors = require("nord.named_colors")
local Terminal = require("toggleterm.terminal").Terminal

_G.log = ""

local function log(msg)
	if _G.log == "" then
		_G.log = msg
	else
		_G.log = _G.log .. " | " .. msg
	end
end

local function bool_to_string(bool)
	if bool then
		return "true"
	else
		return "false"
	end
end

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }

	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local is_floating_terminal_mapped = false

local term = Terminal:new {
	cmd = vim.o.shell,
	direction = "float",
	close_on_exit = true,
	auto_scroll = true,
	shade_terminals = false,
	hidden = true,
	on_open = function(t)
		if not is_floating_terminal_mapped then
			vim.api.nvim_buf_set_keymap(t.bufnr, "t", [[<C-\>]], "", {
				noremap = true,
				callback = function()
					t:toggle()
				end,
			})

			is_floating_terminal_mapped = true
		end

		vim.api.nvim_command("startinsert")
	end
}

-- vim.api.nvim_buf_set_keymap(term.bufnr, "t", [[<C-\>]], "", {
-- 	noremap = true,
-- 	callback = function()
-- 		term:toggle()
-- 	end,
-- })

-- vim.api.nvim_buf_get_option(_G.some_buf.id, "filetype")

local function handle_buffer_enter(event)
	local filetype = vim.api.nvim_buf_get_option(event.buf, "filetype")
	-- local is_loaded = vim.api.nvim_buf_is_loaded(event.buf)
	-- local name = vim.api.nvim_buf_get_name(event.buf)

	-- log("name=" .. name)
	-- log("filetype=" .. filetype)
	-- log("is_loaded=" .. bool_to_string(is_loaded))

	if filetype ~= "pager" and filetype ~= "man" then
		vim.api.nvim_buf_set_keymap(event.buf, "n", [[<C-\>]], "", {
			noremap = true,
			callback = function()
				term:toggle()
			end,
		})
	else
		vim.api.nvim_command("norm gg")

		vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<cmd>q!<cr>", {
			noremap = true,
		})
	end
end

vim.api.nvim_create_autocmd(
	{ "FileType" },
	{
		pattern = "*",
		callback = handle_buffer_enter,
	}
)


-- require("toggleterm").setup {
-- 	open_mapping = [[<c-\>]],
-- 	close_on_exit = true,
-- 	shell = vim.o.shell,
-- 	auto_scroll = true,
-- 	direction = "float",
-- 	shade_terminals = false,
-- 	on_open = function()
-- 		log("on open: vim.bo.filetype =" .. vim.bo.filetype)
-- 		vim.cmd("lua =vim.bo.filetype")
-- 	end,
-- 	size = function(term)
-- 		if term.direction == "horizontal" then
-- 			return 20
-- 		elseif term.direction == "vertical" then
-- 			return vim.o.columns * 0.4
-- 		end
-- 	end,
-- 	float_opts = {
-- 		border = "curved",
-- 		winblend = 3,
-- 	},
-- }
