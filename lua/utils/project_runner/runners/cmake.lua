local M = {}

function M.build(build_type)
  return string.format('cmake --preset "%s" && cmake --build --preset "%s"', build_type, build_type)
end

function M.run(root, build_type, find_exe)
  local bin_dir = vim.fs.joinpath(root, "build", "bin", build_type)
  vim.notify("Using bin_dir = " .. bin_dir, vim.log.levels.DEBUG)
  local exe = find_exe(bin_dir)
  if not exe then return nil end
  return string.format('cd "%s" && "%s"', bin_dir, exe)
end

return M
