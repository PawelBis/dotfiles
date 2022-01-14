vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden"
require("general")
require("keymap")

-- Install packages
require("packer").startup(function()
  use "PawelBis/nvim-snip"

  use "wbthomason/packer.nvim"
  use "neovim/nvim-lspconfig"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "saadparwaiz1/cmp_luasnip"
  use "dracula/vim"
  use "antoinemadec/FixCursorHold.nvim"
  use "lambdalisue/fern.vim"
  use "kyazdani42/nvim-web-devicons"
  use "ryanoasis/vim-devicons"
  use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }
  use "voldikss/vim-floaterm"
  use "lukas-reineke/indent-blankline.nvim"
  use { 'nvim-treesitter/nvim-treesitter', branch = '0.5-compat', run = ':TSUpdate' }
  use "folke/tokyonight.nvim"
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup{
        auto_fold = true,
      }
    end
  }
  use "webdevel/tabulous"
  use "L3MON4D3/LuaSnip"
  use {
    "phaazon/hop.nvim",
    branch = "v1",
    config = function()
      require("hop").setup{}
    end
  }
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } }
  }
end)

vim.g.tabulousLabelModifiedStr = '*'
vim.g.tabulousLabelNameOptions = ':t'
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "rust",
    "lua",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}

require("nvim-web-devicons").setup {
  default = true;
}

vim.opt.list = true
require("indent_blankline").setup{
  char = '|',
  buftype_exclude = { "terminal" },
}

require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "tokyonight",
    component_separators = { left = "", right = "" },
    section_separators = { left = "",  right = "" },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff"},
    lualine_c = {"filename"},

    lualine_x = {"encoding"},
    lualine_y = {"filetype"},
    lualine_z = {"location"}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

local luasnip = require("luasnip")
-- nvim-cmp autocomplete setup
vim.o.completeopt = "menu,menuone,noselect"
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  mapping = {
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<ESC>"] = function()
      cmp.mapping.close()
      vim.cmd("stopinsert")
    end,
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-l>"] = cmp.mapping.close(),
    ["<Down>"] = cmp.mapping.scroll_docs(1),
    ["<Up>"] = cmp.mapping.scroll_docs(-1),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = ({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  })
})
require("snippets")

-- Lang specific setup
local rust_config = require("rust_config")
rust_config.InitLsp()
local lua_config = require("lua_config")
lua_config.InitLsp("C:/tools/lua-language-server")

require("latex_config")

-- Enter insert mode automatically upon entering term buffer
vim.api.nvim_exec(
[[
augroup terminal-custom
	autocmd!
    autocmd TermOpen * startinsert
augroup END
]],
false
)
