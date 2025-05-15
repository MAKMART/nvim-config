local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set("n", "<leader>pf", function()
  require("telescope.builtin").find_files({ cwd = ".." })
end, { desc = "Find files in parent directory" })
vim.keymap.set("n", "<leader>ps", function()
  require("telescope.builtin").live_grep({ cwd = ".." })
end, { desc = "Grep in files in parent directory" })
