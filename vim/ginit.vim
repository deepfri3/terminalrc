" nvim GUI specific configuration
" font is normally set by the shell environment.
" nvim-qt you need to set the font

"windows
let s:fontsize = 9
GuiFont! Consolas:h9:cANSI
"set guifont=Source_Code_Pro_Medium:h9:cANSI
"set guifont=Source_Code_Pro_Medium:h11:cANSI
"set guifont=Source\ Code\ Pro\ for\ Powerline:h9:cANSI
"set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI
"set guifont=Source\ Code\ Pro\ for\ Powerline:h13:cANSI

function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Consolas:h" . s:fontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
