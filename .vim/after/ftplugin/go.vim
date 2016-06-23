setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal softtabstop< shiftwidth< tabstop<'
else
  let b:undo_ftplugin = 'setlocal softtabstop< shiftwidth< tabstop<'
endif
