--[[return {
    "olimorris/onedarkpro.nvim",
    priority = 100, -- load early to avoid flash
    config = function()
        -- Setup onedarkpro BEFORE applying colorscheme
        require('onedarkpro').setup {
            styles = {
                comments = "italic",
                keywords = "bold",
            },
            colorscheme = "onedark_dark", -- pick the variant you want
        }

        -- Apply the colorscheme, pcall to avoid errors breaking startup
        local ok, err = pcall(vim.cmd.colorscheme, "onedark_dark")
        if not ok then
            vim.notify("Colorscheme 'onedark' not found: " .. err, vim.log.levels.ERROR)
            return
        end

        -- Uncomment for true transparent background:
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
}]]
return {
    {
        "RRethy/base16-nvim",
        priority = 1000, -- ← HIGH priority, loads before other UI plugins
        lazy = false,    -- ← force it to load immediately
        config = function()
            print("Running base16 setup!")  -- <--- debug
            local bg = "#0F1919"
            local accent = "#102121"
            local accent2 = "#0D2525" -- highlight

            local text = "#abb2bf"
            local dark_text = "#3E4451" -- comments, line numbers

            local keyword = "#8F939A"
            local func = "#B6AB8B"
            local types = "#65838E"
            local constant = "#A06057"

            local for_tesing = "#FF0000"

            require("base16-colorscheme").setup({
                base00 = bg,
                base01 = accent,
                base02 = accent2,
                base03 = dark_text,
                base04 = dark_text,
                base05 = text,
                base06 = for_tesing,
                base07 = for_tesing,
                base08 = text,
                base09 = constant,
                base0A = types,
                base0B = constant,
                base0C = text,
                base0D = func,
                base0E = keyword,
                base0F = text,
            })
            -- vim.cmd.colorscheme("base16")
        end,
    },
}
