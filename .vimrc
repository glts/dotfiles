" My vim configuration.
" Author: glts <676c7473@gmail.com>

" Runtime path and file types setup

" Let pathogen.vim be our plugin manager.
execute pathogen#infect()

" Source optional bundled Vim scripts.
runtime ftplugin/man.vim
runtime macros/matchit.vim

" Maktaba playground below.
source $HOME/.vim/maktaba/maktaba/bootstrap.vim
let $MAKTABA_HOME = maktaba#path#Join([$HOME, '.vim', 'maktaba'])
call maktaba#plugin#GetOrInstall(maktaba#path#Join([$MAKTABA_HOME, 'glaive']))
call maktaba#plugin#GetOrInstall(maktaba#path#Join([$MAKTABA_HOME, 'magnum']))
call maktaba#plugin#GetOrInstall(maktaba#path#Join([$MAKTABA_HOME, 'radical'])).Flag('plugin[mappings]', 1)

filetype plugin indent on
syntax enable

" Settings

set encoding=utf-8

set directory^=~/.local/share/vim/swap//

if has('persistent_undo')
  set undodir^=~/.local/share/vim/undo//
  set undofile
endif

set autoread

if has('mouse')
  set mouse=a
endif

set history=1000

" Allow more time to type mappings, fix <Esc>O delay in terminal Vim.
set timeoutlen=1200
set ttimeoutlen=100

" Always yank and delete into the system clipboard, too.
if has('unnamedplus')
  set clipboard^=unnamedplus
else
  set clipboard^=unnamed
endif

setglobal tags-=./tags tags^=./tags;

" On by default, but Debian-based platforms may switch it off.
set modeline

set hidden

set backspace=indent,eol,start

set autoindent

" Keep the cursor in the same column when moving up and down.
set nostartofline

" Don't insert two-space sentence punctuation when joining lines.
set nojoinspaces

set shiftround
set smarttab

" Improve auto-formatting of commented lines and overlong lines.
set formatoptions+=rl
if v:version > 703 || v:version is 703 && has('patch541')
  set formatoptions+=j
endif

set incsearch

" Always display status line of the bottom-most window.
set laststatus=2

set number

" Have your matching opening brackets wink at you, beep if unbalanced.
set showmatch

" Display as much as possible of a last line that doesn't fit in the window.
set display+=lastline

set wildmenu
set wildmode=longest,list,full

set listchars=tab:▸\ 
if v:version > 704 || v:version is 704 && has('patch712')
  set listchars+=space:·
else
  set listchars+=trail:·,eol:¬
endif

" Wrap screen lines at word boundaries (whitespace).
set linebreak

