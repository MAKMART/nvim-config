return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter", -- Load after UI is fully ready
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local ok, lualine = pcall(require, "lualine")
        if not ok then return end



	local function get_hl_color(group, attr)
		local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
		if not ok then return nil end
		if hl[attr] then
			return string.format("#%06x", hl[attr])
		else
			return nil
		end
	end

	local fg_normal = get_hl_color("Normal", "foreground") or "#ffffff"
	local fg_insert = get_hl_color("String", "foreground") or "#00ffaa"
	local fg_visual = get_hl_color("Visual", "background") or "#ff88cc"
	local fg_replace = get_hl_color("WarningMsg", "foreground") or "#ffaa00"
	local fg_command = get_hl_color("Statement", "foreground") or "#aaccff"
	local fg_inactive = get_hl_color("Comment", "foreground") or "#888888"
	local fg_terminal = get_hl_color("Special", "foreground") or "#ffcc00"


	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()

			local fg_normal = get_hl_color("Normal", "foreground") or "#ffffff"
			local fg_insert = get_hl_color("String", "foreground") or "#00ffaa"
			local fg_visual = get_hl_color("Visual", "background") or "#ff88cc"
			local fg_replace = get_hl_color("WarningMsg", "foreground") or "#ffaa00"
			local fg_command = get_hl_color("Statement", "foreground") or "#aaccff"
			local fg_inactive = get_hl_color("Comment", "foreground") or "#888888"
			local fg_terminal = get_hl_color("Special", "foreground") or "#ffcc00"
		end,
	})


	local custom_theme = {
		normal = { c = { fg = fg_normal, bg = "NONE" } },
		insert = { c = { fg = fg_insert, bg = "NONE" } },
		visual = { c = { fg = fg_visual, bg = "NONE" } },
		replace = { c = { fg = fg_replace, bg = "NONE" } },
		command = { c = { fg = fg_command, bg = "NONE" } },
		inactive = { c = { fg = fg_inactive, bg = "NONE" } },
	}
        -- Lualine setup
        lualine.setup({
            options = {
                theme = custom_theme,
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
            tabline = {
                lualine_a = {
                    {
                        'buffers',
                        show_filename_only = false,
                        mode = 0,
                        max_length = math.floor(vim.o.columns * 2 / 3),
                        filetype_names = {
                            telescope = "Telescope",
                            dashboard = "Dashboard",
                            packer = "Packer",
                            fzf = "FZF",
                            alpha = "Alpha",
                        },
                        buffers_color = {
                            active = "lualine_c_normal",
                            inactive = "lualine_c_inactive",
                        },
                    }
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },

            winbar = {},
            inactive_winbar = {},
            extensions = { "nvim-tree", "quickfix", "toggleterm" },
        })

        vim.api.nvim_set_hl(0, "lualine_c_normal",  { fg = "#ffcc00", bg = "none" })
        vim.api.nvim_set_hl(0, "lualine_c_insert",  { fg = "#00ffaa", bg = "none" })
        vim.api.nvim_set_hl(0, "lualine_c_visual",  { fg = "#ff88cc", bg = "none" })
        vim.api.nvim_set_hl(0, "lualine_c_replace", { fg = "#ffaa00", bg = "none" })
        vim.api.nvim_set_hl(0, "lualine_c_command", { fg = "#aaccff", bg = "none" })
        vim.api.nvim_set_hl(0, "lualine_c_inactive",{ fg = "#888888", bg = "none" })
        vim.api.nvim_set_hl(0, "lualine_c_terminal",  { fg = "#ffcc00", bg = "none" })

    end,
}
