setlocal textwidth=80
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal softtabstop< shiftwidth< expandtab< textwidth<'
else
  let b:undo_ftplugin = 'setlocal softtabstop< shiftwidth< expandtab< textwidth<'
endif
