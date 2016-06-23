setlocal textwidth=72
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

" TODO check options:
setlocal formatoptions+=n
setlocal comments=n:>,fb:-,fb:*

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal comments< formatoptions< softtabstop< shiftwidth< expandtab< textwidth<'
else
  let b:undo_ftplugin = 'setlocal comments< formatoptions< softtabstop< shiftwidth< expandtab< textwidth<'
endif
