-- paths to check for project.godot file
-- - "/" nvim running directly in godot project
-- - "/../" nvim running in "project/src" directory
-- - "/godot/" nvim running in parent directory - used with godot-rust
local paths_to_check = { "/", "/../", "/godot/" }
local godot_project_path = ""
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for _, value in pairs(paths_to_check) do
	if vim.uv.fs_stat(cwd .. value .. "project.godot") then
		godot_project_path = cwd .. value
		break
	end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. "/server.pipe")
-- start server, if not already running
if godot_project_path:len() > 0 and not is_server_running then
	print("Starting Godot server...")
	vim.fn.serverstart(godot_project_path .. "/server.pipe")
end
