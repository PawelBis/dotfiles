local function OpenFloaterm(cmd, width, height, autoclose)
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

-- Imrpve undo keychain
keymap("i", ",",                ",<C-g>u",                                                {})
keymap("i", ".",                ".<C-g>u",                                                {})
keymap("i", "!",                "!<C-g>u",                                                {})
keymap("i", "?",                "?<C-g>u",                                                {})

-- j / k motions that are longer than 5 are now writing into jump list
keymap("n", "k",                "(v:count > 5 ? \"m'\" . v:count : \"\") . 'k'",          { noremap = true, expr = true, silent = true })
keymap("n", "j",                "(v:count > 5 ? \"m'\" . v:count : \"\") . 'j'",          { noremap = true, expr = true, silent = true })

-- Lsp bindings
keymap("n", "gd",               "<cmd>lua vim.lsp.buf.definition()<CR>",                  noremaps)
keymap("n", "gD",               "<cmd>lua vim.lsp.buf.declaration()<CR>",                 noremaps)
keymap("n", "gr",               "<cmd>lua vim.lsp.buf.references()<CR>",                  noremaps)
keymap("n", "gi",               "<cmd>lua vim.lsp.buf.implementation()<CR>",              noremaps)
keymap("n", "K",                "<cmd>lua vim.lsp.buf.hover()<CR>",                       noremaps)
keymap("n", "<C-k>",            "<cmd>lua vim.lsp.buf.signature_help()<CR>",              noremaps)
keymap("n", "<C-p>",            "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",            noremaps)
keymap("n", "<C-n>",            "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",            noremaps)
keymap("n", "<leader>rr",       "<cmd>lua vim.lsp.buf.rename()<CR>",                      noremaps)

-- File exploration
keymap('n', "<leader><leader>", ":Files<CR>",                                             noremaps)
keymap('n', "<leader>f",        ":Fern . -toggle -right -drawer -reveal=%<CR>",           noremaps)

-- Floaterm windows
keymap("n", "<leader>tt",       OpenFloaterm(),                                           noremaps)
keymap("n", "<leader>tg",       OpenFloaterm("lazygit", 0.9, 0.9, true),                  noremaps)
keymap("n", "<leader>ff",       ":Rg<CR>",                                                noremaps)
keymap("n", "<leader>fw",       ":Rg \"<C-r><C-w><CR>\"",                                 noremaps)
keymap("n", "<leader>fW",       ":Rg <C-r><C-a><CR>",                                     noremaps)

-- hop.nvim jumps
keymap("n", "<leader>j/",       ":HopPattern<CR>",                                        noremaps)
keymap("n", "<leader>jf",       ":HopChar<CR>",                                           noremaps)
keymap("n", "<leader>jl",       ":HopLine<CR>",                                           noremaps)
keymap("n", "<leader>jw",       ":HowWord<CR>",                                           noremaps)

-- 'Y' is inline with other uppercase bindings
keymap("n", "Y",                "y$",                                                     noremaps)

-- Center after jumps
keymap("n", "n",                "nzzzv",                                                  noremaps)
keymap("n", "N",                "Nzzzv",                                                  noremaps)
keymap("n", "J",                "mzJ'z",                                                  noremaps)
keymap("n", "*",                "*zzzv",                                                  noremaps)
keymap("n", "#",                "#zzzv",                                                  noremaps)

-- Remove highlight with esc
keymap("n", "<ESC>",            ":noh<CR><ESC>",                                          noremaps)

-- Tab management
keymap("n", "<TAB>",            ":tabn<cr>",                                              noremaps)
keymap("n", "<S-TAB>",          ":tabp<cr>",                                              noremaps)
keymap("n", "<C-1>",            ":tabn1<cr>",                                             {})
keymap("n", "<C-2>",            ":tabn2<cr>",                                             {})
keymap("n", "<C-3>",            ":tabn3<cr>",                                             {})
keymap("n", "<C-4>",            ":tabn4<cr>",                                             {})
keymap("n", "<C-5>",            ":tabn5<cr>",                                             {})
keymap("n", "<C-6>",            ":tabn6<cr>",                                             {})
keymap("n", "<C-7>",            ":tabn7<cr>",                                             {})
keymap("n", "<C-8>",            ":tabn8<cr>",                                             {})
keymap("n", "<C-9>",            ":tabn9<cr>",                                             {})

keymap("n", "<Plug>(fern-close)", ":FernDo close<CR>",                                    { silent = true, })

local buffer_keymap = vim.api.nvim_buf_set_keymap
function InitFern()
  buffer_keymap(0, "", "<Plug>(fern-action-open)", "<Plug>(fern-action-open:select) <Plug>(fern-close)", {})
  buffer_keymap(0, "", "n",     "<Plug>(fern-action-new-path)",                           {})
  buffer_keymap(0, "", "d",     "<Plug>(fern-action-remove)",                             {})
  buffer_keymap(0, "", "m",     "<Plug>(fern-action-move)",                               {})
  buffer_keymap(0, "", "r",     "<Plug>(fern-action-rename)",                             {})
  buffer_keymap(0, "", "R",     "<Plug>(fern-action-reload)",                             {})
  buffer_keymap(0, "", "H",     "<Plug>(fern-action-hidden-toggle)",                      {})
  buffer_keymap(0, "", "\'",    "<Plug>(fern-action-mark:toggle)",                        {})
  buffer_keymap(0, "", "v",     "<Plug>(fern-action-open:vsplit) <Plug>(fern-close)",     {})
  buffer_keymap(0, "", "b",     "<Plug>(fern-action-open:split) <Plug>(fern-close)",      {})
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

