return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" }, -- Lazy load on entering insert or cmdline mode
    dependencies = {
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind.nvim", -- ✨ icons and symbol magic
    },
    config = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	cmp.setup({
	    snippet = {
		expand = function(args)
		    require("luasnip").lsp_expand(args.body)
		end,
	    },
	    window = {
		completion = cmp.config.window.bordered(), -- Rounded border
		documentation = cmp.config.window.bordered(),
	    },
	    formatting = {
		format = lspkind.cmp_format({
		    mode = "symbol_text", -- Show symbol + text (function [ƒ])
		    maxwidth = 100,        -- Truncate long entries
		    ellipsis_char = "...",
		    menu = {
			nvim_lsp = "[LSP]",
			luasnip  = "[Snip]",
			buffer   = "[Buf]",
			path     = "[Path]",
		    },
		}),
	    },
	    mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = function(fallback)
		    if cmp.visible() then
			cmp.select_next_item()
		    else
			fallback()
		    end
		end,
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	    }),
	    sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer", max_item_count = 5 },
		{ name = "path" },
	    }),
	    performance = {
		debounce = 60, -- Faster response
		throttle = 30,
		fetching_timeout = 200,
	    },
	    experimental = {
		ghost_text = true, -- 👻 Preview inline suggestion
	    },
	})
    end,
}
