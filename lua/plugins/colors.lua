return {
    "sainnhe/sonokai",
    priority = 1000, -- load early to avoid flash
    init = function()
	-- Set Sonokai style (optional, you can choose one)
	vim.g.sonokai_style = "default"
    end,
    config = function()
	-- Apply the colorscheme
	local ok, err = pcall(vim.cmd.colorscheme, "sonokai")
	if not ok then
	    vim.notify("Colorscheme 'sonokai' not found: " .. err, vim.log.levels.ERROR)
	    return
	end

	-- Transparent background
	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
    --[[function set_bk()
	-- Get a list of all available color schemes
	local themes = {}
	for _, dir in ipairs(vim.api.nvim_get_runtime_file('colors/*.vim', true)) do
	    local theme_name = dir:match("([^/\\]+)%.vim$")
	    if theme_name then
		table.insert(themes, theme_name)
	    end
	end

	-- If no themes found, return an error
	if #themes == 0 then
	    print("Error: No colorschemes found.")
	    return
	end

	-- Select a random theme
	local random_theme = themes[math.random(#themes)]

	-- Apply the random theme with a small delay to avoid potential issues with UI updates
	vim.defer_fn(function()
	    vim.cmd.colorscheme(random_theme)

	    -- Make the background transparent
	    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end, 10)  -- delay of 100ms
    end,

    set_bk()  -- Call the function to set a random theme]]--
}
