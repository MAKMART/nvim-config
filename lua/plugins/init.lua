return {
  -- lazy can manage itself (not required but nice)
  { "folke/lazy.nvim" },

  -- Lualine + Icons
  require("plugins.lualine"),

  -- Colorschemes
  require("plugins.colors"),

  -- Telescope and dependencies
  require("plugins.telescope"),

  -- Treesitter
  require("plugins.treesitter"),

  -- Harpoon
  require("plugins.harpoon"),

  -- Git integration
  require("plugins.lazygit"),

  -- UndoTree
  require("plugins.undotree"),

  -- LSP and Completion
  require("plugins.mason"),
  require("plugins.mason-lspconfig"),
  require("plugins.lspconfig"),
  require("plugins.cmp"),

  -- Ripgrep
  require("plugins.ripgrep"),
}
