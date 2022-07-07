"=============================================================================
" File:          dfm.vim
" Author:        Mattia72 
" Description:   DFM files
" Created:       20.03.2019
" Project Repo:  https://github.com/Mattia72/vim-delphi
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

" Preprocessing {{{
let s:save_cpo = &cpo
set cpo&vim

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin") 
  finish  
endif

" Don't load another plug-in for this buffer
let b:did_ftplugin = 1
" Preprocessing }}}

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec "source " . s:path . "/common.vim"

"if 0 && exists("loaded_matchit")
if exists("loaded_matchit")
  let b:match_ignorecase = 1 " (pascal is case-insensitive)

  let s:begin_words ='\<\%(inherited\|object\|item\)\>'

  let b:match_words  = s:begin_words . ':\<end\>'
endif


" Undo the stuff we changed
if exists('b:undo_ftplugin') && !empty(b:undo_ftplugin)
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''

endif

let b:undo_ftplugin .= "unlet! b:browsefilter b:match_words" 


let &cpo = s:save_cpo
unlet s:save_cpo

