-----------------------------------------------------------
-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-----------------------------------------------------------
-- Theme related stuff
vim.cmd [[set signcolumn=number]]
vim.cmd [[set splitbelow]]
vim.cmd [[set laststatus=3]]
vim.cmd [[set cursorline]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = ""

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", config = function()
      require("catppuccin").setup {
        flavour = "latte",
        vim.cmd.colorscheme "catppuccin"
      }
    end
  },
  { "nvim-lualine/lualine.nvim", dependencies = {
      { "kyazdani42/nvim-web-devicons", lazy = false },
    }
  },
  "j-hui/fidget.nvim",
  "SmiteshP/nvim-navic",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "rafamadriz/friendly-snippets",
  { "nvim-treesitter/nvim-treesitter", build = "TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },
  "nvim-telescope/telescope-ui-select.nvim",
  { "nvim-tree/nvim-tree.lua", 
    lazy = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = false },
    },
    config = function()
      require("nvim-tree").setup {}
    end
  },
  { "folke/which-key.nvim", config = function()
      require("which-key").setup {
        plugins = { spelling = { enabled = true, suggestions = 20, } }
      }
    end
  },
  "nvim-treesitter/nvim-treesitter-context",
  {
    "phaazon/mind.nvim",
    config = function()
      require("mind").setup()
    end
  },
  { "kylechui/nvim-surround", version = "*",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  "voldikss/vim-floaterm",
  { "folke/trouble.nvim", config = function()
      require("trouble").setup {

      }
    end
  },
  "mhartington/formatter.nvim",

})

require("fidget").setup {}
-- require("nvim-tree").setup()
require("nvim-web-devicons").setup {default = true}
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {

      }
    }
  }
}
require("telescope").load_extension("ui-select")
icons = require("nvim-web-devicons").get_icons()

function context()
  return "CONTEXT"
end

if vim.fn.has("nvim-0.8") == 1 then
  require("lualine").setup {
    options = {
      theme = "catppuccin"
    },
    sections = {
      lualine_a = {"mode"},
      lualine_b = {"branch", "diff", "diagnostics"},
      lualine_c = { {"filename", file_status = true, path = 1} },
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
else
  require("lualine").setup {
    options = {
      theme = "tokyonight"
    },
    sections = {
      lualine_a = {"mode"},
      lualine_b = {"branch", "diff", "diagnostics"},
      lualine_c = {"filename"},
      lualine_x = {"lsp_progress" , "filetype"},
      lualine_y = {},
      lualine_z = {}
    },
  }
end

-----------------------------------------------------------
-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})
vim.o.updatetime = 0
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

require("treesitter").setup()
require("nvim-treesitter.configs").setup {
  highlight = {
    enabled = true
  }
}
local cmp = require("compare")
cmp.setup()
require("lsp").setup(cmp.capabilities)

vim.wo.foldlevel= 20
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

function SetupRustTabs()
	vim.o.expandtab = true
	vim.o.tabstop = 4
	vim.o.shiftwidth = 4
end

vim.api.nvim_exec(
  [[
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
  ]],
  false
)

vim.api.nvim_exec(
	[[
	augroup rust-tabs
		autocmd!
		autocmd FileType rust,cpp lua SetupRustTabs()
	augroup end
	]],
	false
)

function SetupLuaTabs()
	vim.o.expandtab = true
	vim.o.tabstop = 2
	vim.o.shiftwidth = 2
end

vim.api.nvim_exec(
	[[
	augroup lua-tabs
		autocmd!
		autocmd FileType lua,javascript,css,typescript,html,typescriptreact lua SetupLuaTabs()
	augroup end
	]],
	false
)


-----------------------------------------------------------
-- WhichKey setup
local wk = require("which-key")
wk.register({
  f = { "<cmd>Telescope find_files<CR>", "Find File" },
  s = { "<cmd>Telescope live_grep<CR>", "Grep"},
  a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Actions" },
  r = {
    name = "Refactor",
    r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    f = { ":Format<CR>", "Format" },
    F = { ":FormatWrite<CR>", "Format and save" },
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
    h = { ":ClangdSwitchSourceHeader<CR>", "Swap to header file (C++)" }
  },
  g = {
    name = "Git",
    c = { "<cmd>Telescope git_commits<CR>", "Commits" },
    l = { "<cmd>Telescope git_bcommits<CR>", "This File Commits" },
    b = { "<cmd>Telescope git_branches<CR>", "Branches" },
    s = { "<cmd>Telescope git_status<CR>", "Status" },
    t = { "<cmd>Telescope git_stash<CR>", "Stash" },
  },
  t = {
    name = "Toggle", 
    t = { ":FloatermToggle<CR>", "Terminal" },
    g = { ":FloatermNew lazygit<CR>", "Git" },
    n = { ":set rnu!<CR>", "Relative Numbers" },
    p = { ":NvimTreeToggle<CR>", "Project Explorer" },
  },
  m = {
    name = "Mind notes",
    m = { ":MindOpenMain<CR>", "Open global mind notes" },
    c = { ":MindClose<CR>", "Close mind notes" },
  }
}, {prefix = "<leader>"})

-----------------------------------------------------------
-- Keybindings
local keymap = vim.api.nvim_set_keymap
local noremaps = { noremap = true, silent = true }
vim.g.mapleader = ' '

-- Normal mode
keymap("n", "  ", "<cmd>Telescope buffers<CR>", {})
keymap("n", " y", '"+y', {})
keymap("n", " p", '"+p', {})

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

-- Formatter
local utils = require("formatter.util")
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    cpp = {
      function()
        return {
          exe = "clang-format",
          args = {
            "-assume-filename",
            utils.escape_path(utils.get_current_buffer_file_name()),
          },
          stdin = true,
          try_node_modules = true,
        }
      end
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  }
}
