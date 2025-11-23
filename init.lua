require("core")
require("remap")
-- Schedule the keymaps setup on VimEnter event
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("remap").setup()
        require("utils.floaterminal").setup()
    end,
})
require("lazy_bootstrap")
