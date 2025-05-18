return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope", -- lazy-load on command
  keys = {
    { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Search git files" },
    { "<leader>pf", function() require("telescope.builtin").find_files({ cwd = "" }) end, desc = "Find files in directory" },
    { "<leader>ps", function() require("telescope.builtin").live_grep({ cwd = "" }) end, desc = "Grep in files in directory" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzy-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzy_native")
      end,
    },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_config = {
          horizontal = { preview_width = 0.5 },
        },
        file_ignore_patterns = { "node_modules", "%.git/" },
      },
    })
  end,
}
