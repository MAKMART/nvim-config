return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		-- load default gruvbox setup
		require("gruvbox").setup({})

		-- your highlight overrides
		vim.cmd.colorscheme("gruvbox")
		vim.cmd("highlight! link NormalFloat Normal")
		vim.cmd("highlight! link FloatBorder Normal")
	end,
}
