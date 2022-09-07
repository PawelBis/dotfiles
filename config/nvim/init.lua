vim.cmd [[packadd packer.nvim]]

-----------------------------------------------------------
-- Theme related stuff
vim.g.tokyonight_style = "night" vim.cmd [[silent! colorscheme tokyonight]]
vim.cmd [[set signcolumn=number]]
vim.cmd [[set splitbelow]]
vim.cmd [[set laststatus=3]]
vim.o.number = true
vim.o.relativenumber = true

require("packer").startup(function()
  use { "wbthomason/packer.nvim" }
  use { "folke/tokyonight.nvim" }
  use { 
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" }
  }
  use { "j-hui/fidget.nvim" }
  use { "SmiteshP/nvim-navic" }
  use { "neovim/nvim-lspconfig" }
  use { "simrat39/rust-tools.nvim" }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup{}
    end,
    requires = {{ "anuvyklack/nvim-keymap-amend" }}
  }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/nvim-cmp" }
  use { "nvim-telescope/telescope.nvim",
    requires = {{ "nvim-lua/plenary.nvim" }}
  }
  use {
    "kyazdani42/nvim-tree.lua",
    requires = { 
      "kyazdani42/nvim-web-devicons",
    },
    tag = "nightly"
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 20,
          }
        }
      }
    end
  }
  use {
    "lukas-reineke/indent-blankline.nvim"
  }
end)

require("fidget").setup{}
require("nvim-tree").setup()
require("nvim-web-devicons").setup{default = true}

function context()
  return "CONTEXT"
end
require("lualine").setup{
  options = {
    theme = "tokyonight",
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {"filename"},
    lualine_x = {"lsp_progress" , "filetype"},
    lualine_y = {},
    lualine_z = {}
  },
  winbar = { 
	  lualine_a = { {context} },
	  lualine_b = { { require("nvim-navic").get_location, cond = require("nvim-navic").is_available }, }
  },
  inactive_winbar = { 
	  lualine_a = { {context} },
  }
}

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = false,
}

-----------------------------------------------------------
-- Diagnostics
vim.diagnostic.config({
 virtual_text = false,
 signs = true,
 underline = true,
 update_in_insert = true,
 severity_sort = false,
})


