return {
  { "folke/lazy.nvim" },
  require("plugins.lsp.lsp-config"),
  require("plugins.lualine"),
  require("plugins.colors"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.harpoon"),
  require("plugins.lazygit"),
  require("plugins.undotree"),
  require("plugins.ripgrep"),

  require("plugins.lsp.cmp")
}
