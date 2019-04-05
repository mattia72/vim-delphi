"=============================================================================
" File:          dfm.vim
" Author:        Mattia72 
" Description:   Vim syntax file for Delphi DFM files
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

let s:save_cpo = &cpo
set cpo&vim

if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore
syn sync lines=250

syn keyword dfmKeyword inherited object item end 
syn keyword dfmBoolean true false

syn match  dfmNumber	    "-\?\<\d\+\>" display
syn match  dfmFloat	    "-\?\<\d\+\.\d\+\>" display
syn region dfmString start="'" end="'" skip="''" oneline

syn match    dfmCustomScope "\."
syn match    dfmEmbeddedClass "\v\w+\s*\.[^.0-9]"me=e-1 contains=dfmCustomScope
" Declaration
syn match    dfmCustomScope "\:"
syn match    dfmEmbeddedClass "\:\s*\w\+" contains=dfmCustomScope

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
if version >= 508 || !exists("did_delphi_syntax_inits")
  if version < 508
    let did_delphi_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink  dfmKeyword        Keyword 
  HiLink  dfmBoolean        Boolean
  HiLink  dfmCustomScope    Normal
  HiLink  dfmEmbeddedClass  Type
  HiLink  dfmNumber         Number
  HiLink  dfmFloat          Number
  HiLink  dfmString         String
  delcommand HiLink
endif

let b:current_syntax = "dfm"

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: ts=8
