" My .vimrc settings, adapted from the example.
"
" Author: glts <676c7473@gmail.com>
" Modified: 2012-12-02

"
" Init
"

" Sine qua non setting
set nocompatible

" Pathogen is our plugin manager
call pathogen#infect()

"
" Various settings
"

" Behaviour

set directory=~/tmp,.   " directory for swap files
set nobackup            " do not keep backup files
set writebackup         " keep a temporary backup while writing a file

set hidden

set history=200         " keep 200 lines of command-line history

" more intuitive backspace behaviour
set backspace=indent,eol,start

set nostartofline       " keep cursor in same column when moving up and down
set nojoinspaces        " don't insert two-space sentence punctuation with J
set shiftround          " round to next virtual "tabstop" when indenting

set modeline            " always look for 2 modelines
set modelines=2

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

" TODO This raises an error E763 for some reason
set spelllang=en_gb,de_ch
set spellfile=~/.vim/spell/mine.utf-8.add

" Format options
"set formatoptions=...
"set formatlistpat=...

" Appearance

set ruler               " show cursor position, 'statusline' overrides this
set number              " show line numbers
set showmatch           " have your matching brackets wink at you
set showcmd             " display incomplete commands in status line
set scrolloff=2         " always keep two lines above/below cursor visible
set incsearch           " do incremental searching
set linebreak           " break screen lines at whitespace
set display=lastline    " fit as much as possible of a long line on screen
set shortmess+=I        " don't show intro screen at startup
set wildmenu            " show tab-completion candidates in status line
set wildmode=longest,list,full

set listchars=tab:▸\ ,eol:¬     " unprintable chars for 'list' mode
set fillchars=vert:│    " nicer separator for vertical splits

set laststatus=2        " always display statusline

" TODO highlight encoding if not utf-8
" TODO highlight file format if not unix
" TODO %c do not display if == %v
set statusline=%f               "tail of the filename
" TODO check 'fileencoding' and 'encoding' option
set statusline+=\ ▶\ %{&enc}    "file format
set statusline+=\ ▶\ %{&ff}     "file format
set statusline+=\ ▶\ %{&ft}     "filetype
set statusline+=\ %h            "help file flag
set statusline+=%m              "modified flag
set statusline+=%r              "read only flag
set statusline+=%=              "left/right separator
set statusline+=col\ %v         "virtual cursor column
set statusline+=(%c)            "cursor column
set statusline+=\ ln\ %l\ of\ %L   "cursor line/total lines
set statusline+=\ %P            "percent through file

" Switch syntax and search highlighting on whenever colour is available
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

"
" Autocommands
"

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
    autocmd FileType python,perl,php setlocal ts=8 sw=4 sts=4 et
    autocmd FileType sh,tcl setlocal ts=4 sts=4 sw=4 noet
    autocmd FileType xml,html,xhtml,htmldjango setlocal ts=2 sw=2 sts=2 noet
    autocmd FileType javascript setlocal ts=4 sw=4 sts=4 noet
    autocmd FileType css setlocal ts=4 sw=4 sts=4 noet
    autocmd FileType rst setlocal tw=78 ts=3 sw=3 sts=3 et tw=72
    autocmd FileType markdown setlocal ts=8 sw=4 sts=4 et tw=72
    autocmd FileType ruby,vim setlocal ts=8 sw=2 sts=2 et
    autocmd FileType haskell setlocal ts=8 sw=4 sts=4 ai et
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
    autocmd FileType text setlocal textwidth=72 formatoptions+=n autoindent
  augroup END

  augroup filetype_vim
    au!
    autocmd FileType vim inoreab <buffer> augroup augroup<C-G>u<CR>au!<CR>augroup END<Up><Up><End>
    autocmd FileType vim inoreab <buffer> func func<C-G>ution! s:Function()<CR>endfunction<Up><End><Left><C-R>=EatTrigger()<CR>
  augroup END

  augroup filetype_shell
    au!
    autocmd FileType sh inoreab <buffer> if if [ ]; then<CR>fi<Up><Right><Right>
    autocmd FileType sh inoreab <buffer> while while; do<CR>done<Up><Right>
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
    highlight default link EndOfLineSpace ErrorMsg
    match EndOfLineSpace /\s\+$/

    autocmd InsertEnter * hi link EndOfLineSpace Normal
    autocmd InsertLeave * hi link EndOfLineSpace ErrorMsg

    " TODO This works only if you have ch=2!
    " autocmd VimEnter * CottidieTip!
  augroup END

else
  set autoindent
endif

"
" Mappings and abbreviations
"

let mapleader = "\\"

" Trying something revolutionary here; edit: or rather not
" noremap : ;
" noremap ; :

inoremap <S-CR> <Esc>o
inoremap <S-M-CR> <Esc>O

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
"Think about sth like this:
nnoremap <C-Up> <C-W>+
nnoremap <C-Down> <C-W>-
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>>

