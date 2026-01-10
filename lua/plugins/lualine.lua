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

	local function update_lualine_colors()
		local fg_normal  = get_hl_color("Normal", "foreground") or "#ffffff"
		local bg_normal  = get_hl_color("Normal", "background") or "#000000"
		local fg_insert  = get_hl_color("String", "foreground") or "#00ffaa"
		local fg_visual  = get_hl_color("Visual", "foreground") or "#ff88cc"
		local fg_replace = get_hl_color("WarningMsg", "foreground") or "#ffaa00"
		local fg_command = get_hl_color("Statement", "foreground") or "#aaccff"
		local fg_inactive= get_hl_color("Comment", "foreground") or "#888888"

		-- For custom theme
		local theme = {
			normal   = { a = { fg = fg_normal, bg = bg_normal }, b = { fg = fg_normal, bg = bg_normal }, c = { fg = fg_normal, bg = bg_normal } },
			insert   = { a = { fg = fg_insert, bg = bg_normal }, b = { fg = fg_insert, bg = bg_normal }, c = { fg = fg_insert, bg = bg_normal } },
			visual   = { a = { fg = fg_visual, bg = bg_normal }, b = { fg = fg_visual, bg = bg_normal }, c = { fg = fg_visual, bg = bg_normal } },
			replace  = { a = { fg = fg_replace, bg = bg_normal }, b = { fg = fg_replace, bg = bg_normal }, c = { fg = fg_replace, bg = bg_normal } },
			command  = { a = { fg = fg_command, bg = bg_normal }, b = { fg = fg_command, bg = bg_normal }, c = { fg = fg_command, bg = bg_normal } },
			inactive = { a = { fg = fg_inactive, bg = bg_normal }, b = { fg = fg_inactive, bg = bg_normal }, c = { fg = fg_inactive, bg = bg_normal } },
		}

		-- Lualine setup
		lualine.setup({
			options = {
				theme = theme,
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
				--[[lualine_z = {
					function()
						return os.date("%H:%M:%S - %A")
					end,
				},
				]]
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
						max_length = vim.o.columns,
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
		})

	end

	vim.api.nvim_create_autocmd("ColorScheme", { callback = update_lualine_colors })
	update_lualine_colors() -- initial call
    end,
}
