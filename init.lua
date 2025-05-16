local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Keymaps (important to call before lazy's plugins' setup cuz sets [vim.g.mapleader= " "] the leader key!!! WHICH HAS TO BE SET BEFORE LAZY PLUGINS!!!)
require("remap")  -- Now it works because remap.lua is inside lua/

-- Point to your plugin spec module
require("lazy").setup("plugins")  -- Requires all the files in the plugins/ directory

function DebugBuildAndRun()
    -- Save the current file
    vim.cmd("w")

    -- Debug: Check if vim.fn is available
    if not vim.fn then
        vim.notify("Error: vim.fn is nil or undefined", vim.log.levels.ERROR)
        return
    end

    -- Get the directory of the currently open file
    local root_dir
    if type(vim.fn.expand) == "function" then
        root_dir = vim.fn.expand("%:p:h")
    else
        vim.notify("Error: vim.fn.expand is not a function, using fallback", vim.log.levels.WARN)
        -- Fallback: Use vim.api.nvim_buf_get_name and vim.fs.dirname
        local buf_name = vim.api.nvim_buf_get_name(0)
        root_dir = vim.fs.dirname(buf_name)
        if not root_dir then
            vim.notify("Error: Could not determine root directory", vim.log.levels.ERROR)
            return
        end
    end

    -- Construct paths
    local build_dir = vim.fs.joinpath(root_dir, "build")
    local bin_dir = vim.fs.joinpath(build_dir, "bin", "Debug")
    local cmake_file = vim.fs.joinpath(root_dir, "CMakeLists.txt")

    -- Check if CMakeLists.txt exists
    if vim.fn.filereadable(cmake_file) == 0 then
        vim.notify("Error: CMakeLists.txt not found in " .. root_dir, vim.log.levels.ERROR)
        return
    end

    -- Run CMake to generate build files
    local cmake_cmd = string.format('cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=Debug "%s"', build_dir, root_dir)
    vim.notify(cmake_cmd, vim.log.levels.INFO)
    local cmake_result = vim.fn.system(cmake_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(cmake_result, vim.log.levels.ERROR)
        return
    end

    -- Run Ninja to build the project
    local ninja_cmd = string.format('ninja -C "%s"', build_dir)
    vim.notify(ninja_cmd, vim.log.levels.INFO)
    local ninja_result = vim.fn.system(ninja_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(ninja_result, vim.log.levels.ERROR)
        return
    end

    -- Search for the executable in the bin_dir
    local files = vim.fn.glob(vim.fs.joinpath(bin_dir, "*.exe"), false, true)
    if #files == 0 then
        vim.notify("No executables found in " .. bin_dir, vim.log.levels.ERROR)
        return
    end

    -- Pick the first executable
    local executable = files[1]
    --vim.notify("Found executable: " .. executable, vim.log.levels.INFO)

    -- Run the executable in Alacritty
    local alacritty_path = "C:/Program Files/Alacritty/alacritty.exe"
    if vim.fn.executable(alacritty_path) == 0 then
        vim.notify("Alacritty not found at " .. alacritty_path, vim.log.levels.ERROR)
        return
    end

    local command = string.format(
        'start "" "%s" -e cmd /k "%s & pause"',
        alacritty_path,
        executable
    )
    --vim.notify("Running: " .. command, vim.log.levels.INFO)
    vim.fn.system(command)
end

function ReleaseBuildAndRun()
    -- Save the current file
    vim.cmd("w")

    -- Debug: Check if vim.fn is available
    if not vim.fn then
        vim.notify("Error: vim.fn is nil or undefined", vim.log.levels.ERROR)
        return
    end

    -- Get the directory of the currently open file
    local root_dir
    if type(vim.fn.expand) == "function" then
        root_dir = vim.fn.expand("%:p:h")
    else
        vim.notify("Error: vim.fn.expand is not a function, using fallback", vim.log.levels.WARN)
        -- Fallback: Use vim.api.nvim_buf_get_name and vim.fs.dirname
        local buf_name = vim.api.nvim_buf_get_name(0)
        root_dir = vim.fs.dirname(buf_name)
        if not root_dir then
            vim.notify("Error: Could not determine root directory", vim.log.levels.ERROR)
            return
        end
    end

    -- Construct paths
    local build_dir = vim.fs.joinpath(root_dir, "build")
    local bin_dir = vim.fs.joinpath(build_dir, "bin", "Release")
    local cmake_file = vim.fs.joinpath(root_dir, "CMakeLists.txt")

    -- Check if CMakeLists.txt exists
    if vim.fn.filereadable(cmake_file) == 0 then
        vim.notify("Error: CMakeLists.txt not found in " .. root_dir, vim.log.levels.ERROR)
        return
    end

    -- Run CMake to generate build files
    local cmake_cmd = string.format('cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=Release "%s"', build_dir, root_dir)
    vim.notify(cmake_cmd, vim.log.levels.INFO)
    local cmake_result = vim.fn.system(cmake_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(cmake_result, vim.log.levels.ERROR)
        return
    end

    -- Run Ninja to build the project
    local ninja_cmd = string.format('ninja -C "%s"', build_dir)
    vim.notify(ninja_cmd, vim.log.levels.INFO)
    local ninja_result = vim.fn.system(ninja_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(ninja_result, vim.log.levels.ERROR)
        return
    end

    -- Search for the executable in the bin_dir
    local files = vim.fn.glob(vim.fs.joinpath(bin_dir, "*.exe"), false, true)
    if #files == 0 then
        vim.notify("No executables found in " .. bin_dir, vim.log.levels.ERROR)
        return
    end

    -- Pick the first executable
    local executable = files[1]
    --vim.notify("Found executable: " .. executable, vim.log.levels.INFO)

    -- Run the executable in Alacritty
    local alacritty_path = "C:/Program Files/Alacritty/alacritty.exe"
    if vim.fn.executable(alacritty_path) == 0 then
        vim.notify("Alacritty not found at " .. alacritty_path, vim.log.levels.ERROR)
        return
    end

    local command = string.format(
        'start "" "%s" -e cmd /k "%s & pause"',
        alacritty_path,
        executable
    )
    --vim.notify("Running: " .. command, vim.log.levels.INFO)
    vim.fn.system(command)
end


function Run(build_type)
    -- Validate the build type, default to 'Debug' if invalid
    if build_type ~= "Debug" and build_type ~= "Release" then
        build_type = "Debug"  -- Default to Debug if invalid argument
    end

    -- Get the directory of the currently open file
    local root_dir = vim.fn.expand('%:p:h')
    local build_dir = root_dir .. "\\build\\bin\\" .. build_type:lower()  -- Use lowercase for consistency (e.g., 'debug' or 'release')

    local executable = nil
    local files = vim.fn.glob(build_dir .. "\\*.exe", false, true)  -- glob returns a table of file paths

    -- Debugging output to confirm files found
    --[[if #files > 0 then
	print("Files found: ")
	for _, file in ipairs(files) do
	    print(file)  -- Print each file path
	end
    else
	print("No executables found in " .. build_dir)
    end]]

    -- If files found, pick the first one
    if #files > 0 then
	executable = files[1]  -- Use the first executable found
	-- If an executable is found, run it using Alacritty
	local command = 'start "" "C:/Program Files/Alacritty/alacritty.exe" -e cmd /k "' .. executable .. ' & pause"'
	vim.fn.system(command)
    else
	print("No executable found in " .. build_dir)
    end
end


-- Define the custom command DebugBuildAndRun 
vim.cmd([[ command! DebugBuildAndRun lua DebugBuildAndRun() ]])
-- Keybinding for Debug Build and Run (using leader key `\b`) 
vim.api.nvim_set_keymap('n', '<leader>db', ':DebugBuildAndRun<CR>', { noremap = true, silent = true })

-- Define the custom command ReleaseBuildAndRun 
vim.cmd([[ command! ReleaseBuildAndRun lua ReleaseBuildAndRun() ]])
-- Keybinding for Release Build and Run (using leader key `\b`) 
vim.api.nvim_set_keymap('n', '<leader>rb', ':ReleaseBuildAndRun<CR>', { noremap = true, silent = true })



-- Define the custom command for Run with build type argument
vim.cmd([[ command! -nargs=1 Run lua Run(<f-args>) ]])
-- Keybinding for Run with the specified build type (using leader key '\r')
vim.api.nvim_set_keymap('n', '<leader>r', ':Run Debug<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>R', ':Run Release<CR>', { noremap = true, silent = true })

vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = "number"
vim.opt.shiftwidth = 4
-- Enable folding based on syntax (works well for most languages)
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevelstart = 99  -- Start with all folds open


-- Keybindings for folding
vim.api.nvim_set_keymap('n', '<leader>zR', ':normal! zR<CR>', { noremap = true, silent = true })  -- Open all folds
vim.api.nvim_set_keymap('n', '<leader>zM', ':normal! zM<CR>', { noremap = true, silent = true })  -- Close all folds
vim.api.nvim_set_keymap('n', '<leader>zo', ':normal! zo<CR>', { noremap = true, silent = true })  -- Open fold under cursor
vim.api.nvim_set_keymap('n', '<leader>zc', ':normal! zc<CR>', { noremap = true, silent = true })  -- Close fold under cursor

-- Disable arrow keys
vim.keymap.set('', '<Up>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<Down>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<Left>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<Right>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
