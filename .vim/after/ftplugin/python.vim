setlocal textwidth=79

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal textwidth<'
else
  let b:undo_ftplugin = 'setlocal textwidth<'
endif
