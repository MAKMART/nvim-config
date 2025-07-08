return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter", -- Load after UI is fully ready
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local ok, lualine = pcall(require, "lualine")
        if not ok then return end

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
                lualine_c = {{ "filename", path = 3, symbols = { modified = "●", readonly = "🔒", unnamed = "[Unnamed]" } }, },
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

        vim.api.nvim_set_hl(0, "lualine_c_normal",  { fg = "#ffcc00", bg = "#282828" })
        vim.api.nvim_set_hl(0, "lualine_c_insert",  { fg = "#00ffaa", bg = "#282828" })
        vim.api.nvim_set_hl(0, "lualine_c_visual",  { fg = "#ff88cc", bg = "#282828" })
        vim.api.nvim_set_hl(0, "lualine_c_replace", { fg = "#ffaa00", bg = "#282828" })
        vim.api.nvim_set_hl(0, "lualine_c_command", { fg = "#aaccff", bg = "#282828" })
        vim.api.nvim_set_hl(0, "lualine_c_inactive",{ fg = "#888888", bg = "#282828" })

    end,
}
