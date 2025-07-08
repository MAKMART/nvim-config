return {
    "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  lazy = true,
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", "c", "cpp", "css", "html", "javascript",
        "json", "lua", "markdown", "python",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
