vim.g.mapleader = " " -- leader key must be set before Lazy.nvim loading!
-- Put all your keymap code inside a function
local function setup_keymaps()

  -- Your keymaps:
  vim.api.nvim_set_keymap('n', '<leader>pv', ':Explore<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>pf', ':Telescope find_files<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<S-Tab>', ':tabprev<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: Rename Symbol' })

  vim.keymap.set("n", "<C-j>", function()
    vim.cmd("normal! j")
    vim.cmd("normal! zz")
  end, { desc = "Scroll down, keep cursor fixed" })

  vim.keymap.set("n", "<C-k>", function()
    vim.cmd("normal! k")
    vim.cmd("normal! zz")
  end, { desc = "Scroll up, keep cursor fixed" })

  vim.keymap.set("n", "<leader>ct", function()
    vim.lsp.buf.code_action({ context = { diagnostics = {} } })
  end, { desc = "Run clang-tidy via LSP" })

  vim.keymap.set('n', '<leader>cf', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "Format buffer with clang-format" })

  vim.keymap.set('n', '<Leader>h', '<C-w>h', { desc = 'Move to left split' })
  vim.keymap.set('n', '<Leader>j', '<C-w>j', { desc = 'Move to down split' })
  vim.keymap.set('n', '<Leader>k', '<C-w>k', { desc = 'Move to up split' })
  vim.keymap.set('n', '<Leader>l', '<C-w>l', { desc = 'Move to right split' })
  vim.keymap.set('n', '<Leader>w', '<C-w>w', { desc = 'Cycle through splits' })

  -- Remove old keymap if exists
  local function remove_keymap(mode, key)
    local current_map = vim.api.nvim_get_keymap(mode)
    for _, mapping in ipairs(current_map) do
      if mapping.lhs == key then
        vim.api.nvim_del_keymap(mode, key)
        return
      end
    end
  end
  remove_keymap('n', '<C-w>d')

  vim.api.nvim_set_keymap('n', '<C-w>', ':tabclose<CR>', { noremap = true, silent = true })
end

-- Schedule the keymaps setup on VimEnter event
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    setup_keymaps()
  end,
})
