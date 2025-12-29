return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    config = function()
	    require'nvim-treesitter'.setup {
		    ensure_installed = { "bash", "css", "html", "javascript", "json", "lua", "markdown", "python" },
		    sync_install = false, -- don't block on startup
		    auto_install = true,  -- install missing parsers when entering buffer
		    highlight = {
			    enable = true,
		    },
		    -- optional: custom install dir
		    parser_install_dir = vim.fn.stdpath('data') .. '/site',
	    }
    end,
}
