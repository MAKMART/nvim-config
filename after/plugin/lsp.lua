local lsp = require("lspconfig")
require("mason").setup({
    ui = {
        border = "rounded", -- optional for UI appearance
    }
})
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd", "cmake", "jdtls" }
})

local on_attach = function (_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end
lsp.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT", -- or "Lua 5.1", "Lua 5.2", etc.
            },
            diagnostics = {
                globals = { "vim" }, -- Add Neovim globals
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
                checkThirdParty = false, -- Disable third-party checks for performance
            },
            telemetry = { enable = false }, -- Disable telemetry if you prefer
        },
    },
})

lsp.clangd.setup {
    on_attach = on_attach,
    cmd = { "clangd", "--background-index" },
    filetypes = {"c", "cpp", "objc", "objcpp"},
    root_dir = lsp.util.root_pattern("compile_commands.json", ".git", "CMakeLists.txt"),
    settings = {
	clangd = {
	    fallbackFlags = {
	    },
	},
    },
}
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
    }),
})
