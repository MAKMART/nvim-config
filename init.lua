vim.opt.termguicolors = true
vim.loader.enable()

-- Options
vim.opt.swapfile = false         -- no .swp files
vim.opt.backup = false           -- no extra file copy
vim.opt.writebackup = true       -- safe write to temp file first, then replace
vim.opt.updatetime = 100
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = "number"
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 4       -- Number of spaces per indent
vim.opt.tabstop = 4          -- Number of spaces a tab counts for
vim.opt.softtabstop = 4      -- Makes backspace delete 4 spaces


-- diagnostic's config is loaded only when a lsp gets attached
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = false,
    })
  end,
})

-- Treat rml && rcss files as html && css so that treesitter's syntax highlightning works ;)
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
  pattern = "i:n",  -- Insert to Normal mode transition (first time you leave insert)
  once = true,
  callback = disable_arrow_keys,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Keymaps (important to call before lazy's plugins' setup cuz sets [vim.g.mapleader= " "] the leader key!!! WHICH HAS TO BE SET BEFORE LAZY PLUGINS!!!)
require("remap")  -- Now it works because remap.lua is inside lua/
-- Point to your plugin spec module
require("lazy").setup({ 
  { import = "plugins" },
  { import = "plugins.lsp" },
    }, { --Setup plugins using lua/plugins/*.lua
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
            },
        },
    },
})