set statusline=%f\ %{'['.join(filter([&fileencoding,&fileformat],'!empty(v:val)'),',').']'}%y%h%w%r%m%{fugitive#statusline()}%=%l:%c%V\ %P

" Display incomplete commands in the status line.
set showcmd

" Report changes that affect more than one line.
set report=1

" Don't show the intro screen at startup.
set shortmess+=I

set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscopetag
nnoremap csa :cscope add cscope.out<CR>
nnoremap csfs :cscope find s <cword><CR>
nnoremap csfc :cscope find c <cword><CR>

" Autocommands

augroup vimrc
  autocmd!

  " Start at last known cursor position in file.
  autocmd BufReadPost * silent! normal! g`"

  " Make new .txt files have file type "text".
  autocmd BufNewFile *.txt setfiletype text

  " I don't like the 'conceal' feature.
  if has('conceal')
    autocmd FileType * setlocal conceallevel=0
  endif

  " Close the preview window after Insert-mode completion.
  if exists('##CompleteDone')
    autocmd CompleteDone * pclose
  endif

  " Use 'colorcolumn' to create a gutter.
  if exists('+colorcolumn') && has('gui_running')
    autocmd FileType * if &textwidth isnot 0
                   \ |   let &l:colorcolumn = join(map(range(1, 256), '"+" . v:val'), ',')
                   \ | endif
  endif
augroup END

" Mappings

nnoremap <F1> :<C-U>tab help<CR>

nnoremap <silent> <C-L> :<C-U>nohlsearch <Bar> diffupdate<CR><C-L>

" Easy use of filtered command-line history.
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Search for the current Visual selection.
function! s:GetVisualSelectionPattern(searchtype) abort
  let l:lines = getline(line("'<"), line("'>"))
  let l:startcol = col("'<") - 1
  let l:endcol = col("'>") - 1
  if l:endcol >= strlen(l:lines[-1])
    call add(l:lines, '')
  else
    let l:endcol += strlen(matchstr(l:lines[-1][l:endcol : ], '.')) - 1
  endif
  let l:lines[-1] = l:lines[-1][ : l:endcol]
  let l:lines[0] = l:lines[0][l:startcol : ]
  return '\V' . join(map(l:lines, 'escape(v:val, a:searchtype . "\\")'), '\n')
endfunction

xnoremap * <Esc>/<C-R><C-R>=<SID>GetVisualSelectionPattern('/')<CR><CR>
xnoremap # <Esc>?<C-R><C-R>=<SID>GetVisualSelectionPattern('?')<CR><CR>
xnoremap g* *
xnoremap g# #

inoremap <C-U> <C-G>u<C-U>

" Fix the & command as recommended in "Practical Vim".
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Enable undoing a( a) ab in Visual mode with gv.
xnoremap a( <Esc>gva(
xnoremap a) <Esc>gva)
xnoremap ab <Esc>gvab

" Quick window size manipulation.
nnoremap <C-Up> <C-W>+
nnoremap <C-Down> <C-W>-
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>>

" Formatting shortcut.
nnoremap <silent> Q gwip

" Expand dirname for current file.
cnoreabbrev <expr> %% expand('%:h')

" Easy buffer switching.
nnoremap <Leader>b :<C-U>ls<CR>:b

" Source current file.
nnoremap <Leader>so :<C-U>source %<CR>

" Remove all trailing whitespace.
nnoremap <Leader>sd :%s/\s\+$<CR>

" Change directory to where current file is.
nnoremap <Leader>d :lcd %:p:h<CR>

" Generate tags with exuberant ctags.
nnoremap <Leader>ct :!ctags -R<CR>

" Edit $MYVIMRC in a separate tab.
nnoremap <Leader>ve :<C-U>tabedit $MYVIMRC<CR>

" Insert current date.
inoreabbrev 2015- <C-R>=strftime('%Y-%m-%d')<CR>

" Insert random signed int64.
nnoremap <Leader>rl "=magnum#random#NextInt(magnum#Int(2).Pow(64)).Sub(magnum#Int(2).Pow(63)).String().'L'<CR>p

" Insert some "Lorem ipsum" text.
inoreabbrev Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.
  \ Fusce vel orci at risus convallis bibendum eget vitae turpis. Integer
  \ sagittis risus quis lacus volutpat congue. Aenean porttitor facilisis
  \ risus, a varius purus vestibulum non. In porttitor molestie diam, nec
  \ placerat neque malesuada non. Aenean auctor, mi in suscipit bibendum, quam
  \ risus tincidunt enim, id pretium leo risus ac lectus. Ut eget nisl nunc.
  \ Vivamus vestibulum semper aliquam. Mauris rutrum convallis malesuada.

" Plugin settings

let g:netrw_banner = 0

" operator-replace.
map gr <Plug>(operator-replace)

" Tagbar.
nnoremap <F3> :<C-U>TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1

" Gundo.
nnoremap <F5> :<C-U>GundoToggle<CR>

" cottidie.vim.
let g:cottidie_no_default_tips = 0
let g:cottidie_tips_files = ['~/mytips.txt'] ", 'http://glts.github.io/vim-cottidie/tips']
