-- file to check whether Node.js exists and installs it if it does not
local function check_npm()
    -- Check if npm is in PATH
    local cmd = vim.loop.os_uname().sysname:match("Windows") and "where npm" or "which npm"
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    if result == "" then
	vim.notify("npm not found. Attempting to install Node.js...", vim.log.levels.INFO)
	local install_cmd
	local os_name = vim.loop.os_uname().sysname
	if os_name:match("Windows") then
	    -- Check if winget is available
	    local winget_check = vim.fn.system("where winget")
	    if winget_check == "" then
		vim.notify("winget not found. Please install Node.js manually from https://nodejs.org or ensure winget is installed.", vim.log.levels.ERROR)
		return
	    end
	    install_cmd = "winget install --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements"
	elseif os_name:match("Linux") then
	    install_cmd = "sudo apt-get update && sudo apt-get install -y nodejs npm"
	elseif os_name:match("Darwin") then
	    install_cmd = "brew install node"
	else
	    vim.notify("Unsupported OS for auto-installing Node.js", vim.log.levels.ERROR)
	    return
	end

	local success, err = pcall(function()
	    vim.fn.system(install_cmd)
	    if vim.v.shell_error ~= 0 then
		error("Command failed: " .. install_cmd)
	    end
	end)
	if not success then
	    vim.notify("Failed to install Node.js: " .. tostring(err) .. "\nPlease install Node.js manually from https://nodejs.org.", vim.log.levels.ERROR)
	else
	    -- Update PATH for Windows
	    if os_name:match("Windows") then
		local node_path = os.getenv("ProgramFiles") .. "\\nodejs"
		local npm_path = os.getenv("APPDATA") .. "\\npm"
		local sep = ";"
		vim.env.PATH = node_path .. sep .. npm_path .. sep .. vim.env.PATH
		vim.cmd("let $PATH = '" .. vim.env.PATH .. "'")
	    end
	    vim.notify("Node.js installed. Restart Neovim and your terminal to ensure npm is available.", vim.log.levels.INFO)
	end
    else
	--vim.notify("npm found: " .. result, vim.log.levels.INFO)
    end
end

-- Run check on startup
vim.schedule(check_npm)
