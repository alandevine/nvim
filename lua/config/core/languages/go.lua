vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})

local lspconfig = require("lspconfig")

local servers = { "gopls", "ccls", "cmake", "templ" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

vim.keymap.set("n", "<leader>gie", "<cmd>GoIfErr<CR>", { desc = "Adds go if error boilerplate" })
vim.keymap.set("n", "<leader>gatj", "<cmd>GoAddTag json<CR>", { desc = "Adds json tags to struct" })
vim.keymap.set("n", "<leader>gaty", "<cmd>GoAddTag yaml<CR>", { desc = "Adds yaml tags to struct" })
vim.keymap.set("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", { desc = "Fills Struct" })
vim.keymap.set("n", "<leader>gaat", "<cmd>GoAddAllTest<CR>", { desc = "Adds tests file" })

vim.filetype.add({ extension = { templ = "templ" } })
