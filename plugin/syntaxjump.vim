" plugin/syntaxjump.vim
" Author:       Lowe Thiderman <lowe.thiderman@gmail.com>
" Github:       https://github.com/thiderman/vim-syntaxjump

if exists('g:loaded_syntaxjump') || &cp || v:version < 700
  finish
endif
let g:loaded_syntaxjump = 1

let s:cpo_save = &cpo
set cpo&vim

augroup syntaxjump
  au!
  au BufEnter * call syntaxjump#Init()
augroup END

let &cpo = s:cpo_save
