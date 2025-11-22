return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		-- list of servers to automatically install (MUST match the names used by nvim-lspconfig)
		ensure_installed = {
			"pyright",
			"rust_analyzer",
			"clangd",
		},


	},
	dependencies = {
		{

			"williamboman/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},
		"neovim/nvim-lspconfig"

	}
}
