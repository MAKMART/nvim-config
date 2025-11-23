local M = {}

vim.g.mapleader = " " -- leader key must be set before Lazy.nvim loading!

local function remove_keymap(mode, key)
    local maps = vim.api.nvim_get_keymap(mode)
    for _, m in ipairs(maps) do
        if m.lhs == key then
            vim.keymap.del(mode, key)
            return
        end
    end
end

function M.setup()

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    map('n', '<leader>pv', ':Explore<CR>', opts)
    map('n', '<leader>pf', ':Telescope find_files<CR>', opts)

    --runner mappings
    map('n', '<leader>db', function() require("utils.project_runner").build("debug") end)
    map('n', '<leader>rb', function() require("utils.project_runner").build("release") end)
    map('n', '<leader>r',  function() require("utils.project_runner").run("debug") end)
    map('n', '<leader>R',  function() require("utils.project_runner").run("release") end)



    map('n', '<leader>cf', function()
        vim.lsp.buf.format()
    end, { desc = 'LSP: Format Code' })


    map("n", "<leader>ct", function()
        vim.lsp.buf.code_action({ context = { diagnostics = {} } })
    end, { desc = "Run clang-tidy via LSP" })

    remove_keymap('n', '<C-w>d')

    map('n', '<Leader>h', '<C-w>h', { desc = 'Move to left split' })
    map('n', '<Leader>j', '<C-w>j', { desc = 'Move to down split' })
    map('n', '<Leader>k', '<C-w>k', { desc = 'Move to up split' })
    map('n', '<Leader>l', '<C-w>l', { desc = 'Move to right split' })
    map('n', '<Leader>w', '<C-w>w', { desc = 'Cycle through splits' })


    map('n', '<leader>t', ':tabnew<CR>', opts)

    map('n', '<leader>bn', function()
        vim.cmd('enew')  -- create new buffer
    end, { desc = 'Open new buffer' })


    map('n', '<Tab>', ':bnext<CR>', opts)
    map('n', '<S-Tab>', ':bprev<CR>', opts)

    map('n', '<leader>bd', ':bdelete<CR>', opts)

    map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true });
    map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true });

end

return M
