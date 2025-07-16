return {
    "NvChad/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "javascript", "typescript", "lua", "rust", "json", "yaml", "vim", "lua" }, -- only load on these filetypes
    config = function ()
        require("colorizer").setup({
            user_default_options = {
                RGB      = true,  -- #RGB hex codes
                RRGGBB   = true,  -- #RRGGBB hex codes
                names    = false, -- disable color names like 'red' or 'blue'
                RRGGBBAA = true,  -- #RRGGBBAA hex codes (with alpha)
                rgb_fn   = false, -- disable rgb() functions
                hsl_fn   = false, -- disable hsl() functions
                css      = false, -- disable all css colors
                css_fn   = false, -- disable all css functions
                -- tailwind = false -- if you had tailwind support, turn it off
            },
        })

    end
}