" Simple a/i text objects
" TODO Perhaps create real text objects for these?
nnoremap di<Bar> T<Bar>d,
nnoremap da<Bar> F<Bar>d,
nnoremap ci<Bar> T<Bar>c,
nnoremap ca<Bar> F<Bar>c,
nnoremap yi<Bar> T<Bar>y,
nnoremap ya<Bar> F<Bar>y,
nnoremap vi<Bar> T<Bar>v,
nnoremap va<Bar> F<Bar>v,
nnoremap di/ T/d,
nnoremap da/ F/d,
nnoremap ci/ T/c,
nnoremap ca/ F/c,
nnoremap yi/ T/y,
nnoremap ya/ F/y,
nnoremap vi/ T/v,
nnoremap va/ F/v,

" Screen line movement as default
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Formatting shortcut
nnoremap Q gwip

" Yank Visual selection as a single line to system clipboard
vnoremap <silent> <Leader>y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+", "", "")'), " ")<CR>

" Search for Visual selection from "Practical Vim"
function! s:VSetSearch()
  let reg_save = @s
  normal! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'),'\n','\\n','g')
  let @s = reg_save
endfunction
xnoremap * :<C-U>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-U>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

" Show stack of syntax items at cursor position
nnoremap <Leader>sy :echo map(synstack(line("."), col(".")), 'synIDattr(v:val, "name")')<CR>

" emulate command-line CTRL-K
" no this doesn't work because of Vims strange <C-O> behaviour (wrong col)
inoremap <C-K> <C-O>:exec ':s/\%' . col(".") . 'c.*//'<CR><End><C-O>:nohls<CR>
" if (len(getline(".")) != col(".")) | normal! Da | endif
"inoremap <C-K> <C-O>:if (len(getline(".")) != col(".")) | normal! Da | endif

" Counterpart to the existing <C-E>
cnoremap <C-A> <Home>

" Easy use of filtered command-line history
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Folding
nnoremap <Space> za

" 'Fix' the & command as recommended in "Practical Vim"
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Use aesthetic middle of screen for "zz"
if has('float')
  nnoremap <expr> zz 'zz'.float2nr(winheight(0)*0.1).'<C-E>'
endif

inoreab @@ 676c7473@gmail.com
inoreab <@@ glts <Lt>676c7473@gmail.com>

nnoremap <silent> <Leader>l :set list!<CR>
nnoremap <silent> <BS> :nohls<CR>

" Highlight overlong lines, ie. characters at col 79+
" TODO use 'tw' and only when not empty, put /../ in history
nnoremap <Leader>ol :highlight link OverLength ErrorMsg <Bar> match OverLength /\%79v.\+/<CR>
nnoremap <Leader>oL :match none<CR>

nnoremap <Leader>so :source %<CR>

" Remove all trailing whitespace
nnoremap <Leader>sd :%s/\s\+$<CR>

" Toggle spell-checking
nnoremap <Leader>sp :set spell!<CR>

" Toggle 'virtualedit' mode
nnoremap <Leader>vv :set ve=<C-R>=&ve=='' ? 'all' : ''<CR><CR>

" change directory to where current file is
nnoremap <Leader>d :lcd %:p:h<CR>

" prettify XML fragments, remaps to surround plugin map
nmap <Leader>x ggVGStroot>:%!xmllint --format -<CR>

" Generate tags with exuberant ctags
nnoremap <Leader>ct :!ctags -R<CR>

" Write file as super user
cnoreabbrev w!! w !sudo tee % >/dev/null

" Expand dirname for current file
cnoreabbrev <expr> %% expand('%:h')

" Insert current date
inoreab 2012- <C-R>=strftime("%Y-%m-%d")<CR>

" Insert some "Lorem ipsum" text
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

" open help in a separate tab with <F1>
noremap <F1> :<C-U>tab help<CR>

" Edit $MYVIMRC
nnoremap <Leader>ve :tabedit $MYVIMRC<CR>

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
    redraw! " these two lines required for omap
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

"
" Plugins and scripts
"

" NERDTree is on hiatus
" noremap <F2> :<C-U>NERDTreeToggle<CR>
" let NERDTreeIgnore = ['^\.DS_Store$', '\.pyc$', '^\.svn$', '^\.git$', '\.o$',]
" let NERDTreeShowHidden = 1

" Enable Perl POD highlighting and spell-checking
let perl_include_pod = 1

noremap <F3> :<C-U>TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1

noremap <F5> :<C-U>GundoToggle<CR>

" Use :Man or S-k to display the man page for the word under the cursor
runtime! ftplugin/man.vim

nnoremap <Leader>w :SpaceBox<CR>
vnoremap <Leader>w <Esc>:<C-U>SpaceBox<CR>
nnoremap <Leader>e :SpaceBoxInline<CR>

let g:cottidie_tips_files = ['~/mytips.txt']
" let g:cottidie_no_default_tips = 1

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" TODO make a "reverse" command that gets you out of diff mode; also: clean up!
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
