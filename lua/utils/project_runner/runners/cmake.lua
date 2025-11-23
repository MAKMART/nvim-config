local M = {}

function M.build(build_type)
  return string.format('cmake --preset "%s" && cmake --build --preset "%s"', build_type, build_type)
end

local function find_exe(dir)
	local uv = vim.loop
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

function M.run(root, build_type)
  local bin_dir = vim.fs.joinpath(root, "build", "bin", build_type)
  vim.notify("Using bin_dir = " .. bin_dir, vim.log.levels.DEBUG)
  local exe = find_exe(bin_dir)
  if not exe then return nil end
  return string.format('cd "%s" && "%s"', bin_dir, exe)
end

return M
