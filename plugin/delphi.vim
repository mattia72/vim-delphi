"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   plugin definitions
" Created:       16.03.2019
" Project Repo:  https://github.com/Mattia72/delphi
" License:       MIT license  {{{
"   Permission is hereby granted, free of charge, to any person obtaining
"   a copy of this software and associated documentation files (the
"   "Software"), to deal in the Software without restriction, including
"   without limitation the rights to use, copy, modify, merge, publish,
"   distribute, sublicense, and/or sell copies of the Software, and to
"   permit persons to whom the Software is furnished to do so, subject to
"   the following conditions:
"
"   The above copyright notice and this permission notice shall be included
"   in all copies or substantial portions of the Software.
"
"   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
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
  vnoremap <buffer> <silent> <leader>t= :<C-U>Tabularize /:=<CR>
  vnoremap <buffer> <silent> <leader>t: :<C-U>Tabularize /:<CR>
endif

let &cpo = s:save_cpo
unlet s:save_cpo
