" autoload/syntaxjump.vim
" Author:       Lowe Thiderman <lowe.thiderman@gmail.com>
" Github:       https://github.com/thiderman/vim-syntaxjump

if exists('g:autoloaded_syntaxjump')
  finish
endif
let g:autoloaded_syntaxjump = '0.1'

let s:cpo_save = &cpo
set cpo&vim

" Variables {{{

if !exists("g:syntaxjump_forward")
  let g:syntaxjump_forward = ')'
endif

if !exists("g:syntaxjump_back")
  let g:syntaxjump_back = '('
endif

if !exists("g:syntaxjump_groups")
  let g:syntaxjump_groups = ['Statement', 'Exception', 'Define']
endif

if !exists("g:syntaxjump_disabled")
  let g:syntaxjump_disabled = ['txt', 'mail']
endif

" }}}
" Initialization {{{

function! syntaxjump#Init()
  if syntaxjump#CheckDisabled()
    return
  endif

  nmap <buffer> <silent> <Plug>SyntaxjumpForward :call syntaxjump#Jump()<cr>
  nmap <buffer> <silent> <Plug>SyntaxjumpBack :call syntaxjump#Jump('b')<cr>

  if hasmapto("<Plug>SyntaxjumpForward", 'n') || hasmapto("<Plug>SyntaxjumpForward", 'n')
    " Mappings are already set. Don't do nothing.
    return
  endif

  exe "nmap" g:syntaxjump_back "<Plug>SyntaxjumpBack"
  exe "nmap" g:syntaxjump_forward "<Plug>SyntaxjumpForward"
endfunction

" }}}
" Core functions {{{

function! syntaxjump#Jump(...)
  let pos = getpos('.')
  let lines = readfile(expand('%'))
  let linelen = len(lines)
  let range = a:0 ? reverse(range(0, pos[1] - 1)) : range(pos[1] + 1, linelen)

  for lnum in range
    let col = match(lines[lnum - 1], '\S')
    if col != -1 && syntaxjump#IsJumpable(lnum, col + 1)
      let pos[1] = lnum
      let pos[2] = col + 1
      return setpos('.', pos)
    endif
  endfor
endfunction

" }}}
" Helper functions {{{

" Check if a line begins with a jumpable syntax item.
function! syntaxjump#IsJumpable(line, col)
  let name = synIDattr(synIDtrans(synID(a:line, a:col, 1)), "name")
  return index(g:syntaxjump_groups, name) != -1
endfunction

" Check if the current filetype is in the list of disabled ones.
function! syntaxjump#CheckDisabled()
  return index(g:syntaxjump_disabled, &ft) != -1
endfunction

" }}}

let &cpo = s:cpo_save
