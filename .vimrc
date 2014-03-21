" My vimrc.
" Author: glts <676c7473@gmail.com>

" Init {{{1
" Sine qua non setting
set nocompatible

" Source Vim plugins before pathogen modifies the runtime path
runtime ftplugin/man.vim

" Pathogen is our plugin manager
execute pathogen#infect()

" Maktaba playground below
let $MAKTABA_HOME = fnamemodify('~/.vim/maktaba', ':p:h')
source $MAKTABA_HOME/maktaba/bootstrap.vim
function! LocalLibInstaller(library) abort
  " Fake an installer that knows how to map a library name to a location
  let l:fakerepo = {
      \ 'fictional.vim': maktaba#path#Join([$MAKTABA_HOME, 'i_dont_exist']),
      \ 'bases.vim': maktaba#path#Join([$MAKTABA_HOME, 'bases']),
      \ 'magnum.vim': maktaba#path#Join([$MAKTABA_HOME, 'magnum']),
      \ }
  if has_key(l:fakerepo, a:library) && isdirectory(l:fakerepo[a:library])
    return maktaba#plugin#GetOrInstall(l:fakerepo[a:library])
  endif
  throw maktaba#error#NotFound(a:library)
endfunction
call maktaba#library#AddInstaller('locallibs', 'LocalLibInstaller')

call maktaba#plugin#GetOrInstall('~/.vim/maktaba/glaive')
call maktaba#plugin#GetOrInstall('~/.vim/maktaba/radical').Flag('plugin[mappings]', 1)

" Settings {{{1
" Behaviour {{{2
set directory=~/tmp,.   " directory for swap files
set nobackup            " do not keep backup files
set writebackup         " keep a temporary backup while writing a file

if exists('+undofile')
  set undofile          " remember undo histories inside 'undodir'
endif
if exists('+undodir')
  set undodir=~/tmp/vim/undo
  if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
  endif
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

set modeline            " always look for 2 modelines
set modelines=2

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
set fillchars=vert:│    " nicer separator for vertical splits

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

" Switch syntax and search highlighting on whenever colour is available
if &t_Co > 2 || has("gui_running")
  syntax enable
  set hlsearch
endif

" Autocommands {{{1
" Helper function, see ":helpg Eatchar"
function! EatTrigger()
  let c = nr2char(getchar(0))
  return c =~# '\s\|\r' ? '' : c
endfunction

