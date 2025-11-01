return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"b0o/SchemaStore.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	opts = {
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			},
			-- go
			gopls = {},
			templ = {},
			-- py
			pyright = {},
			-- js
			ts_ls = {
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false

					vim.opt.tabstop = 2
					vim.opt.shiftwidth = 2
					vim.opt.expandtab = true
					vim.opt.autoindent = true
				end,
			},
			vtsls = {},
			-- other
			htmx = {},
		},
	},
	config = function(_, opts)
		local keymap = vim.keymap -- for conciseness
		local blink = require("blink.cmp")

		for server, config in pairs(opts.servers) do
			config.capabilities = blink.get_lsp_capabilities(config.capabilities)
			vim.lsp.config(server, config)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local options = { buffer = ev.buf, silent = true }

				-- set keybinds
				options.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", options) -- show definition, references

				options.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, options) -- go to declaration

				options.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", options) -- show lsp definitions

				options.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", options) -- show lsp implementations

				options.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", options) -- show lsp type definitions

				options.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, options) -- see available code actions, in visual mode will apply to selection

				options.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options) -- smart rename

				options.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", options) -- show  diagnostics for file

				options.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, options) -- show diagnostics for line

				options.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, options) -- jump to previous diagnostic in buffer

				options.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, options) -- jump to next diagnostic in buffer

				options.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, options) -- show documentation for what is under cursor

				options.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", options) -- mapping to restart lsp if necessary
			end,
		})

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.WARN] = " ",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				},
			},
		})
	end,
}
