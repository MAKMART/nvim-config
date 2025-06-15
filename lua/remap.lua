vim.g.mapleader = " " -- Set the leader key

-- Correctly map the keys with <CR> at the end
vim.api.nvim_set_keymap('n', '<leader>pv', ':Explore<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pf', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Go to the next tab (using Tab)
vim.api.nvim_set_keymap('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true })

-- Go to the previous tab (using Shift-Tab)
vim.api.nvim_set_keymap('n', '<S-Tab>', ':tabprev<CR>', { noremap = true, silent = true })

-- Open a new tab with Ctrl+t
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })

-- Rename symbol under cursor
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: Rename Symbol' })

-- Scroll view down while cursor stays visually fixed
vim.keymap.set("n", "<C-j>", function()
  vim.cmd("normal! j")  -- move cursor down
  vim.cmd("normal! zz") -- center cursor again
end, { desc = "Scroll down, keep cursor fixed" })

-- Scroll view up while cursor stays visually fixed
vim.keymap.set("n", "<C-k>", function()
  vim.cmd("normal! k")
  vim.cmd("normal! zz")
end, { desc = "Scroll up, keep cursor fixed" })


-- This will check for overall code correctness
vim.keymap.set("n", "<leader>ct", function()
  vim.lsp.buf.code_action({
    context = {
      diagnostics = {}, -- trigger all
    },
  })
end, { desc = "Run clang-tidy via LSP" })

-- This will style and order the code
vim.keymap.set('n', '<leader>cf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer with clang-format" })


-- Remap split navigation
vim.keymap.set('n', '<Leader>h', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<Leader>j', '<C-w>j', { desc = 'Move to down split' })
vim.keymap.set('n', '<Leader>k', '<C-w>k', { desc = 'Move to up split' })
vim.keymap.set('n', '<Leader>l', '<C-w>l', { desc = 'Move to right split' })

-- Optional: If you also want to cycle through splits with <Leader>w
vim.keymap.set('n', '<Leader>w', '<C-w>w', { desc = 'Cycle through splits' })



-- Check if the keymap exists before removing it
local function remove_keymap(mode, key)
  local current_map = vim.api.nvim_get_keymap(mode)
  for _, mapping in ipairs(current_map) do
    if mapping.lhs == key then
      vim.api.nvim_del_keymap(mode, key)
      return
    end
  end
end

-- Now use this function to remove the mapping if it exists
remove_keymap('n', '<C-w>d')

-- Close the current tab with Ctrl+w (Remap from default window behavior)
vim.api.nvim_set_keymap('n', '<C-w>', ':tabclose<CR>', { noremap = true, silent = true })
