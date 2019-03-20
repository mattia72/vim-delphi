"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   plugin definitions
" Created:       16.03.2019
" Project Repo:  https://github.com/Mattia72/delphi
"=============================================================================

scriptencoding utf-8

" Preprocessing {{{
if exists('g:loaded_delphi_vim')
  finish
elseif v:version < 700
  echoerr 'vim-delphi does not work this version of Vim "' . v:version . '".'
  finish
endif

let g:loaded_delphi_vim = 1

let s:save_cpo = &cpo
set cpo&vim
" Preprocessing }}}

" Global options defintion. {{{
"
let pascal_delphi=1
let pascal_symbol_operator=1
let pascal_one_line_string=1
" tabs won't be shown as error
if exists("pascal_no_tabs") | unlet pascal_no_tabs | endif        " let pascal_no_tabs=0 has no effect. Checked with exists() in syntax pascal.vim

"let g:delphi_vim_auto_open =
      "\ get(g:, 'delphi_vim_auto_open', 1)
" Global options defintion. }}}

" Autocommands {{{
" augroup delphi_vim_global_command_group
"   autocmd!
" augroup END
" Autocommands }}}


" Define commands to operate delphi {{{
function! g:delphi#LineCount(...)
  echomsg string(line('$'))
endfunction

function! g:delphi#SwitchPasOrDfm()
  if (expand ("%:e") == "pas")
    find %:t:r.dfm
  else
    find %:t:r.pas
  endif
endfunction
"}}}

" select inside a begin-end block:
vnoremap af :<C-U>silent! normal! [zV]z<CR>
vnoremap if :<C-U>silent! normal! [zjV]zk<CR>
omap af :normal Vaf<CR>
omap if :normal Vif<CR>

if exists(':Tabularize')
  " Align selected assignes in nice columns with plugin
  vnoremap <buffer> <silent> <leader>t= :Tabularize /:=<CR>
  vnoremap <buffer> <silent> <leader>t: :Tabularize /:<CR>
endif

let &cpo = s:save_cpo
unlet s:save_cpo
