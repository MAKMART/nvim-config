vim.opt.termguicolors = true
vim.loader.enable()

-- Options
vim.opt.swapfile = false         -- no .swp files
vim.opt.backup = false           -- no extra file copy
vim.opt.writebackup = true       -- safe write to temp file first, then replace
vim.opt.updatetime = 300
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = "no"
vim.opt.foldcolumn = "0"
vim.opt.numberwidth = 1
vim.opt.ambiwidth = "double"

vim.opt.modeline = false       -- don’t parse modelines in every file
vim.opt.matchtime = 0          -- reduces highlight match delay
vim.opt.showmode = false       -- if your statusline already shows mode
vim.opt.ruler = false          -- reduces redraws slightly

vim.opt.expandtab = false      -- use real tabs
vim.opt.shiftwidth = 4         -- 1 tab = 4 spaces (visually)
vim.opt.tabstop = 4            -- how big a tab character is
vim.opt.softtabstop = -1        -- backspace deletes 1 tab, not spaces

vim.opt.lazyredraw = true
vim.opt.path:append("**")    -- Search subfolders with `:find`
vim.opt.wildmode = { "longest", "list", "full" }      -- Enhanced command-line completion
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- diagnostic's config is loaded only when a lsp gets attached
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = false,
      update_in_insert = false,
    })
  end,
})

vim.filetype.add({
  extension = {
    rml = "html",
    rcss = "css",
  }
})
