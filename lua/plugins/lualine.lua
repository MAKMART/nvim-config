return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter", -- Load after UI is fully ready
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local ok, lualine = pcall(require, "lualine")
        if not ok then return end

        -- Try to load the theme with fallback
        local theme = require("lualine.themes.nightfly")

        -- Patch theme with darker, programmer-friendly custom mode colors
        local mode_colors = {
            normal  = "#50665f", -- Muted blue-green
            insert  = "#405e41", -- Forest green
            visual  = "#9b5b6d", -- Subtle magenta
            command = "#b38220", -- Warm yellow
        }

        -- Ensure each mode table exists before modifying it
        theme.normal  = theme.normal  or {}
        theme.insert  = theme.insert  or {}
        theme.visual  = theme.visual  or {}
        theme.command = theme.command or {}

        --[[
        theme.normal.a  = { fg = "#ffffff", bg = mode_colors.normal, gui = "bold" }
        theme.insert.a  = { fg = "#ffffff", bg = mode_colors.insert, gui = "bold" }
        theme.visual.a  = { fg = "#ffffff", bg = mode_colors.visual, gui = "bold" }
        theme.command.a = { fg = "#3c3836", bg = mode_colors.command, gui = "bold" }
        ]]


        -- Lualine setup
        lualine.setup({
            options = {
                theme = "auto",
                globalstatus = true,
                section_separators = "",
                component_separators = "",
                icons_enabled = true,
                disabled_filetypes = {
                    statusline = { "alpha", "dashboard", "neo-tree" },
                    winbar = {},
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    { "filename", path = 3, symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" } },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = {
                    function()
                        return os.date("%H:%M:%S - %A")
                    end,
                },
            },
            inactive_sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "location" },
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = { "nvim-tree", "quickfix", "toggleterm" },
        })
    end,
}
