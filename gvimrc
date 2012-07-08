" Settings I only want in my MacVim 7.3
"
" Author: glts <676c7473@gmail.com>
" Modified: 2012-05-28

set cursorline          " highlight cursor line
if exists('&colorcolumn')
  set colorcolumn=+1      " highlight end of text width
endif

set guifont=Menlo:h12
set guioptions-=T       " do not show the toolbar

colorscheme blackboard
