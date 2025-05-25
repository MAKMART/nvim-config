return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter", -- Load after UI is fully ready
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- Simplify the pcall check
        if not pcall(require, "lualine") then
            return
        end

        -- Load the theme
        local lualine_nightfly = require("lualine.themes.nightfly")

        -- Define even darker programmer-friendly colors for better text contrast
        lualine_nightfly.normal = { a = { bg = "#50665f" } } -- Even darker muted blue-green for normal mode
        lualine_nightfly.insert = { a = { bg = "#405e41" } } -- Even darker forest green for insert mode
        lualine_nightfly.visual = { a = { bg = "#9b5b6d" } } -- Even darker subtle magenta for visual mode
        lualine_nightfly.command = { a = { gui = "bold", bg = "#b38220", fg = "#3c3836" } } -- Even darker warm yellow with dark gray foreground

        -- Setup lualine
        require("lualine").setup({
            options = {
                theme = lualine_nightfly,
                section_separators = "",
                component_separators = "",
                globalstatus = true, -- Use global statusline for better performance
            },
            sections = {
                lualine_c = {
                    { "filename", path = 3 },
                },
                lualine_z = {
                    function()
                        return vim.fn.strftime("%H:%M:%S - %A")
                    end,
                },
            },
        })
    end,
}
