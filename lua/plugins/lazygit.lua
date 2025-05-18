return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit", -- 👈 Load only when :LazyGit is used
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
  },
}
