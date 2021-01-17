call plug#begin('/home/aoamne/.config/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'neoclide/coc.nvim', { 'as': 'coc', 'branch': 'release' }
Plug 'jackguo380/vim-lsp-cxx-highlight', { 'as': 'cpp-highlight' }
Plug 'itchyny/lightline.vim', { 'as': 'lightline' }
Plug 'preservim/nerdtree', { 'as': 'nerdtree' }
Plug 'mileszs/ack.vim', { 'as': 'ack' }
Plug 'junegunn/fzf', { 'as': 'fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'as': 'fzf.vim' }
call plug#end()

set relativenumber
set tabstop=4
set shiftwidth=4
inoremap jj <ESC>
inoremap jJ <ESC>
inoremap Jj <ESC>
inoremap JJ <ESC>
colorscheme dracula
let g:lightline = {
	\ 'colorscheme' : 'dracula'
	\ }

" Coc
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c

if has("patch-8.1.1564")
	set signcolumn=number
else
	set signcolumn=yes
end

inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
	\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implemenation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
	if (index(['vim', 'help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	else
		execute '!' . &keywordprg . " " . expand('<cword>')
	endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" leader keybindings
nnoremap <SPACE> <nop>
let mapleader = " "

nmap <leader>sr :set relativenumber!<CR>
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>se :NERDTreeToggle<CR>
nmap <leader>of :Files<CR>
nmap <leader>or :History<CR>
" nmap <leader>rf <Plug>(coc-format-selected)
