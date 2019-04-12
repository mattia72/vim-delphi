"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   Vim indent file for Delphi Pascal Language.
"                Based on builtin pascal indent by Neil Carter
"                see also http://psy.swansea.ac.uk/staff/carter/vim/
" Created:       05 apr. 2019
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

echom 'delphi.vim: start...'

" Only load this indent file when no other was loaded.
if exists("b:did_indent") | finish | endif
let b:did_indent = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal indentexpr=GetDelphiIndent(v:lnum)
setlocal indentkeys&
setlocal indentkeys+==end;,==const,==type,==var,==begin,==repeat,==until,==for
setlocal indentkeys+==program,==function,==procedure,==object,==private
setlocal indentkeys+==record,==if,==else,==case


if exists("*GetDelphiIndent")
  "echom 'delphi.vim: Here should we finish'
	"finish
endif

let s:delphi_comment = '^\s*\(\((\*\)\|\(\*\ \)\|\(\*)\)\|{\|}\)'
let s:delphi_line_comment = '\/\/.*'

function! s:GetPrevNonCommentLineNum( line_num )
	" Skip lines starting with a comment
	let nline = a:line_num
	while nline > 0
		let nline = prevnonblank(nline-1)
		if getline(nline) !~? '^\s*\%(\%('.s:delphi_comment.'\)\|\%('.s:delphi_line_comment.'\)\)'
		"if getline(nline) !~? s:delphi_comment
			break
		endif
	endwhile
	return nline
endfunction

function! s:RemoveComment(line)
  let prev_unc_line =  substitute(a:line, s:delphi_comment, "", "")
  ""echom "RemCom: ".substitute(prev_unc_line, s:cpp_comment, "", "") 
  return substitute(prev_unc_line, s:delphi_line_comment, "", "")
endfunction

" Search backwards the matching start element
" if end_element empty, it doesn't check for nested elements
function! s:GetMatchingElemLineNum( line_num, start_element, end_element )

	let nline = prevnonblank(a:line_num - 1)
  let skip_start_elem_num = 0

	while nline > 0
		let line = getline(nline)

		if !empty(a:end_element) && line =~ a:end_element
		  let skip_start_elem_num += 1
		endif

		if line  =~ a:start_element
      "echom 'start elem found'
		  if skip_start_elem_num != 0
        "echom 'but we skipp '.skip_start_elem_num
		    let skip_start_elem_num -= 1
		    next
		  else
        "echom 'that's it :)'.nline
		    break
		  endif
		endif

		let nline = prevnonblank(nline-1)
	endwhile

	return nline
endfunction

" words in line after which we should indent
let s:ind_block_words = join(['class','type','record'],'\>\|')

" words after one line should be indented if not a block
let s:ind_line_words = join([ 'if', 'then', 'else', 
      \ 'for', 'while',
      \ 'case','default'], '\>\|')

