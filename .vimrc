" Runtime path and file types setup

" Let pathogen.vim be our plugin manager
execute pathogen#infect()

" Source optional bundled Vim scripts
runtime ftplugin/man.vim
runtime macros/matchit.vim

" Maktaba playground below
source $HOME/.vim/maktaba/maktaba/bootstrap.vim
let $MAKTABA_HOME = maktaba#path#Join([$HOME, '.vim', 'maktaba'])
function! LocalLibInstaller(library) abort
  " Fake an installer that knows how to map a library name to a location
  let l:fakerepo = {
      \ 'fictional.vim': maktaba#path#Join([$MAKTABA_HOME, 'i_dont_exist']),
      \ 'magnum.vim': maktaba#path#Join([$MAKTABA_HOME, 'magnum']),
      \ }
  if has_key(l:fakerepo, a:library) && isdirectory(resolve(l:fakerepo[a:library]))
    return maktaba#plugin#GetOrInstall(l:fakerepo[a:library])
  endif
  throw maktaba#error#NotFound(a:library)
endfunction
call maktaba#library#AddInstaller('locallibs', 'LocalLibInstaller')

call maktaba#plugin#GetOrInstall(maktaba#path#Join([$MAKTABA_HOME, 'glaive']))
call maktaba#plugin#GetOrInstall(maktaba#path#Join([$MAKTABA_HOME, 'radical'])).Flag('plugin[mappings]', 1)

" Enable file type and syntax support
filetype plugin indent on
syntax enable

" Settings

set encoding=utf-8

set fileformats+=mac

set directory^=~/.local/share/vim/swap//

if has('persistent_undo')
  set undodir^=~/.local/share/vim/undo//
  set undofile
endif

set autoread

" The new regexp engine isn't ready yet
if exists('&regexpengine')
  set regexpengine=1
endif

if has('mouse')
  set mouse=a
endif

set history=1000

" Allow more time to type mappings, fix <Esc>O delay in terminal Vim
set timeoutlen=1200
set ttimeoutlen=100

" Always yank and delete into the system clipboard, too
if has('unnamedplus')
  set clipboard+=unnamedplus
else
  set clipboard+=unnamed
endif

set hidden

set backspace=indent,eol,start

set autoindent

" Keep the cursor in the same column when moving up and down
set nostartofline

" Don't insert two-space sentence punctuation when joining lines
set nojoinspaces

set shiftround
set smarttab

" Improve auto-formatting of commented lines and overlong lines
set formatoptions+=rl
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

" Never interpret numbers as octal with CTRL-A/CTRL-X
set nrformats-=octal

set incsearch

" Don't open folds when moving with } {
set foldopen-=block

" Always display status line of the bottom-most window
set laststatus=2

set number

" Have your matching opening brackets wink at you, beep if unbalanced
set showmatch

" Display as much as possible of a last line that doesn't fit in the window
set display+=lastline

set wildmenu
set wildmode=longest,list,full

set listchars=tab:▸\ ,eol:¬,trail:·

" Wrap screen lines at word boundaries (whitespace)
set linebreak

" TODO Work in progress
" TODO %c do not display if == %v
" TODO default statusline statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" TODO check 'fileencoding' and 'encoding' option
set statusline=%f
set statusline+=\ \|\ %{&encoding}\ \|\ %{&fileformat}\ %{&filetype\ is\ ''?'':'\|\ '.&filetype.'\ '}
set statusline+=%h              "help file flag
set statusline+=%w              "preview window flag
set statusline+=%m              "modified flag
set statusline+=%r              "read only flag
set statusline+=%=              "left/right separator
set statusline+=col\ %v/%c\ ln\ %l\ of\ %L

" Display incomplete commands in the status line
set showcmd

" Report changes that affect more than one line
set report=1

" Don't show the intro screen at startup
set shortmess+=I

" Autocommands

