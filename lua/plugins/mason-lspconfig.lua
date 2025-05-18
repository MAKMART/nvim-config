return {
  "williamboman/mason-lspconfig.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall" },
  dependencies = {
    { "williamboman/mason.nvim", lazy = true },
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "clangd", "cmake", "jdtls" },
      automatic_installation = true,
    })
  end,
}
