return {
    "iruzo/ripgrep.nvim",
    version = "*",
    build = function()
	require("rg_setup").install_rg()
    end,
}
