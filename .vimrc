execute pathogen#infect()
syntax on
filetype plugin indent on

" backup
set noswapfile
set nobackup
set nowb
set wildignore=*.swp,*.bak,*.pyc,*.class

" display settings
syntax enable      " allays show highlight for file
set nowrap         " dont wrap lines
set number         " show line number
set ruler          " show cursor position in status bar
set title          " show file in titlebar
set wildmenu       " enhanced command-line completion
set laststatus=2   " Always display status line

set autoread
set visualbell     " shut vim up
set noerrorbells

"encoding
set encoding=utf8
set termencoding=utf-8
set fileencodings=          " Don't do any encoding conversion

set clipboard=unnamedplus

"History
set history=1000    " remember more commands and search history
set undolevels=1000 " use many much levels of undo

" searching
set smarttab   " insert tabs on the start of a line according to
"              " shiftwidth, not tabstop
set hlsearch   " highlight search terms
set incsearch  " show search matches as you type
set smartcase  " ignore case if search pattern is all lowercase,
"              " case-sensitive otherwise
set ignorecase " ignore case when searching

" indent
set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
set cindent         "Like smartindent, but stricter and more customisable

" Enable folding
set foldmethod=indent
set foldlevel=99

set pastetoggle=<F12> 

set t_Co=256

" The default leader is '\\', changed to ','
let mapleader=","

function! Refresh()
  "Use Ctrl L to redraw the screen. You can also use :redraw
    " code
    set noconfirm
    bufdo e!
    set confirm
endfunction

nmap <F5> :call Refresh()<CR>

" =========== PLUGINS =============
" nerdtree
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']

" syntastic
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_full_redraws=1

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" syntastic Go
let g:syntastic_auto_loc_list = 1
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
" let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" vim-go
let g:gofmt_command="goimports"
let g:go_list_type = "quickfix"

" tagbar
let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
"let g:ctrlp_custom_ignore = {
"      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"      \ 'file': '\v\.(exe|so|dll)$',
"      \ }

" godef
let g:godef_split=1 "0 new buffer, 1 split window, 2 new tab, 3 vsplit window
command! GoDefNewTab call ChangeGoDef(2)
command! GoDefCurrent call ChangeGoDef(0)
command! GoDefHorizontal call ChangeGoDef(1)
command! GoDefVertical call ChangeGoDef(3)
function! ChangeGoDef(v)
  echo "changing godef split to" a:v
  let g:godef_split=a:v
endfunction


" ============ MAPS KEYBARDS ==========
" Remap VIM 0 to first non-blank character
map 0 ^

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" keep the yanked text on paste
xnoremap <expr> p 'pgv"'.v:register.'y'

" NERDTree
map <C-n> :NERDTreeToggle<CR>
map <C-S-n> :NERDTreeFind <CR>

" NERD COMMENTER
map <Leader>/ <plug>NERDCommenterToggle

"Buffer
map <F2> :Bufferlist <CR>

"TagBar
map <F8> :TagbarToggle <CR>
map <Leader>f :Rgrep <CR>
map <Leader>fb :Bgrep <CR>

" GITTER
map <Leader>tg :GitGutterToggle <CR>
map Tg :GitGutterToggle <CR>
map <Leader>tgs :GitGutterSignsToggle <CR>
map Tgs :GitGutterSignsToggle <CR>
map <Leader>tgl :GitGutterLineHighlightsToggle <CR>
map Tgl :GitGutterLineHighlightsToggle <CR>


" normal mode for jsbeautify
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
" visual mode for js beautify
autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>

" Links 
" https://www.ibm.com/developerworks/library/l-vim-script-1/
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
