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
