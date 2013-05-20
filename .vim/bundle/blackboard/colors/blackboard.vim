" blackboard.vim
" Based on the original blackboard.vim, version 1.4, by Ben Wyrosdick.

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let g:colors_name = "blackboard"

if has("gui_running")
  " GUI Colors
  highlight Normal        guifg=White   guibg=#0B1022
  highlight Cursor        guifg=Black   guibg=Yellow
  highlight CursorLine    guibg=#191E2F
  highlight ColorColumn   guibg=#191E2F
  highlight LineNr        guibg=#323232 guifg=#888888
  highlight Folded        guifg=#F1F3E8 guibg=#444444
  highlight Pmenu         guibg=#84A7C1
  highlight NonText       guifg=#4A4A59
  highlight SpecialKey    guifg=#4A4A59
  highlight Ignore        guifg=#4A4A59
  highlight Visual        guibg=#1C3B79

  " General Colors
  highlight Comment       guifg=#AEAEAE
  highlight Constant      guifg=#CAFE1E
  highlight Keyword       guifg=#FFDE00
  highlight String        guifg=#00D42D
  highlight Type          guifg=#84A7C1
  highlight Identifier    guifg=#00D42D gui=NONE
  highlight Function      guifg=#FF5600 gui=NONE
  highlight clear Search
  highlight Search        guibg=#757816
  highlight PreProc       guifg=#FF5600

  " HTML Colors
  highlight link htmlTag Type
  highlight link htmlEndTag htmlTag
  highlight link htmlTagName htmlTag

  " Ruby Colors
  highlight link rubyClass Keyword
  highlight link rubyDefine Keyword
  highlight link rubyConstant Type
  highlight link rubySymbol Constant
  highlight link rubyStringDelimiter rubyString
  highlight link rubyInclude Keyword
  highlight link rubyAttribute Keyword
  highlight link rubyInstanceVariable Normal

  " Rails Colors
  highlight link railsMethod Type
end