-----------------------------------------------------------
-- Treesitter
require("nvim-treesitter.configs").setup {
	ensure_installed = { "rust", "php", "javascript" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
}

vim.wo.foldlevel= 20
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd [[autocmd BufWinLeave *.* mkview]]
vim.cmd [[autocmd BufWinEnter *.* silent loadview]]


-----------------------------------------------------------
-- Autocompletion (nvim-cmp)
vim.cmd [[set completeopt=menu,menuone,noselect]]
local cmp = require("cmp")
cmp.setup({
mapping = {
  ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
  ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
  ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  }),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<Tab>'] = cmp.mapping.confirm({ select = true }),
},
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

local rt = require("rust-tools")
rt.setup({
  tools = {
    inlay_hints = {
      only_current_line = true,
    }
  },
  server = {
    on_attach = function(c, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      require("nvim-navic").attach(c, bufnr)
    end,
  }
})

function SetupRustTabs()
	vim.o.expandtab = true
	vim.o.tabstop = 4
	vim.o.shiftwidth = 4
end

vim.api.nvim_exec(
	[[
	augroup rust-tabs
		autocmd!
		autocmd FileType rust lua SetupRustTabs()
	augroup end
	]],
	false
)


-----------------------------------------------------------
-- Lua
-- require("lspconfig").sumneko_lua.setup {
--  settings = {
--    Lua = {
--      runtime = {
--        version = 'LuaJIT',
--      },
--      diagnostics = {
--        globals = {'vim'},
--      },
--      workspace = {
--        library = vim.api.nvim_get_runtime_file("", true),
--      },
--      telemetry = {
--        enable = false,
--      },
--    },
--  },
-- }

function SetupLuaTabs()
	vim.o.expandtab = true
	vim.o.tabstop = 2
	vim.o.shiftwidth = 2
end

vim.api.nvim_exec(
	[[
	augroup lua-tabs
		autocmd!
		autocmd FileType lua lua SetupLuaTabs()
	augroup end
	]],
	false
)


-----------------------------------------------------------
-- WhichKey setup
local wk = require("which-key")
wk.register({
 f = {
   name = "File",
   f = { "<cmd>Telescope git_files<CR>", "Find File" },
   r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
   t = { "<cmd>NvimTreeToggle<CR>", "Show Files Tree" },
   v = { "<C-w>v<C-w>l<cmd>Telescope find_files<CR>", "Open in vertical split" },
   s = { "<C-w>s<C-w>l<cmd>Telescope find_files<CR>", "Open in horizontal split" },
 },
 r = {
   name = "Refactor",
   r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
   --a = { "<cmd>lua rt.code_action_group.code_action_group<CR>", "Code Actions" },
 },
 l = {
   name = "Lsp",
   r = { "<cmd>Telescope lsp_references<CR>", "References" },
   f = { "<cmd>lua vim.lsp.buf.formatting<CR>", "Formatting" },
   i = { "<cmd>Telescope lsp_incoming_calls<CR>", "Incoming Calls" },
   o = { "<cmd>Telescope lsp_outgoing_calls<CR>", "Outgoing Calls" },
   s = { "<cmd>Telescope lsp_document_symbols<CR>", "Local Symbols" },
   w = { "<cmd>Telescope lsp_document_symbols<CR>", "Workspace Symbols" },
   d = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
   t = { ":Trouble<CR>", "Diagnostics Window" },
 },
 g = {
   name = "Git",
   c = { "<cmd>Telescope git_commits<CR>", "Commits" },
   l = { "<cmd>Telescope git_bcommits<CR>", "This File Commits" },
   b = { "<cmd>Telescope git_branches<CR>", "Branches" },
   s = { "<cmd>Telescope git_status<CR>", "Status" },
   t = { "<cmd>Telescope git_stash<CR>", "Stash" },
 },
 s = {
   name = "Search",
   s = { "<cmd>Telescope live_grep<CR>", "Grep"},
   S = { "<cmd>Telescope search_history<CR>", "Search History"},
   t = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Buffer Fuzzy Find"},
   c = { "<cmd>Telescope command_history<CR>", "Command History"},
   b = { "<cmd>Telescope buffers<CR>", "Buffers"},
 },
 t = {
   name = "Toggle", 
   t = { ":15sp +terminal<CR>A", "Terminal" },
   n = { ":set rnu!<CR>", "Relative Numbers" },
 }
}, {prefix = "<leader>"})

-----------------------------------------------------------
-- Keybindings
local keymap = vim.api.nvim_set_keymap
local noremaps = { noremap = true, silent = true }
vim.g.mapleader = ' '
keymap("i", "jk", "<ESC>", {})

-- Insert mode h/j/k/l
keymap("i", "<C-h>", "<Left>", noremaps)
keymap("i", "<C-l>", "<Right>", noremaps)
keymap("i", "<C-k>", "<Up>", noremaps)
keymap("i", "<C-j>", "<Down>", noremaps)

-- Improve undo chain
keymap("i", ",", ",<C-g>u", {})
keymap("i", ".", ".<C-g>u", {})
keymap("i", "!", "!<C-g>u", {})
keymap("i", "?", "?<C-g>u", {})

-- Save jumps > 5 to jumplist
keymap("n", "k", "(v:count > 4 ? \"m'\" . v:count : \"\") . 'gk'", {
noremap = true,
expr = true,
silent = true,
})
keymap("n", "j", "(v:count > 4 ? \"m'\" . v:count : \"\") . 'gj'", {
noremap = true,
expr = true,
silent = true,
})

-- Lsp
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz", noremaps)
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz", noremaps)
keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", noremaps)
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", noremaps)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", noremaps)
keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", noremaps)

-- Bring Y inline with other commands
keymap("n", "Y", "y$", noremaps)

-- Better jumps
keymap("n", "n", "nzzzv", noremaps)
keymap("n", "N", "Nzzzv", noremaps)
keymap("n", "J", "mzJ'z", noremaps)
keymap("n", "*", "*zzzv", noremaps)
keymap("n", "#", "#zzzv", noremaps)
keymap("n", "<C-o>", "<C-o>zzzv", noremaps)
keymap("n", "<C-i>", "<C-i>zzzv", noremaps)

-- Clear highlighting with ESC
keymap("n", "<ESC>", ":noh<CR><ESC>", noremaps)

-- Telescope
-- keymap("n", "<C-p>", "<cmd>Telescope find_files<CR>", noremaps)
-- keymap("n", "<leader>s", "<cmd>Telescope live_grep<CR>", noremaps)
-- keymap("n", "<leader>b", "<cmd>Telescope buffers<CR>", noremaps)
-- keymap("n", "<leader>h", "<cmd>Telescope search_history<CR>", noremaps)
-- keymap("n", "<leader>h", "<cmd>Telescope lsp_document_symbols<CR>", noremaps)
-- keymap("n", "<leader>d", "<cmd>Trouble<CR>", noremaps)

-- Windows
keymap("n", "<C-w>v", "<C-w>v<C-w>l", noremaps)
keymap("n", "<C-w>o", "<C-w>v<C-w>l<cmd>Telescope find_files<CR>", noremaps)

-- Terminal
keymap("t", "<Esc>", "<C-\\><C-n>", noremaps)
