return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
	local lualine_status, lualine = pcall(require, "lualine")
	if not lualine_status then
	    return
	end

	local lualine_nightfly = require("lualine.themes.nightfly")
	local new_colors = {
	    blue = "#65d1ff",
	    green = "#3effdc",  -- You were missing the '#' in the green hex code
	    violet = "#ff61ef",
	    yellow = "#ffda7b",
	    black = "#000000",
	}

	lualine_nightfly.normal.a.bg = new_colors.blue
	lualine_nightfly.insert.a.bg = new_colors.green
	lualine_nightfly.visual.a.bg = new_colors.violet
	lualine_nightfly.command = {
	    a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black,
	    },
	}

	lualine.setup({
	    options = {
		theme = lualine_nightfly,
		section_separators = "",
		component_separators = "",
	    },
	    sections = {
		lualine_c = {
		    {
			"filename",
			path = 3,
		    },
		},
		lualine_z = {
		    function()
			return os.date("%H:%M:%S") .. " - " .. os.date("%A")
		    end,
		},
	    },
	})
    end,
}