augroup vimrc
  autocmd!

  " Start at last known cursor position in file
  autocmd BufReadPost * silent! normal! g`"

  " Make new .txt files have file type "text"
  autocmd BufNewFile *.txt setfiletype text

  " I don't like the 'conceal' feature
  if has('conceal')
    autocmd FileType * setlocal conceallevel=0
  endif

  " Use 'colorcolumn' to create a gutter
  if exists('&colorcolumn') && has('gui_running')
    autocmd FileType * if &textwidth != 0
                   \ |   let &colorcolumn = join(range(&textwidth + 1, 500), ',')
                   \ | endif
  endif
augroup END

" Mappings

" Quick window size manipulation
nnoremap <C-Up> <C-W>+
nnoremap <C-Down> <C-W>-
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>>

nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

inoremap <C-U> <C-G>u<C-U>

" Formatting shortcut
nnoremap <silent> Q gwip

" Split line at cursor position, the inverse of J and gJ
nnoremap <C-J> i<CR><Esc>k$
nnoremap g<C-J> i<CR><C-O>d0<Esc>k$

" Easy buffer switching
nnoremap <Leader>b :<C-U>ls<CR>:b<Space>

" Search for Visual selection, from "Practical Vim"
function! s:VSetSearch(cmdtype) abort
  let l:reg_save = @s
  normal! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype . '\'), '\n', '\\n', 'g')
  let @s = l:reg_save
endfunction

xnoremap * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
xnoremap g* *
xnoremap g# #

" Easy use of filtered command-line history
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Enable undoing a( a) ab in Visual mode with gv
xnoremap a( <Esc>gva(
xnoremap a) <Esc>gva)
xnoremap ab <Esc>gvab

" Fix the & command as recommended in "Practical Vim"
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Source current file
nnoremap <Leader>so :<C-U>source %<CR>

" Remove all trailing whitespace
nnoremap <Leader>sd :%s/\s\+$<CR>

" Change directory to where current file is
nnoremap <Leader>d :lcd %:p:h<CR>

" Generate tags with exuberant ctags
nnoremap <Leader>ct :!ctags -R<CR>

" Write file as super user
cnoreabbrev w!! w !sudo tee % >/dev/null

" Expand dirname for current file
cnoreabbrev <expr> %% expand('%:h')

" Insert current date
inoreabbrev 2015- <C-R>=strftime('%Y-%m-%d')<CR>

" Insert random signed int64
nnoremap <Leader>rl "=magnum#random#NextInt(magnum#Int(2).Pow(64)).Sub(magnum#Int(2).Pow(63)).String().'L'<CR>p

" Insert some "Lorem ipsum" text
inoreabbrev Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.
  \ Fusce vel orci at risus convallis bibendum eget vitae turpis. Integer
  \ sagittis risus quis lacus volutpat congue. Aenean porttitor facilisis
  \ risus, a varius purus vestibulum non. In porttitor molestie diam, nec
  \ placerat neque malesuada non. Aenean auctor, mi in suscipit bibendum, quam
  \ risus tincidunt enim, id pretium leo risus ac lectus. Ut eget nisl nunc.
  \ Vivamus vestibulum semper aliquam. Mauris rutrum convallis malesuada.

" Open help in a separate tab with <F1>
nnoremap <F1> :<C-U>tab help<CR>

" Edit $MYVIMRC in a separate tab
nnoremap <Leader>ve :<C-U>tabedit $MYVIMRC<CR>

" Plugin settings

" operator-replace plugin
map gr <Plug>(operator-replace)

" Tagbar plugin
nnoremap <F3> :<C-U>TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1

" Gundo plugin
nnoremap <F5> :<C-U>GundoToggle<CR>

" cottidie.vim plugin
let g:cottidie_no_default_tips = 0
let g:cottidie_tips_files = ['~/mytips.txt'] ", 'http://glts.github.io/vim-cottidie/tips']
