" Settings I only want in gvim/mvim
"
" Author: glts <676c7473@gmail.com>
" Modified: 2012-12-02

set cursorline          " highlight cursor line
if exists('&colorcolumn')
  set colorcolumn=+0    " highlight end of text width
endif

set lines=50
set columns=100

" set guifont=Consolas:h13
set guioptions-=T       " do not show the toolbar
set guioptions-=m       " do not show the menu bar
set guioptions+=c       " do not use popup dialogs

colorscheme blackboard
