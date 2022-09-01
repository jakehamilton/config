local lsp = require("lspconfig")
local illuminate = require("illuminate")

-- @TODO(jakehamilton): Customize this snippet taken from
-- 	https://github.com/neovim/nvim-lspconfig
local which_key = require("which-key")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }

-- vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
-- vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, buffer)
	illuminate.on_attach(client)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(buffer, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	which_key.register({
		g = {
			name = "Go",
			d = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to definition" },
			D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
			h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
			n = { "<cmd>lua require('illuminate').next_reference{wrap=true}<cr>", "Go to next occurrence" },
			p = { "<cmd>lua require('illuminate').next_reference{reverse=true,wrap=true}<cr>", "Go to previous occurrence" },
			r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to references" },
			t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
			["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" }
		}
	}, { buffer = buffer, mode = "n", noremap = true, silent = true })

	which_key.register({
		w = {
			name = "Workspace",
			a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add workspace" },
			l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List workspaces" },
			r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove workspace" },
		},
		c = {
			name = "Code",
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
			f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		}
	}, { buffer = buffer, mode = "n", prefix = "<leader>", noremap = true, silent = true })
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- lsp.gopls.setup {}
-- lsp.tsserver.setup {}
-- lsp.rust_analyzer.setup {}

-- @TODO(jakehamilton): Add support for tailwind. Requires
-- 	adding @tailwindcss/language-server.
-- lsp.tailwindcss.setup {}

-- @TODO(jakehamilton): Add support for cssmodules. Requires
-- 	adding cssmodules-language-server.
-- lsp.cssmodules_ls.setup {}

-- @TODO(jakehamilton): Add support for vim. Requires
-- 	adding vim-language-server.
-- lsp.vim.setup {}

-- @TODO(jakehamilton): Add support for bash. Requires
-- 	adding bash-language-server.
-- lsp.bashls.setup {}

-- sumneko-lua-language-server.
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
-- lsp.sumneko_lua.setup {
-- 	on_attach = on_attach,
-- 	cmd = { "lua-language-server" },
-- 	settings = {
-- 		Lua = {
-- 			telemetry = {
-- 				enable = false
-- 			},
-- 			format = {
-- 				enable = true,
-- 				defaultConfig = {
-- 					indent_style = "space",
-- 					indent_size = "2"
-- 				}
-- 			}
-- 		}
-- 	}
-- }

-- vscode-langservers-extracted
-- lsp.html.setup {}
-- lsp.cssls.setup {}
-- lsp.jsonls.setup {}
-- lsp.eslint.setup {}

-- @TODO(jakehamilton): Add support for docker. Requires
-- 	adding dockerfile-language-server-nodejs.
-- lsp.dockerls.setup {}

-- @TODO(jakehamilton): Add support for nix. Requires
-- 	adding (from Nix) rnix-lsp.
-- lsp.rnix.setup {}

-- @TODO(jakehamilton): Add support for yaml. Requires
-- 	adding yaml-language-server.
-- lsp.yamlls.setup {}

-- @TODO(jakehamilton): Add support for sql. Requires
-- 	adding (from Nix) sqls.
-- lsp.sqls.setup {}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches.
local servers = { 'rust_analyzer', 'tsserver', 'gopls', 'html', 'cssls', 'jsonls', 'eslint', 'rnix' }
for _, name in pairs(servers) do
	require('lspconfig')[name].setup {
		on_attach = on_attach,
		flags = {
			-- This will be the default in neovim 0.7+
			debounce_text_changes = 150,
		}
	}
end

-- Customize LSP diagnostics.
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "●" },
	severity_sort = true,
})

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Auto format.
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
vim.api.nvim_create_autocmd(
	{ "BufWritePre" },
	{
		pattern = { "*" },
		callback = function()
			---@diagnostic disable-next-line: missing-parameter
			vim.lsp.buf.formatting_sync()
		end,
	}
)

-- Disable the preview window for omnifunc use.
vim.cmd [[
	set completeopt=menu
]]
