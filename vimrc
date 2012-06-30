" My .vimrc settings, adapted from the example.
"
" Author: glts <676c7473@gmail.com>
" Modified: 2012-06-30

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

" Format options
" default is tcq but for some filetypes they are reset, eg. [vim] has "croql"
"set formatoptions=croql
"set formatlistpat=... " Using this I can have autoformat recognize lists
" TODO create a nice mapping to enter "text editing" mode: fo+=a, flp=\([*-]\|\d\+...\), etc.

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

set listchars=tab:▸\ ,eol:¬     " unprintable chars for 'list' mode

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

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
" TODO read up on this, this is from the example vimrc
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

"
" Autocommands
"

if has("autocmd")

  filetype plugin indent on

  augroup ft_settings
    au!
    " TODO I have never actually seen a file type text used by Vim -- fix this
    " Perhaps like so autocmd BufNewFile,BufRead *.txt setfiletype text
    " Rule of thumb: with 'et' ts = 8 and sw = sts, with 'noet' ts = sts = sw
    autocmd FileType text setlocal textwidth=78
    autocmd FileType cpp,c,java setlocal ts=8 sw=4 sts=4 expandtab
    autocmd FileType python,perl,ruby,php setlocal ts=8 sw=4 sts=4 expandtab
    autocmd FileType sh setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType xml,html,xhtml,htmldjango setlocal ts=2 sw=2 sts=2 noexpandtab
    autocmd FileType javascript setlocal ts=8 sw=2 sts=2 expandtab
    autocmd FileType css setlocal ts=8 sw=2 sts=2 expandtab
    autocmd FileType rst setlocal tw=78 ts=3 sw=3 sts=3 expandtab tw=72
    autocmd FileType markdown setlocal ts=8 sw=4 sts=4 expandtab tw=72
    autocmd FileType vim setlocal ts=8 sw=2 sts=2 expandtab
    autocmd FileType haskell setlocal ts=8 sw=4 sts=4 expandtab
  augroup END

  augroup filetype_vim
    au!
    autocmd FileType vim inoreabbrev <buffer> augroup augroup<CR>au!<CR>augroup END<Up><Up><End>
    autocmd FileType vim inoreabbrev <buffer> func function! s:Function()<CR>endfunction<Up><End><Left>
  augroup END

  augroup filetype_shell
    au!
    autocmd FileType sh inoreabbrev <buffer> if if [ ]; then<CR>fi<Up><Right><Right>
    autocmd FileType sh inoreabbrev <buffer> while while; do<CR>done<Up><Right>
  augroup END

  augroup filetype_php
    au!
    autocmd FileType php inoreabbrev <buffer> try{ try {<CR>} catch (Exception $ex) {<CR>}<Up><Up><End>
  augroup END

  augroup filetype_ruby
    au!
    autocmd FileType ruby inoreabbrev <buffer> class class<CR>end<Up><End>
    autocmd FileType ruby inoreabbrev <buffer> module module<CR>end<Up><End>
    autocmd FileType ruby inoreabbrev <buffer> def def()<CR>end<Up>
  augroup END

  augroup filetype_c_cpp
    au!
    autocmd FileType c,cpp inoreabbrev <buffer> while while () {<CR>}<Up><End><Left><Left><Left>
    autocmd FileType c,cpp inoreabbrev <buffer> main( int main(int argc, char *argv[])<CR>{<CR>return 0;<CR>}<Up><Up>
  augroup END

  augroup filetype_c
    au!
    autocmd FileType c inoreabbrev <buffer> printf( printf("");<Left><Left><Left>
  augroup END

  augroup filetype_java
    au!
    autocmd FileType java inoreabbrev <buffer> main( public static void main(String[] args) {<CR>}<Up><End>
    autocmd FileType java inoreabbrev <buffer> class public class {<CR>}<Up><End><Left><Left>
  augroup END

  augroup other
    au!

    " Start at last known cursor position in file (validity checks removed)
    autocmd BufReadPost * exec 'normal! g`"'

    " I don't like the 'conceal' feature
    if has("conceal")
      autocmd FileType * setlocal conceallevel=0
    endif
  augroup END

else
  set autoindent
endif

" TODO highlight overlong lines, ie. characters at col 79+
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%79v.\+/

"
" Mappings and abbreviations
"

let mapleader = "\\"

" TODO these break the command line window behaviour!
"nnoremap <CR> o<Esc>
"nnoremap <S-CR> O<Esc>
inoremap <S-CR> <Esc>o
inoremap <S-M-CR> <Esc>O

" TODO there might be a conflict with the NERDtree mappings here
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Formatting shortcut
nnoremap Q gwip

" Show stack of syntax items at cursor position
nnoremap <Leader>y :echo map(synstack(line("."), col(".")), 'synIDattr(v:val, "name")')<CR>

" emulate command-line CTRL-K
" no this doesn't work because of Vims strange <C-O> behaviour (wrong col)
inoremap <C-K> <C-O>:exec ':s/\%' . col(".") . 'c.*//'<CR><End><C-O>:nohls<CR>
" if (len(getline(".")) != col(".")) | normal! Da | endif
"inoremap <C-K> <C-O>:if (len(getline(".")) != col(".")) | normal! Da | endif

" Counterpart to the existing <C-E>
cnoremap <C-A> <Home>

" Use aesthetic middle of screen for "zz"
if has('float')
  nnoremap <silent> zz :exec "normal! zz" . float2nr(winheight(0)*0.1) . "\<Lt>C-E>"<CR>
endif
"nnoremap n nzz
"nnoremap N Nzz

inoreabbrev @@ 676c7473@gmail.com
inoreabbrev <@@ glts <Lt>676c7473@gmail.com>

nnoremap <silent> <Leader>l :set list!<CR>
nnoremap <silent> <Leader>n :nohls<CR>

nnoremap <Leader>s :source %<CR>

" change directory to where current file is
nnoremap <Leader>d :lcd %:p:h<CR>

" prettify XML fragments; NOTE depends on the surround plugin
nnoremap <Leader>x ggVGstroot>:%!xmllint --format -<CR>

" Generate tags with exuberant ctags
nnoremap <Leader>ct :!ctags -R<CR>

" Write file as super user
cnoreabbrev w!! w !sudo tee % >/dev/null

" Expand dirname for current file
cnoreabbrev <expr> %% expand('%:h')

" Put current date at the end of the line
inoreabbrev 2012- <Esc>:.r !date +\%F<CR>kgJA

" Insert some "Lorem ipsum" text
inoreabbrev Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.
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
  endfunction
  noremap <silent> <Leader>m :<C-U>call <SID>ToggleRelativeNumber()<CR>
endif

" TODO don't forget to integrate these sooner or later!
nnoremap <Leader>CC :set operatorfunc=<SID>CamelcaseOperator<CR>g@
vnoremap <Leader>CC :<C-U>call <SID>CamelcaseOperator(visualmode())<CR>
nnoremap <Leader>cc :set operatorfunc=<SID>UncamelcaseOperator<CR>g@
vnoremap <Leader>cc :<C-U>call <SID>UncamelcaseOperator(visualmode())<CR>

function! s:CamelcaseOperator(type)
  let saved_unnamed_reg = @"

  if a:type ==# 'v'
    exec "normal! `<v`>c"
  elseif a:type ==# 'char'
    exec "normal! `[v`]c"
  else
    return
  endif
  let @" = substitute(@", '\v_([a-z])', '\u\1', 'g')
  normal! p

  let @" = saved_unnamed_reg
endfunction

function! s:UncamelcaseOperator(type)
  let saved_unnamed_reg = @"

  if a:type ==# 'v'
    exec "normal! `<v`>c"
  elseif a:type ==# 'char'
    exec "normal! `[v`]c"
  else
    return
  endif
  let @" = substitute(@", '\v([a-z])([A-Z])', '\1_\l\2', 'g')
  let @" = substitute(@", '\v([A-Z])', '\l\1', 'g')
  normal! p

  let @" = saved_unnamed_reg
endfunction

"
" Plugins and scripts
"

noremap <F2> :<C-U>NERDTreeToggle<CR>
let NERDTreeIgnore = ['^\.DS_Store$', '\.pyc$', '^\.svn$', '^\.git$', '\.o$',]
let NERDTreeShowHidden = 1

noremap <F3> :<C-U>TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1

noremap <F5> :<C-U>GundoToggle<CR>

" Use :Man or S-k to display the man page for the word under the cursor
runtime! ftplugin/man.vim

nnoremap <Leader>w :SpaceBox<CR>
nnoremap <Leader>e :SpaceBoxInline<CR>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" TODO make a "reverse" command that gets you out of diff mode; also: clean up!
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
