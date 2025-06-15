return {
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
}
