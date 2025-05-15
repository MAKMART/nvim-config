return require('packer').startup(function(use)
    -- Packer can manage itself
    use {
	'wbthomason/packer.nvim'
    }

    -- Lualine with optional icons
    use {
	'nvim-lualine/lualine.nvim',
	requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- flexoki colorscheme
    use {
	'kepano/flexoki-neovim'
    }
    -- Telescope for fuzzy finding
    use {
	'nvim-telescope/telescope.nvim',
	requires = { 'nvim-lua/plenary.nvim' }
    }
    -- Treesitter for enhanced syntax highlighting
    use {
	'nvim-treesitter/nvim-treesitter',
	run = ':TSUpdate'
    }
    use {
	'nvim-treesitter/playground'
    }

    -- Harpoon for project navigation
    use {
	'theprimeagen/harpoon'
    }

    -- Git integration
    use {
	"kdheepak/lazygit.nvim",
	-- optional for floating window border decoration
	requires = {
	    "nvim-lua/plenary.nvim",
	},
	config = function()
	    vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })
	end,
    }

    -- Undo tree for history visualization
    use {
	'mbbill/undotree'
    }

    -- LSP and autocompletion setup using lsp-zero
    use {
	"williamboman/mason.nvim",
	run = ":MasonUpdate",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
    }
    use { "ellisonleao/gruvbox.nvim" }

    -- Ripgrep for finding strings in files
    use {
	'iruzo/ripgrep.nvim',
	version = '*',
	build = ':lua require("rg_setup").install_rg()'
    }

    use {
	"hrsh7th/nvim-cmp",
	requires = {
	    "hrsh7th/cmp-nvim-lsp",
	    "hrsh7th/cmp-buffer",
	    "hrsh7th/cmp-path",
	    "hrsh7th/cmp-cmdline",
	    "L3MON4D3/LuaSnip",
	},
    }
    use  {
	'nvim-telescope/telescope-fzy-native.nvim',
	config = function()
	    require('telescope').load_extension('fzy_native')
	end
    }

end)
