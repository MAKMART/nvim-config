vim.opt.termguicolors = true
vim.loader.enable()

-- Options
vim.opt.swapfile = false         -- no .swp files
vim.opt.backup = false           -- no extra file copy
vim.opt.writebackup = true       -- safe write to temp file first, then replace
vim.opt.updatetime = 300
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.o.ambiwidth = "double"


vim.opt.expandtab = false      -- use real tabs
vim.opt.shiftwidth = 8         -- 1 tab = 8 spaces (visually)
vim.opt.tabstop = 8            -- how big a tab character is
vim.opt.softtabstop = 0        -- backspace deletes 1 tab, not spaces

vim.opt.lazyredraw = true
vim.opt.path:append("**")    -- Search subfolders with `:find`
vim.opt.wildmenu = true      -- Enhanced command-line completion
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- diagnostic's config is loaded only when a lsp gets attached
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = false,
    })
  end,
})

vim.filetype.add({
  extension = {
    rml = "html",
    rcss = "css",
  }
})

-- Disable arrow keys
local function disable_arrow_keys()
    local opts = { noremap = true, silent = false }
    vim.keymap.set('', '<Up>',    '<Cmd>echo "Use hjkl!"<CR>', opts)
    vim.keymap.set('', '<Down>',  '<Cmd>echo "Use hjkl!"<CR>', opts)
    vim.keymap.set('', '<Left>',  '<Cmd>echo "Use hjkl!"<CR>', opts)
    vim.keymap.set('', '<Right>', '<Cmd>echo "Use hjkl!"<CR>', opts)
end

-- Use an autocommand to set keymaps lazily on first normal mode entry
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:n",  --Insert to Normal mode transition (first time you leave insert)
  once = true,
  callback = disable_arrow_keys,
})

require("config.remap")
-- Schedule the keymaps setup on VimEnter event
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("utils.floaterminal").setup()
        require("config.remap").setup()
    end,
})
