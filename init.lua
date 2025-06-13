vim.opt.termguicolors = true
vim.loader.enable()

-- Options
vim.opt.swapfile = false         -- no .swp files
vim.opt.backup = false           -- no extra file copy
vim.opt.writebackup = true       -- safe write to temp file first, then replace
vim.opt.updatetime = 200
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = "number"
vim.opt.shiftwidth = 4	-- 4 space indenting (goated)
-- Enable folding based on syntax (works well for most languages)
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevelstart = 99  -- Start with all folds open


vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    only_current_line = true, -- Show only for the line you're on
  },
  signs = true,
  underline = true,
})

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
require("lazy").setup("plugins", { --Setup plugins using lua/plugins/init.lua
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
            },
        },
    },
})
local uv = vim.loop
-- Helper: search upward for CMakeLists.txt starting from cwd
function find_cmake_root()
    local cwd = uv.cwd()
    local path = cwd
    while path do
        local candidate = path .. "/CMakeLists.txt"
        local stat = uv.fs_stat(candidate)
        if stat and stat.type == "file" then
            return path
        end
        -- Move one directory up
        local parent = path:match("(.+)/[^/]+$")
        if parent == path then
            break
        end
        path = parent
    end
    return nil

end

-- Reuse executable finder (same as before)
function find_executable_in_dir(dir)
    local handle = uv.fs_scandir(dir)

    if not handle then return nil end


    while true do
        local name, type = uv.fs_scandir_next(handle)
        if not name then break end
        local path = dir .. "/" .. name
        if type == "file" then
            local stat = uv.fs_stat(path)
            if stat then
                local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
                if is_windows then
                    if name:match("%.exe$") or name:match("%.bat$") or name:match("%.cmd$") then
                        return path
                    end
                else
                    if bit.band(stat.mode, 0x49) ~= 0 then
                        return path
                    end
                end
            end
        end
    end
    return nil
end

-- Main function: auto detects root, sets build/bin dirs, runs build and exec

function run_build_and_exec(build_type)
    build_type = build_type or "Release"
    local root_dir = find_cmake_root()

    if not root_dir then

        vim.notify("CMakeLists.txt not found in any parent directory.", vim.log.levels.ERROR)
        return
    end

    local build_dir = root_dir .. "/build"
    local bin_dir
    local build_type_lower = build_type:lower()
    if build_type_lower == "debug" then
        bin_dir = build_dir .. "/bin/debug"

        build_type = "Debug"
    else
        bin_dir = build_dir .. "/bin/release"
        build_type = "Release"
    end

    local exe = find_executable_in_dir(bin_dir)

    -- Compose a shell command that:
    -- 1. Runs cmake
    -- 2. Runs ninja
    -- 3. If build succeeds, runs the executable
    -- 4. Stops if any step fails (due to && chaining)

    local cmd = string.format(
        'cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=%s "%s" && ' ..
        'ninja -C "%s" && ' ..
        '"%s"',
        build_dir, build_type, root_dir, build_dir, exe or ""

    )

    vim.cmd("vsplit")

    vim.cmd("terminal " .. cmd)
end

-- Specific wrappers for Debug and Release
function DebugBuildAndRun()
    run_build_and_exec("Debug")
end

function ReleaseBuildAndRun()
    run_build_and_exec("Release")
end

-- Run an existing build without rebuilding
function Run(build_type)
    if build_type ~= "Debug" and build_type ~= "Release" then
        build_type = "Debug"
    end

    local root_dir = find_cmake_root()
    local bin_dir = vim.fs.joinpath(root_dir, "build", "bin", string.lower(build_type))

    local executable = find_executable_in_dir(bin_dir)
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