function! GetDelphiIndent( line_num )
  "echom 'GetDelphiIndent start at: '.a:line_num
	
	" Line 0 always goes at column 0
	if a:line_num == 0 | return 0 | endif

	let this_line = getline( a:line_num )
	let shift_val = 0

	" SAME INDENT
	
	" TODO: In the middle of a three-part comment. this check is not enough!
	if this_line =~ '^\s*\*' | return indent( a:line_num - 1) | endif

	" COLUMN 1 ALWAYS

	" Last line of the program
	if this_line =~ '^\s*end\.' | return 0 | endif

	" Compiler directives, allowing "(*" and "{"
	"if this_line =~ '^\s*\({\|(\*\)$\(IFDEF\|IFNDEF\|ELSE\|ENDIF\)'
	if this_line =~ '^\s*\({\|(\*\)\$' | return 0 | endif

	" section headers at start of line.
	if this_line =~ '^\s*\(program\|interface\|type\|implementation\|uses\|unit\)\>'
		return 0
	endif

	" Subroutine separators, lines ending with "const" or "var"
	if this_line =~ '^\s*\((\*\ _\+\ \*)\|\(const\|var\)\)$'
		return 0
	endif


	" OTHERWISE, WE NEED TO LOOK FURTHER BACK...

	let prev_codeline_num = s:GetPrevNonCommentLineNum( a:line_num )
	let prev_codeline = getline( prev_codeline_num )
	let indnt = indent( prev_codeline_num )


	" INCREASE INDENT

	" If the PREVIOUS LINE ended in these items, always indent
	if prev_codeline =~ '\<\(type\|const\|var\)$'
		return indnt + shiftwidth()
	endif

	if prev_codeline =~ '\<repeat$'
		if this_line !~ '^\s*until\>'
			return indnt + shiftwidth()
		else
			return indnt
		endif
	endif

	if prev_codeline =~ '\<\(begin\|record\|class\)$'
		if this_line !~ '^\s*end\>'
			return indnt + shiftwidth()
		else
			return indnt
		endif
	endif

	" If the PREVIOUS LINE ended with these items, indent if not
	" followed by "begin"
	if prev_codeline =~ '\<\(\|else\|then\|do\)$' || prev_codeline =~ ':$'
		if this_line !~ '^\s*begin\>'
			return indnt + shiftwidth()
		else
			" If it does start with "begin" then keep the same indent
			"return indnt + shiftwidth()
			return indnt
		endif
	endif

	" Inside a parameter list (i.e. a "(" without a ")"). ???? Considers
	" only the line before the current one. 
	" FIXME: Get it working for  parameter lists longer than two lines.
	if prev_codeline =~ '([^)]\+$'
		return indnt + shiftwidth()
	endif


	" DECREASE INDENT

	" Lines starting with "else", but not following line ending with
	" "end".
	if this_line =~ '^\s*else\>' && prev_codeline !~ '\<end$'
		return indnt - shiftwidth()
	endif

	" Lines after a single-statement branch/loop.
	" Two lines before ended in "then", "else", or "do"
	" Previous line didn't end in "begin"
	let prev2_codeline_num = s:GetPrevNonCommentLineNum( prev_codeline_num )
	let prev2_codeline = getline( prev2_codeline_num )
	if prev2_codeline =~ '\<\(then\|else\|do\)$' && prev_codeline !~ '\<begin$'
		" If the next code line after a single statement branch/loop
		" starts with "end", "except" or "finally", we need an
		" additional unindentation.
		if this_line =~ '^\s*\(end;\|except\|finally\|\)$'
			" Note that we don't return from here.
			return indnt - 2 * shiftwidth()
		endif
		return indnt - shiftwidth()
	endif

	" Lines starting with "until" or "end". This rule must be overridden
	" by the one for "end" after a single-statement branch/loop. In
	" other words that rule should come before this one.
	if this_line =~ '^\s*\(end\|until\)\>'
		return indnt - shiftwidth()
	endif


	" MISCELLANEOUS THINGS TO CATCH

	" Most "begin"s will have been handled by now. Any remaining
	" "begin"s on their own line should go in column 1.
	if this_line =~ '^\s*begin$'
		return 0
	endif


  " ____________________________________________________________________
  " Object/Borland Pascal/Delphi Extensions
  "
  " Note that extended-pascal is handled here, unless it is simpler to
  " handle them in the standard-pascal section above.


	" COLUMN 1 ALWAYS

   "section headers at start of line.
  "if this_line =~ '^\s*\(interface\|implementation\|uses\|unit\)\>'
    "return 0
  "endif


	" INDENT ONCE

	" If the PREVIOUS LINE ended in these items, always indent.
	if prev_codeline =~ '^\s*\(unit\|uses\|try\|except\|finally\|private\|protected\|public\|published\)$'
		return indnt + shiftwidth()
	endif

	" ???? Indent "procedure" and "functions" if they appear within an
	" class/object definition. But that means overriding standard-pascal
	" rule where these words always go in column 1.


	" UNINDENT ONCE

	if this_line =~ '^\s*\(except\|finally\)$'
		return indnt - shiftwidth()
	endif

	if this_line =~ '^\s*\(private\|protected\|public\|published\)$'
		return indnt - shiftwidth()
	endif


  " ____________________________________________________________________

	" If nothing changed, return same indent.
	return indnt
endfunction


if !exists('b:undo_indent')
    let b:undo_indent = ''
else
    let b:undo_indent = '|'
endif

let b:undo_indent .= '
    \ setlocal indentexpr< indentkeys<
    \'

let &cpo = s:save_cpo
unlet s:save_cpo
