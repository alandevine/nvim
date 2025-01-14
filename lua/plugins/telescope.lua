return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})
		telescope.load_extension("fzf")

		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {desc="Find Files"})
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {desc="File history"})
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", {desc="Live grep"})
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {desc="Grep String"})
		keymap.set("n", "<leader>fp", require("telescope.builtin").diagnostics, { desc = "Telescope Diagnostics" }))
	end,
}
