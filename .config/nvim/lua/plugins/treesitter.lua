return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
		},
		keys = {
			{
				"<leader>rc",
				-- TODO: Move to a separeate file + only add this Keybind if it's Python file
				function()
					require("utils.python").copy_python_path()
				end,
				mode = "n",
				desc = "Copy Python module",
			},
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"c",
				"rust",
				"help",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
