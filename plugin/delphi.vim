"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   DESCRIPTION   
" Created:       10 nov. 2016
" Project Repo:  https://github.com/Mattia72/delphi
"=============================================================================

scriptencoding utf-8

" Preprocessing {{{
if exists('g:loaded_delphi_vim')
  finish
elseif v:version < 700
  echoerr 'delphi.vim does not work this version of Vim "' . v:version . '".'
  finish
endif

let g:loaded_delphi_vim = 1

let s:save_cpo = &cpo
set cpo&vim
" Preprocessing }}}

" Global options defintion. {{{
"let g:delphi_vim_auto_open =
      "\ get(g:, 'delphi_vim_auto_open', 1)
" Global options defintion. }}}

" Autocommands {{{
" augroup delphi_vim_global_command_group
"   autocmd!
" augroup END
" Autocommands }}}

" Define commands to operate delphi
function! g:delphi#PascalFileLineCount(...)
  echomsg string(line('$'))
endfunction



set foldmethod=syntax
" folds are closed initially
set foldlevelstart=99

" select inside a begin-end block:
vnoremap af :<C-U>silent! normal! [zV]z<CR>
vnoremap if :<C-U>silent! normal! [zjV]zk<CR>
omap af :normal Vaf<CR>
omap if :normal Vif<CR>

if exists(':Tabularize')
  " Align selected assignes in nice columns with plugin
  vnoremap <buffer> <silent> <leader>t= :Tabularize /:=<CR>
  vnoremap <buffer> <silent> <leader>t: :Tabularize /:=<CR>
else 
  " Align lines by words in nice columns with external program
  vnoremap <buffer> <silent> <leader>t= :!column -t<CR>
  vnoremap <buffer> <silent> <leader>t: :!column -t<CR>
endif

" Align lines by words in nice columns
vnoremap <buffer> <silent> <leader>at :!column -t<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
