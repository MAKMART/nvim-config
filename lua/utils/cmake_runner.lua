local M = {}
local uv = vim.loop
local bit = require("bit")

function M.find_cmake_root()
  local cwd = uv.cwd()
  local path = cwd
  while path do
    local candidate = path .. "/CMakeLists.txt"
    local stat = uv.fs_stat(candidate)
    if stat and stat.type == "file" then return path end
    local parent = path:match("(.+)/[^/]+$")
    if parent == path then break end
    path = parent
  end
  return nil
end

function M.find_executable_in_dir(dir)
  local handle = uv.fs_scandir(dir)
  if not handle then return nil end
  while true do
    local name, type = uv.fs_scandir_next(handle)
    if not name then break end
    local path = dir .. "/" .. name
    if type == "file" then
      local stat = uv.fs_stat(path)
      if stat then
        local is_windows = uv.os_uname().sysname == "Windows_NT"
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

function M.run_build_and_exec(build_type)
  build_type = build_type or "Release"
  local root_dir = M.find_cmake_root()
  if not root_dir then
    vim.notify("CMakeLists.txt not found", vim.log.levels.ERROR)
    return
  end
  local build_dir = root_dir .. "/build"
  local bin_dir = build_dir .. "/bin/" .. build_type:lower()
  local exe = M.find_executable_in_dir(bin_dir)
  local cmd = string.format(
    'cmake -G Ninja -B "%s" -DCMAKE_BUILD_TYPE=%s "%s" && ' ..
    'ninja -C "%s" && "%s"',
    build_dir, build_type, root_dir, build_dir, exe or ""
  )
  --vim.cmd("vsplit")
  --vim.cmd("terminal " .. cmd)
  require("utils.floaterminal").toggle_terminal(cmd)
end

function M.run_only(build_type)
  local root_dir = M.find_cmake_root()
  local bin_dir = root_dir .. "/build/bin/" .. build_type:lower()
  local exe = M.find_executable_in_dir(bin_dir)
  if not exe then
    vim.notify("No executable found in " .. bin_dir, vim.log.levels.ERROR)
    return
  end
  --vim.cmd("vsplit")
  --vim.cmd("terminal " .. exe)
  require("utils.floaterminal").toggle_terminal(exe)
end

return M