if has("autocmd")

  filetype plugin indent on

  augroup ft_settings
    au!
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
    autocmd FileType ruby,vim,r setlocal ts=8 sw=2 sts=2 et
    autocmd FileType haskell setlocal ts=8 sw=4 sts=4 ai et
    autocmd FileType scheme setlocal ts=8 sw=2 sts=2 et
    autocmd FileType tex setlocal tw=78
  augroup END

  augroup ft_vimhelp
    au!
    if exists("&colorcolumn")
      autocmd FileType help setlocal colorcolumn=
    endif
  augroup END

  augroup ft_text
    au!
    " TODO if it's a Vim help file or markdown etc. don't apply this
    autocmd BufNewFile *.txt setfiletype text
    autocmd FileType text setlocal textwidth=72 ts=8 sw=4 sts=4 et ai
          \ formatoptions+=n comments=n:>,fb:-,fb:*
  augroup END

  augroup filetype_liquid
    au!
    autocmd FileType markdown if expand('%:p:t') =~# '\d\d\d\d-\d\d-\d\d-.*\.markdown' | set ft=liquid | endif
  augroup END

  augroup filetype_vim
    au!
    autocmd FileType vim setlocal nowrap foldmethod=marker
    autocmd FileType vim inoreab <buffer> augroup augroup<C-G>u<CR>au!<CR>augroup END<Up><Up><End>
    autocmd FileType vim inoreab <buffer> func func<C-G>ution! s:Function()<CR>endfunction<Up><End><Left><C-R>=EatTrigger()<CR>
  augroup END

  augroup filetype_vspec
    au!
    autocmd BufRead *.t if search('^\s*describe\s\+\([''"]\).*\1\s*$', 'cnw') | set ft=vim | endif
  augroup END

  augroup filetype_shell
    au!
    autocmd FileType sh inoreab <buffer> if if [ ]; then<CR>fi<Up><Right><Right>
    autocmd FileType sh inoreab <buffer> while while; do<CR>done<Up><Right>
  augroup END

  augroup filetype_go
    au!
    autocmd FileType go silent! compiler go
  augroup END

  augroup filetype_perl
    au!
    autocmd FileType perl inoreab <buffer> sub sub<C-G>u {<CR>}<Up><End><Left><Left>
    autocmd FileType perl inoreab <buffer> foreach foreach<C-G>u my {<CR>}<Up><End><Left><Left>
  augroup END

  augroup filetype_php
    au!
    autocmd FileType php inoreab <buffer> try{ try {<CR>} catch (Exception $ex) {<CR>}<Up><Up><End>
  augroup END

  augroup filetype_python
    au!
    autocmd FileType python setlocal foldmethod=indent foldlevel=100
    autocmd FileType python inoreab <buffer> def def<C-G>u(self):<Left><Left><Left><Left><Left><Left><Left>
  augroup END

  augroup filetype_ruby
    au!
    autocmd FileType ruby inoreab <buffer> class class<C-G>u<CR>end<Up><End>
    autocmd FileType ruby inoreab <buffer> module module<C-G>u<CR>end<Up><End>
    autocmd FileType ruby inoreab <buffer> def def<C-G>u()<CR>end<Up>
  augroup END

  augroup filetype_c
    au!
    autocmd FileType c inoreab <buffer> /* /**/<Left><Left>
  augroup END

  augroup filetype_javascript
    au!
    autocmd FileType javascript inoreab <buffer> /* /**/<Left><Left>
    autocmd BufNewFile,BufRead *.json setfiletype javascript
  augroup END

  augroup filetype_java
    au!
    autocmd FileType java inoreab <buffer> main( public static void main(String[] args) {<CR>}<Up><End>
    autocmd FileType java inoreab <buffer> class public class {<CR>}<Up><End><Left><Left>
    autocmd FileType java inoreab <buffer> /* /*<CR>/<Up>
    autocmd FileType java inoreab <buffer> /** /**<CR>/<Up>
  augroup END

  augroup other
    au!

    " Start at last known cursor position in file (validity checks removed)
    autocmd BufReadPost * silent! normal! g`"

    " I don't like the 'conceal' feature
    if has("conceal")
      autocmd FileType * setlocal conceallevel=0
    endif

    " Highlight end of line spaces in normal mode
    " highlight default link EndOfLineSpace ErrorMsg
    " match EndOfLineSpace /\s\+$/
    " autocmd InsertEnter * hi link EndOfLineSpace Normal
    " autocmd InsertLeave * hi link EndOfLineSpace ErrorMsg

    " Make colour column into colour gutter
    if exists('&colorcolumn') && has('gui_running')
      autocmd FileType * if &tw != 0 | let &cc=join(range(&tw+1,199),',') | endif
    endif

    autocmd BufNewFile,BufRead *.ijs setfiletype j

    " TODO This works only if you have ch=2!
    " autocmd VimEnter * CottidieTip!
  augroup END

endif

" Mappings and abbreviations {{{1
let mapleader = "\\"

inoremap <S-CR> <Esc>o
inoremap <S-M-CR> <Esc>O

nnoremap <C-Up> <C-W>+
nnoremap <C-Down> <C-W>-
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>>

" Simple a/i text objects
nnoremap di<Bar> T<Bar>d,
nnoremap da<Bar> F<Bar>d,
nnoremap ci<Bar> T<Bar>c,
nnoremap ca<Bar> F<Bar>c,
nnoremap yi<Bar> T<Bar>y,
nnoremap ya<Bar> F<Bar>y,
nnoremap vi<Bar> T<Bar>v,
nnoremap va<Bar> F<Bar>v,

" Formatting shortcuts, for widths 'textwidth' and 72 columns
nnoremap <silent> Q gwip
nnoremap <silent> <Leader>Q :<C-U>let _tw=&l:tw<Bar>setl tw=72<Bar>exe 'norm! gwip'<Bar>let &l:tw=_tw<Bar>unlet _tw<CR>

" Easy buffer switching
nnoremap <Leader>b :<C-U>ls<CR>:b<Space>

" Yank Visual selection as a single line to system clipboard
vnoremap <silent> <Leader>y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+", "", "")'), " ")<CR>

" Search for Visual selection from "Practical Vim"
function! s:VSetSearch(cmdtype)
  let reg_save = @s
  normal! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'),'\n','\\n','g')
  let @s = reg_save
endfunction
xnoremap * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
xnoremap g* *
xnoremap g# #

" Search but don't move
nnoremap <silent> <Leader>* :keepjumps normal! mxHmy`x*'yzt`x<CR>
nnoremap <silent> <Leader># :keepjumps normal! mxHmy`x#'yzt`x<CR>

" Show stack of syntax items at cursor position
nnoremap <Leader>sy :echo map(synstack(line("."), col(".")), 'synIDattr(v:val, "name")')<CR>

" Emulate Readline's CTRL-K (kill-line)
inoremap <C-K> <C-\><C-O>D

" Insert mode CTRL-W counterpart for WORDs
inoremap <C-Q> <C-\><C-O>dB

" Easy use of filtered command-line history
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Enable undoing a( a) ab in Visual mode with gv
xnoremap a( <Esc>gva(
xnoremap a) <Esc>gva)
xnoremap ab <Esc>gvab

" Folding
nnoremap <Space> za

" 'Fix' the & command as recommended in "Practical Vim"
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Use aesthetic middle of screen for "zz"
if has('float')
  nnoremap <expr> zz 'zz'.float2nr(winheight(0)*0.1).'<C-E>'
endif

" Indent current line exactly like previous line
inoremap <C-S> <Esc>:call setline(".",substitute(getline(line(".")),'^\s*',matchstr(getline(line(".")-1),'^\s*'),''))<CR>I

inoreab @@ 676c7473@gmail.com
inoreab <@@ glts <Lt>676c7473@gmail.com>

nnoremap <silent> <Leader>l :set list!<CR>
nnoremap <silent> <BS> :nohlsearch<CR>

" Highlight overlong lines, ie. characters at col 79+
" TODO use 'tw' and only when not empty, put /../ in history
nnoremap <Leader>ol :highlight link OverLength ErrorMsg <Bar> match OverLength /\%79v.\+/<CR>
nnoremap <Leader>oL :match none<CR>

nnoremap <Leader>so :source %<CR>

" Search for current search in the Vim C source code
nnoremap <Leader>vg :<C-U>vim /<C-R>// src/*.[ch]<CR>

" Remove all trailing whitespace
nnoremap <Leader>sd :%s/\s\+$<CR>

" Toggle spell-checking
nnoremap <Leader>sp :set spell!<CR>

" Toggle 'virtualedit' mode
nnoremap <Leader>vv :set ve=<C-R>=&ve=='' ? 'all' : ''<CR><CR>

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
inoreab 2014- <C-R>=strftime("%Y-%m-%d")<CR>

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
noremap <F1> :<C-U>tab help<CR>

" Edit $MYVIMRC
nnoremap <Leader>ve :tabedit $MYVIMRC<CR>

" Insert quick tab ruler for over-the-top perfectionist alignment
command! Ruler put! =' '.repeat('   .   \|', 10)

" Toggle relative line numbers
if exists('&relativenumber')
  function! s:ToggleRelativeNumber()
    if &relativenumber
      set norelativenumber
      let &number = exists("b:togglernu_number") ? b:togglernu_number : 1
    else
      let b:togglernu_number = &number
      set relativenumber
    endif
    redraw!  " these two lines required for omap
    return ''
  endfunction
  nnoremap <silent> <Leader>m :call <SID>ToggleRelativeNumber()<CR>
  vnoremap <silent> m :<C-U>call <SID>ToggleRelativeNumber()<CR>gv
  onoremap <expr> m <SID>ToggleRelativeNumber()
endif

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

" Plugins and scripts {{{1
" NERDTree is on hiatus
" noremap <F2> :<C-U>NERDTreeToggle<CR>
" let NERDTreeIgnore = ['^\.DS_Store$', '\.pyc$', '^\.svn$', '^\.git$', '\.o$',]
" let NERDTreeShowHidden = 1

" Use bash as default .sh filetype, see ":h ft-sh-syntax"
let g:is_bash = 1

" Indentation for multiline strings begins after the initial opening quote
let g:clojure_align_multiline_strings = 1

" Enable Perl POD highlighting and spell-checking
let perl_include_pod = 1

" Only one level of indent after open parentheses in Python
let g:pyindent_open_paren = '&shiftwidth'

noremap <F3> :<C-U>TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1

noremap <F5> :<C-U>GundoToggle<CR>

let g:cottidie_no_default_tips = 0
let g:cottidie_tips_files = ['~/mytips.txt'] ", 'http://glts.github.io/vim-cottidie/tips']

" Replace operator mapping for operator-replace
map gr <Plug>(operator-replace)

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" TODO make a "reverse" command that gets you out of diff mode; also: clean up!
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
