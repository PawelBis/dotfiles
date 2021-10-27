-- Rust setup
require("packer")

local rust_config = {}
local keymap = vim.api.nvim_set_keymap
local noremaps = { noremap = true, silent = true }

local init_cargo_keymap = function()
  keymap("n", "<leader>cc", ":FloatermNew cargo build<CR>", noremaps)
  keymap("n", "<leader>cr", ":FloatermNew cargo run<CR>", noremaps)
end

function rust_config.InitLsp()
  require("lspconfig").rust_analyzer.setup{
    on_attach = init_cargo_keymap
  }
end

local function SetupTabsInner()
  vim.o.expandtab = true
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
end

function rust_config.SetupTabs()
  vim.api.nvim_exec(
    [[
    augroup rust_tab_setup
      autocmd!
      autocmd FileType rust lua SetupTabsInner()
    augroup end
    ]],
    false
  )
end

return rust_config
