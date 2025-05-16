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
