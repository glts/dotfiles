setlocal shiftwidth=4
setlocal softtabstop=4

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal softtabstop< shiftwidth<'
else
  let b:undo_ftplugin = 'setlocal softtabstop< shiftwidth<'
endif
