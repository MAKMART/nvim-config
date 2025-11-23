local M = {}

local project_cache = {}

local markers = {
  cmake = "CMakeLists.txt",
  make  = "Makefile",
  rust  = "Cargo.toml",
  node  = "package.json",
  go    = "go.mod",
}

local function exists(path)
  return vim.loop.fs_stat(path) ~= nil
end

function M.find_root(start_path)
  start_path = start_path or vim.loop.cwd()
  for type, marker in pairs(markers) do
    local found = vim.fs.find(marker, { upward = true, type = "file", path = start_path })[1]
    if found then
      return vim.fs.dirname(found), type
    end
  end
  return nil, "unknown"
end

function M.detect(root)
  if project_cache[root] then
    return project_cache[root]
  end

  for type, marker in pairs(markers) do
    if exists(vim.fs.joinpath(root, marker)) then
      project_cache[root] = type
      return type
    end
  end

  project_cache[root] = "unknown"
  return "unknown"
end

return M
