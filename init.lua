vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden"

require("general")

-- Install packages
require("packer").startup(function()
  use "wbthomason/packer.nvim"
  use "neovim/nvim-lspconfig"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "dracula/vim"
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "antoinemadec/FixCursorHold.nvim"
  use "lambdalisue/fern.vim"
  use "kyazdani42/nvim-web-devicons"
  use "ryanoasis/vim-devicons"
  use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }
  use "voldikss/vim-floaterm"
  use "lukas-reineke/indent-blankline.nvim"
  use "SirVer/ultisnips"
  use "honza/vim-snippets"
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
end)

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
    component_separators = {"", ""},
    section_separators = {"", ""},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch"},
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

-- nvim-cmp autocomplete setup
vim.o.completeopt = "menu,menuone,noselect"
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
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
  },
  sources = ({
    { name = "nvim_lsp" },
    { name = "ultisnips" },
  })
})

local rust_config = require("rust_config")
rust_config.InitLsp()

function OpenFloaterm(cmd, width, height, autoclose)
    cmd = cmd or ""
    width = width or 0.8
    height = height or 0.8
    local swidth = "--width=" .. width .. " "
    local sheight = "--height=" .. height .. " "
    local sautoclose = ""
    if autoclose then
        sautoclose = "--autoclose=1 "
    end

    return ":FloatermNew " .. swidth .. sheight .. sautoclose .. cmd .. "<CR>"
end

-- Modes:
-- i - insert
-- n - normal
-- v - visual
local keymap = vim.api.nvim_set_keymap local noremaps = { noremap = true, silent = true } vim.g.mapleader = ' '
keymap("i", "jk",               "<ESC>",                                                  {})
keymap("i", ",",                ",<C-g>u",                                                {})
keymap("i", ".",                ".<C-g>u",                                                {})
keymap("i", "!",                "!<C-g>u",                                                {})
keymap("i", "?",                "?<C-g>u",                                                {})
keymap("n", "gd",               "<cmd>lua vim.lsp.buf.definition()<CR>",                  noremaps)
keymap("n", "gD",               "<cmd>lua vim.lsp.buf.declaration()<CR>",                 noremaps)
keymap("n", "gr",               "<cmd>lua vim.lsp.buf.references()<CR>",                  noremaps)
keymap("n", "gi",               "<cmd>lua vim.lsp.buf.implementation()<CR>",              noremaps)
keymap("n", "K",                "<cmd>lua vim.lsp.buf.hover()<CR>",                       noremaps)
keymap("n", "<C-k>",            "<cmd>lua vim.lsp.buf.signature_help()<CR>",              noremaps)
keymap("n", "<C-p>",            "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",            noremaps)
keymap("n", "<C-n>",            "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",            noremaps)
keymap("n", "<leader>rr",       "<cmd>lua vim.lsp.buf.rename()<CR>",                      noremaps)
keymap('n', "<leader><leader>", ":Files<CR>",                                             noremaps)
keymap('n', "<leader>f",        ":Fern . -toggle -right -drawer -reveal=% -width=35<CR><C-w>=",  noremaps)
keymap("n", "<leader>tt",       OpenFloaterm(),                                           noremaps)
keymap("n", "<leader>tg",       OpenFloaterm("lazygit", 0.9, 0.9, true),                  noremaps)
keymap("n", "Y",                "y$",                                                     noremaps)
keymap("n", "n",                "nzzzv",                                                  noremaps)
keymap("n", "N",                "Nzzzv",                                                  noremaps)
keymap("n", "J",                "mzJ'z",                                                  noremaps)
keymap("n", "*",                "*zzzv",                                                  noremaps)
keymap("n", "#",                "#zzzv",                                                  noremaps)
keymap("n", "<ESC>",            ":noh<CR><ESC>",                                          noremaps)
keymap("n", "k",                "(v:count > 5 ? \"m'\" . v:count : \"\") . 'k'",          { noremap = true, expr = true, silent = true })
keymap("n", "j",                "(v:count > 5 ? \"m'\" . v:count : \"\") . 'j'",          { noremap = true, expr = true, silent = true })

local buffer_keymap = vim.api.nvim_buf_set_keymap
function InitFern()
  vim.cmd("nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)")
  buffer_keymap(0, "", "n",     "<Plug>(fern-action-new-path)",                           {})
  buffer_keymap(0, "", "d",     "<Plug>(fern-action-remove)",                             {})
  buffer_keymap(0, "", "m",     "<Plug>(fern-action-move)",                               {})
  buffer_keymap(0, "", "r",     "<Plug>(fern-action-rename)",                             {})
  buffer_keymap(0, "", "R",     "<Plug>(fern-action-reload)",                             {})
  buffer_keymap(0, "", "H",     "<Plug>(fern-action-hidden-toggle)",                      {})
  buffer_keymap(0, "", "\'",    "<Plug>(fern-action-mark:toggle)",                        {})
  buffer_keymap(0, "", "v",     "<Plug>(fern-action-open:vsplit)",                        {})
  buffer_keymap(0, "", "b",     "<Plug>(fern-action-open:split)",                         {})
end

function SetupLuaTabs()
  vim.o.expandtab = true
  vim.o.tabstop = 2
  vim.o.shiftwidth = 2
end

-- Init Fern keybindings in fern buffers
vim.api.nvim_exec(
[[
augroup fern-custom
	autocmd! *
	autocmd FileType fern lua InitFern()
augroup END
]],
false
)

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

vim.api.nvim_exec(
[[
augroup lua-tabs
	autocmd!
    autocmd FileType lua lua SetupLuaTabs()
augroup END
]],
false
)
