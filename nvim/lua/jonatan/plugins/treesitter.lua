return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"json",
			"go",
			"javascript",
			"html",
			"css",
			"markdown",
			"bash",
			"lua",
			"c",
			"gitignore",
			"typescript",
			"tsx",
			"sql",
			"rust",
		}

		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers,
			callback = function(args)
				-- syntax highlighting
				vim.treesitter.start(args.buf)
				-- indentation
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
