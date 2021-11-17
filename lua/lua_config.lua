-- Lua LSP setup
local lua_config = {}

function lua_config.InitLsp(lua_lsp_dir)
  require'lspconfig'.sumneko_lua.setup{
  cmd = { lua_lsp_dir .. "/bin/Windows/lua-language-server.exe", "-E", lua_lsp_dir .. "/main.lua"};
  settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = {'vim', 'use'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }
  lua_config.SetupTabs()
end

function SetupLuaTabs()
  vim.o.expandtab = true
  vim.o.tabstop = 2
  vim.o.shiftwidth = 2
end

function lua_config.SetupTabs()
  vim.api.nvim_exec(
    [[
    augroup lua_tab_setup
      autocmd!
      autocmd FileType lua lua SetupLuaTabs()
    augroup end
    ]],
    false
  )
end

return lua_config
