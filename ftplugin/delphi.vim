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

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif

" Don't load another plug-in for this buffer
let b:did_ftplugin = 1
" Preprocessing }}}

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec "source " . s:path . "/common.vim"

set commentstring=//%s

"if 0 && exists("loaded_matchit")
if exists("loaded_matchit")
  let b:match_ignorecase = 1 " (pascal is case-insensitive)

  "let s:not_if   = '\%(\<if\s\+\)\@<!'
	"let s:notbegin = '\%(\<begin\s\+\)\@<!'
	"let s:notend   = '\%(\<end\s\+\)\@<!'
	" no // comment line
	let s:nc   = '\%(\/\/.*\)\@<!'
	" startline
	let s:sl = '^\s*'
	" start of line or ;
  " let s:sol              = '\%(^\|;\)\s*'
  " let s:not_func_or_proc = '\%(\s\+\%(function\|procedure\)\)\@<!'
  let s:begin_words      = '\<\%(begin\|record\|object\|except\|finally\)\>'
  let s:middle_words     = '\<\%(except\|finally\)\>'
  let s:after_impl = '\('.s:sl.'implementation\)\@<='
  let s:proc_or_func_words = '\<\%(constructor\|destructor\|procedure\|function\)\>'
  let s:end_word         = '\<end\>'

  let b:delphi_match_words     = ''
  "it doesn't work in interface
  "let b:delphi_match_words     .= s:after_impl.s:nc.s:proc_or_func_words.':'.s:nc.'\<begin\>:'.s:nc.s:end_word
  let b:delphi_match_words     .= s:nc.s:begin_words.':'.s:nc.s:end_word
  let b:delphi_match_words     .= ','.s:nc.'\<case\>:'.s:nc.'\<of\>:'.s:nc.'\<end\>'
  let b:delphi_match_words     .= ','.s:nc.'\<try\>:'.s:nc.s:middle_words " .':'.s:end_word   !!!! :( but not begin end !!!!
  let b:delphi_match_words     .= ','.s:sl.'\<unit\>'.':'.s:sl.'\<interface\>'.':'.s:sl.'\<implementation\>'.':'.s:sl.'\<end\.'
  let b:delphi_match_words     .= ','.s:nc.'\%(= \s*\)\zsclass\>:'.s:nc.s:end_word
  let b:delphi_match_words     .= ','.s:nc.'\<uses\>:;'
  let b:delphi_match_words     .= ','.s:nc.'\<repeat\>:'.s:nc.'\<until\>'
  let b:delphi_match_words     .= ','.s:nc.'\<while\>:'.s:nc.'\<do\>'
  "let b:delphi_match_words     .= ','.s:nc.'\<if\>:'.s:nc.'\<then\>'
  let b:delphi_match_words     .= ','.s:nc.'\<if\>:'.s:nc.'\<then\>:'.s:nc.'\<else\>'  " it works only if 'else' exists
  let b:delphi_match_words     .= ','.s:nc.'\<case\>:'.s:nc.'\<else\>:'.s:nc.'\<end\>' " it works only if 'else' exists
  "let b:delphi_match_words     .= ',\<\$region\>:\<\$endregion\>'

  if exists("g:matchup_matchparen_enabled")
    call matchup#util#append_match_words(b:delphi_match_words)
  else
    b:match_words = b:delphi_match_words
  endif

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
				\ "All Delphi Files (*.pas,*.dpr,*.dfm)\t*.pas;*.dpr;*.dfm\n" .
				\ "All Files (*.*)\t*.*\n"
endif

" Undo the stuff we changed
if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin = '|'
endif

let b:undo_ftplugin .= "
      \ unlet! b:browsefilter b:match_words, b:delphi_match_words b:begin_words b:middle_words
      \ "

let &cpo = s:save_cpo
unlet s:save_cpo

