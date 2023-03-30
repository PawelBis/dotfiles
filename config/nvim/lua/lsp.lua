local model = {}

function model.setup(in_capabilities) 
  local lsp = require("lspconfig")

  -- Rust
  lsp.rust_analyzer.setup{
    capabilities = in_capabilities,
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = false;
        }
      }
    }
  }

  -- Lua
  lsp.lua_ls.setup {
    capabilities = in_capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  -- C++
  lsp.clangd.setup{}
end

return model
