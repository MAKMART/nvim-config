vim.opt.termguicolors = false
vim.loader.enable()


vim.opt.swapfile = false         -- no .swp files
vim.opt.backup = false           -- no extra file copy
vim.opt.writebackup = true       -- safe write to temp file first, then replace
vim.opt.updatetime = 200


-- Treat rml files as html so that treesitter's syntax highlightning works ;)
vim.filetype.add({
  extension = {
    rml = "html",
  }
})


-- Disable arrow keys
vim.keymap.set('', '<Up>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<Down>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<Left>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<Right>', '<Cmd>echo "Use hjkl!"<CR>', { noremap = true, silent = false })

-- Keybindings for folding
vim.api.nvim_set_keymap('n', '<leader>zR', ':normal! zR<CR>', { noremap = true, silent = true })  -- Open all folds
vim.api.nvim_set_keymap('n', '<leader>zM', ':normal! zM<CR>', { noremap = true, silent = true })  -- Close all folds
vim.api.nvim_set_keymap('n', '<leader>zo', ':normal! zo<CR>', { noremap = true, silent = true })  -- Open fold under cursor
vim.api.nvim_set_keymap('n', '<leader>zc', ':normal! zc<CR>', { noremap = true, silent = true })  -- Close fold under cursor

-- Options
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = "number"
vim.opt.shiftwidth = 4
-- Enable folding based on syntax (works well for most languages)
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevelstart = 99  -- Start with all folds open


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
require("lazy").setup("plugins", {
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

function DebugBuildAndRun()
    -- Save the current file
    vim.cmd("w")
    -- Get the directory of the currently open file
    local root_dir = vim.fn.expand("%:p:h")
    local build_dir = vim.fs.joinpath(root_dir, "build")
    local bin_dir = vim.fs.joinpath(build_dir, "bin", "Debug")
    local cmake_file = vim.fs.joinpath(root_dir, "CMakeLists.txt")

    -- Check if CMakeLists.txt exists
    if vim.fn.filereadable(cmake_file) == 0 then
        vim.notify("Error: CMakeLists.txt not found in " .. root_dir, vim.log.levels.ERROR)
        return
    end

    -- Get first .exe path if it exists
    local files = vim.fn.glob(vim.fs.joinpath(bin_dir, "*.exe"), false, true)
    local exe = (#files > 0) and files[1] or nil
    if exe then
        exe = exe:gsub("\\", "\\\\") -- Escape backslashes
    end

    -- Construct terminal shell command
    local cmd = table.concat({
        string.format('cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=Debug "%s"', build_dir, root_dir),
        string.format('ninja -C "%s"', build_dir),
        exe and exe or "echo No executable found"
    }, " && ")

    -- Open vertical split terminal
    vim.cmd("vsplit")
    vim.cmd("terminal " .. cmd)
end


function ReleaseBuildAndRun()
    -- Save the current file
    vim.cmd("w")
    -- Get the directory of the currently open file
    local root_dir = vim.fn.expand("%:p:h")
    local build_dir = vim.fs.joinpath(root_dir, "build")
    local bin_dir = vim.fs.joinpath(build_dir, "bin", "Release")
    local cmake_file = vim.fs.joinpath(root_dir, "CMakeLists.txt")

    -- Check if CMakeLists.txt exists
    if vim.fn.filereadable(cmake_file) == 0 then
        vim.notify("Error: CMakeLists.txt not found in " .. root_dir, vim.log.levels.ERROR)
        return
    end
    -- Get first .exe path if it exists
    local files = vim.fn.glob(vim.fs.joinpath(bin_dir, "*.exe"), false, true)
    local exe = (#files > 0) and files[1] or nil
    if exe then
        exe = exe:gsub("\\", "\\\\") -- Escape backslashes
    end

    -- Construct terminal shell command
    local cmd = table.concat({
        string.format('cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=Release "%s"', build_dir, root_dir),
        string.format('ninja -C "%s"', build_dir),
        exe and exe or "echo No executable found"
    }, " && ")

    -- Open vertical split terminal
    vim.cmd("vsplit")
    vim.cmd("terminal " .. cmd)

end


function Run(build_type)
    -- Validate the build type, default to 'Debug' if invalid
    if build_type ~= "Debug" and build_type ~= "Release" then
	build_type = "Debug"  -- Default to Debug if invalid argument
    end

    -- Get the directory of the currently open file
    local root_dir = vim.fn.expand('%:p:h')
    local build_dir = root_dir .. "\\build\\bin\\" .. build_type:lower()  -- Use lowercase for consistency (e.g., 'debug' or 'release')

    -- Search for the executable in the bin_dir
    local files = vim.fn.glob(vim.fs.joinpath(build_dir, "*.exe"), false, true)
    if #files == 0 then
	vim.notify("No executables found in " .. build_dir, vim.log.levels.ERROR)
	return
    end

    -- Pick the first executable
    local executable = files[1]

    -- Escape backslashes (Lua-style)
    executable = executable:gsub("\\", "\\\\")

    -- Open a terminal directly running the .exe
    vim.cmd("vsplit")
    -- Terminal directly runs the .exe
    vim.cmd("terminal " .. executable)
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
vim.api.nvim_set_keymap('n', '<leader>r', ':Run Debug <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>R', ':Run Release  <CR>', { noremap = true, silent = true })
