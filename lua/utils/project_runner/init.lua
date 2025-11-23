local detector = require("utils.project_runner.detector")

local M = {}

local runner_map = {
	cmake = require("utils.project_runner.runners.cmake"),
	make  = require("utils.project_runner.runners.make"),
	rust  = require("utils.project_runner.runners.rust"),
	node  = require("utils.project_runner.runners.node"),
	--go    = require("utils.project_runner.runners.go"),
}

function M.build(build_type)
	local root, project_type = detector.find_root()
	if not root then
		vim.notify("Cannot find project root", vim.log.levels.ERROR)
		return
	end

	local runner = runner_map[project_type]
	if not runner then
		vim.notify("Unsupported project type: " .. project_type, vim.log.levels.ERROR)
		return
	end
	local build_type = (build_type and build_type:lower()) or "release"

	if not runner then
		vim.notify("Unsupported project type: " .. project_type, vim.log.levels.ERROR)
		return
	end
	local cmd
	cmd = runner.build(build_type)
	if not cmd then
		vim.notify("Cannot find build command", vim.log.levels.ERROR)
		return
	end

	vim.cmd("vsplit")
	vim.cmd("terminal " .. cmd)
end

function M.run(build_type)
	local root, project_type = detector.find_root()
	if not root then
		vim.notify("Cannot find project root", vim.log.levels.ERROR)
		return
	end

	local runner = runner_map[project_type]
	if not runner then
		vim.notify("Unsupported project type: " .. project_type, vim.log.levels.ERROR)
		return
	end

	if not runner then
		vim.notify("Unsupported project type: " .. project_type, vim.log.levels.ERROR)
		return
	end

	local cmd
	if project_type == "cmake" then
		cmd = runner.run(root, build_type)
	elseif project_type == "rust" then
		cmd = runner.run(build_type)
	end

	if not cmd then
		vim.notify("Nothing to run", vim.log.levels.INFO)
		return
	end

	vim.cmd("vsplit")
	vim.cmd("terminal " .. cmd)
end

return M
