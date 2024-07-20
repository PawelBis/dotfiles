if gd_initialised == true then
  return
end

gd_initialised = true
local port = 6005
local cmd = vim.lsp.rpc.connect("127.0.0.1", port)
local pipe = "/tmp/godot.pipe"

vim.lsp.start({
  name = "godot",
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true }) [1]),
  on_attach = function(client, bufnr)
    vim.api.nvim_command('echo serverstart("'.. pipe .. '")')
  end
})
