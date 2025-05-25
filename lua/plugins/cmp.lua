return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Already good for lazy-loading
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "hrsh7th/cmp-path", event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" }, -- Load cmdline only when needed
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      event = "InsertEnter",
      dependencies = { "saadparwaiz1/cmp_luasnip" }, -- Explicitly add LuaSnip integration
    },
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- Add LuaSnip as a source
        { name = "buffer", max_item_count = 5, keyword_length = 3 }, -- Optimize buffer source
        { name = "path" },
      }),
      performance = {
        debounce = 60, -- Reduce debounce time for faster response
        throttle = 30, -- Reduce throttle for smoother updates
        fetching_timeout = 200, -- Lower timeout for faster source fetching
      },
    })

    -- Set up cmdline completion separately to avoid loading it in insert mode
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "cmdline" },
      },
    })
  end,
}
