return {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
	local lsp = require("lspconfig")

	local on_attach = function(_, _)
	    local opts = { noremap = true, silent = true }
	    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
	    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	end

	-- Lua LSP setup
	lsp.lua_ls.setup({
	    on_attach = on_attach,
	    settings = {
		Lua = {
		    runtime = { version = "LuaJIT" },
		    diagnostics = { globals = { "vim" } },
		    workspace = {
			library = vim.api.nvim_get_runtime_file("", true),
			checkThirdParty = false,
		    },
		    telemetry = { enable = false },
		},
	    },
	})

	-- C/C++ LSP setup
	lsp.clangd.setup({
	    on_attach = on_attach,
	    cmd = { "clangd", "--background-index" },
	    filetypes = { "c", "cpp", "objc", "objcpp" },
	    root_dir = lsp.util.root_pattern("compile_commands.json", ".git", "CMakeLists.txt"),
	    settings = {
		clangd = {
		    fallbackFlags = {},
		},
	    },
	})
    end,
}
