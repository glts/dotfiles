" Settings I only want in gvim/mvim
"
" Author: glts <676c7473@gmail.com>
" Modified: 2012-07-21

set cursorline          " highlight cursor line
if exists('&colorcolumn')
  set colorcolumn=+1      " highlight end of text width
endif

set lines=50
set columns=100

"set guifont=Menlo:h12
set guioptions-=T       " do not show the toolbar
set guioptions-=m       " do not show the menu bar

colorscheme blackboard
