"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   File type plugin file for Delphi Pascal Language    
" Created:       22 okt. 2015
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

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin = '|'
endif

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin") 
  finish  
endif

" Don't load another plug-in for this buffer
let b:did_ftplugin = 1
" Preprocessing }}}

set autoindent noexpandtab tabstop=2 shiftwidth=2 

if 0 && exists("loaded_matchit")
  let b:match_ignorecase = 1 " (pascal is case-insensitive)

	let s:sol          = '\%(^\|;\)\s*'
  "let s:not_if      = '\%(\<if\s\+\)\@<!'
  let s:begin_words ='\<\%(begin\|case\|record\|object\|class\|try\)\>'
  let s:middle_words = '\<\%(except\|finally\)\>'
  "let s:not_begin_words ='\%('.s:begin_words.'\s\+\)\@<!'
  "let s:begin_end_words ='<\%(begin\|case\|record\|object\|class\|try\|end\)\>'
  "let s:not_begin_end_words ='\%('.s:begin_end_words.'\s\+\)\@<!'
  "let s:if_begin_end_words ='<\%(if\|begin\|case\|record\|object\|class\|try\|end\)\>'
  "let s:not_if_begin_end_words ='\%('.s:if_begin_end_words.'\s\+\)\@<!'

  
	"let s:notbeginend       = '\%(\<begin\|end\s\+\)\@<!'
	"" start of line or ;
  let b:match_words  = s:begin_words.':'.s:sol.s:middle_words.':\<end\>'
  let b:match_words .= ',\<repeat\>:\<until\>'
  let b:match_words .= ',\<while\>:\<do\>'
  "let b:match_words .= ',\<while\>:'.s:not_begin_words.'\<end\>'
  "let b:match_words .= ',\<do\>:'.s:not_begin_words.'\<end\>'
  let b:match_words .= ',\<if\>:\<else\>'
  "let b:match_words .= ',\<if\>:'.s:not_if.'\<else\>:'.s:not_begin_end_words.'\<end\>'
  "let b:match_words .= ',\<then\>:'.s:not_if_begin_end_words.'\<end\>'
  "let b:match_words .= ',\<else\>:'.s:not_if_begin_end_words.'\<end\>'
endif

" Set path for neosnippets
if exists("g:neosnippet#snippets_directory")
  let s:plugin_directory = fnamemodify(resolve(expand('<sfile>:p')), ':h')
  let g:delphi#neosnippet_directory = simplify(s:plugin_directory."/../snippets")
  if stridx(string(g:neosnippet#snippets_directory), g:delphi#neosnippet_directory) < 0
    let g:neosnippet#snippets_directory.=', '.g:delphi#neosnippet_directory
    "echomsg "get_dir:".string(neosnippet#get_snippets_directory())
  endif
endif

" Change the browse dialog on Win32 to show mainly Delphi related files
if has("gui_win32")
	let b:browsefilter =
				\ "All Delphi Files (*.pas,*.dpr)\t*.pas;*.dpr\n" .
				\ "All Files (*.*)\t*.*\n"
endif

" Undo the stuff we changed
let b:undo_ftplugin .= "
      \ unlet! b:browsefilter b:match_words b:begin_words b:middle_words 
      \ | setlocal foldmethod< foldlevelstart<" 

let &cpo = s:save_cpo
unlet s:save_cpo

