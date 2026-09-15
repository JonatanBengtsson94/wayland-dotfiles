return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.load_extension("fzf")

		--keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
		keymap.set("n", "<leader>ft", "<cmd>Telescope live_grep<cr>")

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					"target", -- Ignore rust build folder
				},
			},
		})
	end,
}
