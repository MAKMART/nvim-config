return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        event = "UIEnter",
        config = function()
            vim.o.background = "dark" -- or "light"
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                inverse = true,
                contrast = "",
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
            vim.cmd.colorscheme("gruvbox")
        end,
    },
}
