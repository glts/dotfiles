" Source Vim plugins before pathogen.vim modifies the runtime path
runtime ftplugin/man.vim
runtime macros/matchit.vim

" Pathogen is our plugin manager
execute pathogen#infect()

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

" Settings {{{1
" Behaviour {{{2
" Temporary swap and undo files and settings
set directory=~/tmp,.
set nobackup
set writebackup

if exists('+undodir')
  set undodir=~/tmp/vim/undo
  if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), 'p')
  endif
endif
if exists('+undofile')
  set undofile
endif

" Search all directories inside the current directory
set path+=**

" The new regexp engine isn't ready yet
if exists('&regexpengine')
  set regexpengine=1
endif

" File patterns to ignore
set wildignore+=*.class

set hidden

set history=1000         " keep 1000 lines of command-line history

" Get rid of the delay after <Esc>O in terminal Vim
set timeout
set timeoutlen=1200
set ttimeoutlen=100

" More intuitive backspace behaviour
set backspace=indent,eol,start

" Toggle 'paste'
set pastetoggle=<F6>

set nostartofline       " keep cursor in same column when moving up and down
set nojoinspaces        " don't insert two-space sentence punctuation with J
set shiftround          " round to next virtual "tabstop" when indenting
set smarttab

set report=1            " report changes that affect more than one line

set encoding=utf-8      " default encoding is UTF-8 always
set fileencoding=       " use the same encoding for a file as for the buffer

" File encodings to try; keep "ucs-bom" for Windows compatibility
set fileencodings=ucs-bom,utf-8,default,latin1

" Also detect mac-style EOL
set fileformats=unix,dos,mac

" Enable mouse when available
if has('mouse')
  set mouse=a
endif

" Always yank and delete into system clipboard too
if has('unnamedplus')
  set clipboard+=unnamedplus
else
  set clipboard+=unnamed
endif

" Don't open folds when moving with } {
set foldopen-=block

" Spell-checking setup
set spelllang=en_gb,de_ch
set spellfile=~/.vim/spell/mine.utf-8.add

" Insert comment leader on <Enter>, no line breaking on overlong lines
set formatoptions+=rl

" Strip comment leaders when joining lines
silent! set formatoptions+=j
" TODO set formatlistpat=...

" Do not respect octal numbers with CTRL-A/CTRL-X
set nrformats-=octal

" Appearance {{{2
set ruler               " show cursor position, 'statusline' overrides this
set number              " show line numbers
set showmatch           " have your matching brackets wink at you
set showcmd             " display incomplete commands in status line
set incsearch           " do incremental searching
set linebreak           " break screen lines at whitespace
set display=lastline    " fit as much as possible of a long line on screen
set shortmess+=I        " don't show intro screen at startup
set wildmenu            " show tab-completion candidates in status line
set wildmode=longest,list,full

" unprintable chars for 'list' mode
set listchars=tab:▸\ ,eol:¬,trail:·

set laststatus=2        " always display statusline

" TODO highlight encoding if not utf-8
" TODO highlight file format if not unix
" TODO %c do not display if == %v
set statusline=%f               "tail of the filename
" TODO check 'fileencoding' and 'encoding' option
set statusline+=\ \|\ %{&enc}   "file format
set statusline+=\ \|\ %{&ff}    "file format
set statusline+=\ \|\ %{&ft}    "filetype
set statusline+=\ %h            "help file flag
set statusline+=%w              "preview window flag
set statusline+=%m              "modified flag
set statusline+=%r              "read only flag
set statusline+=%=              "left/right separator
set statusline+=col\ %v         "virtual cursor column
set statusline+=(%c)            "cursor column
set statusline+=\ ln\ %l\ of\ %L   "cursor line/total lines
set statusline+=\ %P            "percent through file

" set t_Co=256

" File types {{{1
" Enable Vim runtime files (filetype detection, ftplugin, indent, syntax)
filetype plugin indent on
syntax enable

