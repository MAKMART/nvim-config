return {
    -- 1. mason.nvim 🚀
    {
	"williamboman/mason.nvim",
	build  = ":MasonUpdate",
	config = function()
	    require("mason").setup()
	end,
    },

    -- 2. mason-lspconfig.nvim 🔧 (only ensures installation)
    {
	"williamboman/mason-lspconfig.nvim",
	config = function()
	    require("mason-lspconfig").setup({
		ensure_installed = require("plugins.lsp.servers"),
		automatic_installation = true, -- optional, keep if desired
		-- note: v2 auto-installs missing ones on first startup
	    })
	end,
    },
   -- 3. nvim-lspconfig 🤖 (manual setup of each server)
    {
	"neovim/nvim-lspconfig",
	config = function()
	    local lspconfig    = require("lspconfig")
	    local cmp_cap      = require("cmp_nvim_lsp").default_capabilities()
	    local servers      = require("plugins.lsp.servers")
	    local stddata = vim.fn.stdpath("data")

	    local on_attach = function(client, bufnr)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
		vim.keymap.set("n", "K",  vim.lsp.buf.hover,      { buffer = bufnr, desc = "Hover Documentation" })
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: Rename' })	-- To rename the variable currently under the cursor
	    end

	    -- Returns the absolute path to a Mason-installed binary, or nil.
	    local function mason_bin(name)
		local path = vim.fs.joinpath(stddata, "mason", "bin", name)
		return vim.fn.executable(path) == 1 and path or nil
	    end
	    local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
	    local msys2_driver = "C:/msys64/mingw64/bin/c++.exe"
	    local has_msys2 = vim.fn.executable(msys2_driver) == 1

	    -- base clangd binary (Mason or fallback)
	    local bin = mason_bin("clangd") or "clangd"

	    local cmd = { bin }

	    -- always include compile-commands-dir
	    local root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(vim.fn.getcwd())
	    if root_dir then
		local compile_commands_dir = vim.fs.joinpath(root_dir, "build")
		table.insert(cmd, "--compile-commands-dir=" .. compile_commands_dir)
	    end

	    -- only on Windows + MSYS2, add query-driver
	    if is_windows and has_msys2 then
		table.insert(cmd, "--query-driver=" .. msys2_driver)
	    end

	    -- Make sure to have clang-tidy (part of the clang package) installed in your system i.e. available via: clang-tidy
	    table.insert(cmd, "--clang-tidy")

	    for _, name in ipairs(servers) do
		-----------------------------------
		-- clangd: use Mason's binary if present
		-----------------------------------
		if name == "clangd" then
		    if not mason_bin("clangd") then
			vim.notify("⚠️  Using system clangd (Mason one not installed)", vim.log.levels.WARN)
		    end
		    lspconfig.clangd.setup({
			cmd          = cmd,
			capabilities = cmp_cap,
			on_attach    = on_attach,
		    })

		    -----------------------------------
		    -- lua_ls
		    -----------------------------------
		elseif name == "lua_ls" then
		    lspconfig.lua_ls.setup({
			capabilities = cmp_cap,
			on_attach    = on_attach,
			settings     = {
			    Lua = {
				runtime   = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace   = {
				    library         = vim.api.nvim_get_runtime_file("", true),
				    checkThirdParty = false,
				},
				telemetry  = { enable = false },
			    },
			},
		    })

		    -----------------------------------
		    -- pyright
		    -----------------------------------
		elseif name == "pyright" then
		    lspconfig.pyright.setup({
			capabilities = cmp_cap,
			on_attach    = on_attach,
			settings     = {
			    python = {
				analysis = {
				    autoSearchPaths        = true,
				    useLibraryCodeForTypes = true,
				    diagnosticMode         = "workspace",
				},
			    },
			},
		    })

		    -----------------------------------
		    -- any other server: default setup
		    -----------------------------------
		else
		    lspconfig[name].setup({
			capabilities = cmp_cap,
			on_attach    = on_attach,
		    })
		end
	    end
	end,
    },
}
