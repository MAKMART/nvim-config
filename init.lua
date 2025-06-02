vim.opt.termguicolors = false
vim.loader.enable()


vim.opt.swapfile = false         -- no .swp files
vim.opt.backup = false           -- no extra file copy
vim.opt.writebackup = true       -- safe write to temp file first, then replace
vim.opt.updatetime = 200


-- Treat rml && rcss files as html && css so that treesitter's syntax highlightning works ;)
vim.filetype.add({
  extension = {
    rml = "html",
    rcss = "css",
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
local bit = require("bit")
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
-- Utility function: Get the first executable file in a directory

function get_executable(bin_dir)
    local is_windows = vim.loop.os_uname().sysname:find("Windows") ~= nil
    local files = {}

    if is_windows then
        -- Search for .exe files
        files = vim.fn.glob(vim.fs.joinpath(bin_dir, "*.exe"), false, true)
    else
        -- Search for any file with executable permission
        local scan = vim.loop.fs_scandir(bin_dir)
        if scan then
            while true do

                local name, type = vim.loop.fs_scandir_next(scan)
                if not name then break end
                local full_path = vim.fs.joinpath(bin_dir, name)
                local stat = vim.loop.fs_stat(full_path)
                -- Check execute permission bits: owner/group/other

                if stat and stat.type == "file" and bit.band(stat.mode, 0x49) ~= 0 then
                    table.insert(files, full_path)
                end
            end
        end
    end

    local exe = (#files > 0) and files[1] or nil
    if exe and is_windows then
        exe = exe:gsub("\\", "\\\\") -- Escape backslashes for Windows terminal
    end
    return exe
end


-- Function to build and run (Debug/Release)

function BuildAndRun(build_type)
    -- Validate build type
    if build_type ~= "Debug" and build_type ~= "Release" then
        build_type = "Debug"
    end


    vim.cmd("w") -- Save file
    local root_dir = vim.fn.expand("%:p:h")
    local build_dir = vim.fs.joinpath(root_dir, "build")
    local bin_dir = vim.fs.joinpath(build_dir, "bin", string.lower(build_type))
    local cmake_file = vim.fs.joinpath(root_dir, "CMakeLists.txt")

    if vim.fn.filereadable(cmake_file) == 0 then
        vim.notify("Error: CMakeLists.txt not found in " .. root_dir, vim.log.levels.ERROR)
        return
    end

    local exe = get_executable(bin_dir)
    if not exe then
        vim.notify("Error: No executable found in " .. bin_dir, vim.log.levels.ERROR)
        return
    end

    local cmd = table.concat({
        string.format('cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=%s "%s"', build_dir, build_type, root_dir),
        string.format('ninja -C "%s"', build_dir),
        exe
    }, " && ")

    vim.cmd("vsplit")
    vim.cmd("terminal " .. cmd)
end

-- Specific wrappers for Debug and Release
function DebugBuildAndRun()
    BuildAndRun("debug")
end

function ReleaseBuildAndRun()

    BuildAndRun("release")
end

-- Run an existing build without rebuilding
function Run(build_type)
    if build_type ~= "Debug" and build_type ~= "Release" then
        build_type = "Debug"
    end

    local root_dir = vim.fn.expand("%:p:h")
    local bin_dir = vim.fs.joinpath(root_dir, "build", "bin", string.lower(build_type))

    local executable = get_executable(bin_dir)
    if not executable then

        vim.notify("Error: No executable found in " .. bin_dir, vim.log.levels.ERROR)
        return
    end


    vim.cmd("vsplit")
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