" Autocommands in the vimrc autocommand group
augroup vimrc
  autocmd!

  " Start at last known cursor position in file
  autocmd BufReadPost * silent! normal! g`"

  " Filetype autocommands
  " TODO move this outside?
  " Rule of thumb: with 'et' ts = 8 and sw = sts, with 'noet' ts = sts = sw
  autocmd FileType cpp,c,java setlocal ts=8 sw=4 sts=4 et
  autocmd FileType python,perl,php,tcl setlocal ts=8 sw=4 sts=4 et
  autocmd FileType prolog setlocal ts=8 sw=4 sts=4 et
  autocmd FileType sh,go setlocal ts=4 sts=4 sw=4 noet
  autocmd FileType xml,html,xhtml,htmldjango setlocal ts=2 sw=2 sts=2 noet
  autocmd FileType javascript setlocal ts=4 sw=4 sts=4 noet
  autocmd FileType css setlocal ts=4 sw=4 sts=4 noet
  autocmd FileType rst setlocal tw=78 ts=3 sw=3 sts=3 et tw=72
  autocmd FileType markdown setlocal ts=8 sw=4 sts=4 et tw=72
  autocmd FileType ruby,r setlocal ts=8 sw=2 sts=2 et
  autocmd FileType haskell setlocal ts=8 sw=4 sts=4 ai et
  autocmd FileType scheme setlocal ts=8 sw=2 sts=2 et
  autocmd FileType tex setlocal tw=78

  " Filetype for plain text
  " TODO if it's a Vim help file or markdown etc. don't apply this
  autocmd BufNewFile *.txt setfiletype text
  autocmd FileType text setlocal textwidth=72 ts=8 sw=4 sts=4 et ai
        \ formatoptions+=n comments=n:>,fb:-,fb:*

  " Filetype for liquid files
  autocmd FileType markdown if expand('%:p:t') =~# '\d\d\d\d-\d\d-\d\d-.*\.markdown' | set ft=liquid | endif

  " Filetype settings for Python
  autocmd FileType python setlocal foldmethod=indent foldlevel=100
  autocmd FileType python inoreab <buffer> def def<C-G>u(self):<Left><Left><Left><Left><Left><Left><Left>

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

" Mappings {{{1
" Quick window size manipulation
nnoremap <C-Up> <C-W>+
nnoremap <C-Down> <C-W>-
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>>

" Formatting shortcut
nnoremap <silent> Q gwip

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

" Indent current line exactly like previous line
inoremap <C-S> <Esc>:call setline(".",substitute(getline(line(".")),'^\s*',matchstr(getline(line(".")-1),'^\s*'),''))<CR>I

" Source current file
nnoremap <Leader>so :<C-U>source %<CR>

" Remove all trailing whitespace
nnoremap <Leader>sd :%s/\s\+$<CR>

" Change directory to where current file is
nnoremap <Leader>d :lcd %:p:h<CR>

" Prettify XML fragments, remaps to surround plugin map
nmap <Leader>x ggVGStroot>:%!xmllint --format -<CR>

" Generate tags with exuberant ctags
nnoremap <Leader>ct :!ctags -R<CR>

" Write file as super user
cnoreab w!! w !sudo tee % >/dev/null

" Expand dirname for current file
cnoreab <expr> %% expand('%:h')

" Insert current date
inoreab 2015- <C-R>=strftime('%Y-%m-%d')<CR>

" Insert random signed int64
nnoremap <Leader>rl "=magnum#random#NextInt(magnum#Int(2).Pow(64)).Sub(magnum#Int(2).Pow(63)).String().'L'<CR>p

" Insert some "Lorem ipsum" text {{{2
inoreab Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.
  \ Fusce vel orci at risus convallis bibendum eget vitae turpis.
  \ Integer sagittis risus quis lacus volutpat congue. Aenean porttitor
  \ facilisis risus, a varius purus vestibulum non. In porttitor molestie
  \ diam, nec placerat neque malesuada non. Aenean auctor, mi in suscipit
  \ bibendum, quam risus tincidunt enim, id pretium leo risus ac lectus. Ut
  \ eget nisl nunc. Vivamus vestibulum semper aliquam. Mauris rutrum
  \ convallis malesuada. Duis congue ligula quis orci tincidunt dignissim.
  \ Ut pellentesque risus ut lectus porta porttitor. Donec dictum lectus sit
  \ amet felis aliquam dictum. Integer tempor tincidunt interdum.
" }}}2

" Open help in a separate tab with <F1>
nnoremap <F1> :<C-U>tab help<CR>

" Edit $MYVIMRC in a separate tab
nnoremap <Leader>ve :tabedit $MYVIMRC<CR>

" Insert quick tab ruler for over-the-top perfectionist alignment
command! Ruler put! =' ' . repeat('   .   \|', 10)

" TODO work in progress
" Read template for the current filetype
" Templates are stored as ~/.vim/templates/[<variant>.]<filetype>.tpl,
" eg. "~/.vim/templates/strict.html.tpl"
function! s:ReadTemplate(...)
  if exists("a:1") " TODO not exists
    exec 'read ~/.vim/templates/' . a:1 . '.' . &filetype . '.tpl' | 0d_
  else
    exec 'read ~/.vim/templates/'. &filetype . '.tpl' | 0d_
  endif
endfunction
command! -nargs=? Template call s:ReadTemplate(<f-args>)

" Plugins {{{1
" Python indent file: Only one level of indent after open parentheses
let g:pyindent_open_paren = '&shiftwidth'

" Clojure indent file: Align multi-line strings after initial opening quote
let g:clojure_align_multiline_strings = 1

" J indent file: Indent multi-line definitions in J
let g:j_indent_definitions = 1

" Perl syntax file: Enable Perl POD highlighting and spell-checking
let g:perl_include_pod = 1

" Shell syntax file: Use bash as default filetype, see ":h ft-sh-syntax"
let g:is_bash = 1

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
