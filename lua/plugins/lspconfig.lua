return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- 👈 Delay loading until an actual file
    dependencies = {
	{
	    "williamboman/mason-lspconfig.nvim",
	    lazy = true,
	},
    },
    config = function()
	local lspconfig = require("lspconfig")

	-- Common on_attach for all servers
	local on_attach = function(_, bufnr)
	    local map = function(mode, lhs, rhs)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
	    end

	    map("n", "<leader>rn", vim.lsp.buf.rename)
	    map("n", "<leader>ca", vim.lsp.buf.code_action)
	    map("n", "gd", vim.lsp.buf.definition)
	    map("n", "gi", vim.lsp.buf.implementation)
	    map("n", "gr", require("telescope.builtin").lsp_references)
	    map("n", "K", vim.lsp.buf.hover)
	end

	-- Common flags (optional, debounce input lag for LSP)
	local flags = {
	    debounce_text_changes = 150,
	}

	-- Lua LSP (for Neovim config dev)
	lspconfig.lua_ls.setup({
	    on_attach = on_attach,
	    flags = flags,
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

	lspconfig.cmake.setup({
	    cmd = { "C:\\Users\\Marco Martin\\AppData\\Local\\Programs\\Python\\Python313\\python.exe", "-m", "cmake-language-server" },
	})

	-- C/C++ LSP (Clangd)
	lspconfig.clangd.setup({
	    on_attach = on_attach,
	    flags = flags,
	    cmd = { "clangd", "--background-index" },
	    filetypes = { "c", "cpp", "objc", "objcpp" },
	    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git", "CMakeLists.txt"),
	})
    end,
}
