" My .vimrc settings, adapted from the example.
"
" Author: glts <676c7473@gmail.com>
" Modified: 2012-05-28

" Init

set nocompatible

if has('mouse')
  set mouse=a
endif

call pathogen#infect()

" Various settings

set directory=~/tmp,.   " directory for swap files
set nobackup            " keep no backup file
set writebackup         " keep a temporary backup while writing a file

set hidden

set history=200         " keep 200 lines of command line history

set backspace=indent,eol,start  " more intuitive backspace behaviour
set nostartofline       " keep cursor in same column when moving up and down
set nojoinspaces        " don't insert two-space sentence punctuation with J

set modeline            " always look for 2 modelines
set modelines=2

" TODO read up on this, am I doing this right?
set encoding=utf-8 fileencodings=

" TODO deal with CR, LF, CRLF correctly
set fileformats+=mac            " also detect mac-style EOL

set listchars=tab:▸\ ,eol:¬     " unprintable chars for 'list' mode

" Appearance

set ruler               " show cursor position, 'statusline' overrides this
set number              " show line numbers
set showmatch           " have your matching brackets wink at you
set showcmd             " display incomplete commands in status line
set scrolloff=2
set incsearch           " do incremental searching
set linebreak           " break screen lines at whitespace
set display=lastline    " fit as much as possible of a long line on screen
set shortmess+=I        " don't show intro screen at startup

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
set statusline+=\ line\ %l\ of\ %L   "cursor line/total lines
set statusline+=\ %P            "percent through file

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Autocommands

if has("autocmd")

  filetype plugin indent on

  augroup ft_settings
    au!
    autocmd FileType text setlocal textwidth=78
    autocmd FileType cpp,c,java setlocal ts=8 sw=4 sts=4 expandtab
    autocmd FileType python,perl,ruby,php setlocal ts=8 sw=4 sts=4 expandtab
    autocmd FileType sh setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType xml,html,xhtml,htmldjango setlocal ts=2 sw=2 sts=2 noexpandtab
    autocmd FileType javascript setlocal ts=8 sw=2 sts=2 expandtab
    autocmd FileType css setlocal ts=8 sw=2 sts=2 expandtab
    autocmd FileType rst setlocal tw=78 ts=3 sw=3 sts=3 expandtab
    autocmd FileType markdown setlocal ts=8 sw=4 sts=4 expandtab tw=72
    autocmd FileType vim setlocal ts=8 sw=2 sts=2 expandtab
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

  augroup filetype_c
    au!
    autocmd FileType c inoreabbrev <buffer> while while () {<CR>}<Up><End><Left><Left><Left>
    autocmd FileType c inoreabbrev <buffer> main( int main(int argc, char *argv[])<CR>{<CR>return 0;<CR>}<Up><Up>
    autocmd FileType c inoreabbrev <buffer> printf( printf("");<Left><Left><Left>
  augroup END

  augroup filetype_java
    au!
    autocmd FileType java inoreabbrev <buffer> main( public static void main(String[] args) {<CR>}<Up><End>
    autocmd FileType java inoreabbrev <buffer> class public class {<CR>}<Up><End><Left><Left>
  augroup END

  augroup other
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " I don't like the 'conceal' feature
    if has("conceal")
      set conceallevel=0
      autocmd FileType * setlocal conceallevel=0
    endif
  augroup END

else
  set autoindent
endif

" TODO highlight overlong lines, ie. characters at col 79+
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%79v.\+/

" Mappings and abbreviations

let mapleader = "\\"

inoremap <S-Enter> <Esc>o
inoremap <S-M-Enter> <Esc>O

" emulate command-line CTRL-K
" no this doesn't work because of Vims strange <C-O> behaviour (wrong col)
"inoremap <C-K> <C-O>:exec ':s/\%' . col(".") . 'c.*//'<CR><End><C-O>:nohls<CR>

" if (len(getline(".")) != col(".")) | normal! Da | endif
"inoremap <C-K> <C-O>:if (len(getline(".")) != col(".")) | normal! Da | endif

" use aesthetic middle of screen for "zz"
if has('float')
  nnoremap <silent> zz :exec "normal! zz" . float2nr(winheight(0)*0.1) . "\<Lt>C-E>"<CR>
endif
nnoremap n nzz
nnoremap N Nzz

inoreabbrev @@ 676c7473@gmail.com
inoreabbrev <@@ glts <Lt>676c7473@gmail.com>

nnoremap <silent> <Leader>l :set list!<CR>
nnoremap <silent> <Leader>n :nohls<CR>

" prettify XML fragments; NOTE depends on the surround plugin
nnoremap <Leader>x ggVGstroot>:%!xmllint --format -<CR>
nnoremap <Leader>ct :!ctags -R<CR>

cnoreabbrev w!! w !sudo tee % >/dev/null

" TODO this needs to be improved
inoreabbrev 2012 <C-O>:.r !date +\%F<CR><End>

" insert some "Lorem ipsum" text
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
noremap <F1> :tab help<CR>

noremap <leader>ve :tabedit $MYVIMRC<CR>

" Plugins and scripts

noremap <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore=[ '^\.DS_Store$', '\.pyc$', '^\.svn$', '^\.git$', ]
let NERDTreeShowHidden = 1

noremap <F3> :TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1

noremap <F5> :GundoToggle<CR>

" Use :Man or S-k to display the man page for the word under the cursor
runtime! ftplugin/man.vim

nnoremap <Leader>w :SpaceBox<CR>
nnoremap <Leader>e :SpaceBoxInline<CR>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" TODO make a "reverse" command that gets you out of diff mode
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif
