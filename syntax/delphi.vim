"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   Vim syntax file for Delphi Pascal Language
" Created:       24 okt. 2015
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

syn match delphiAsm "\v<asm>"
syn match delphiBeginEnd "\<\%(begin\|end\)\>"
syn region delphiBegEnd  matchgroup=delphiBeginEnd start="\<begin\>" end="\<end\>"  contains=ALLBUT,delphiFunc, fold 
syn match delphiIdentifier "\v\&?[a-z_]\w*"
" Highlight all function names
syn match delphiFunc /\w\+\s*(/me=e-1,he=e-1

syn match delphiOperator "\v\+|-|\*|/|\@|\=|:\=|\<|\<\=|\>|\>\=|<>|\.\."
syn match delphiOperator "\v|\[|\]|,|\.|\;|\:"

syn keyword delphiReservedWord array dispinterface finalization goto implementation inherited initialization label of packed set type uses with
syn keyword delphiReservedWord constructor destructor function operator procedure property
syn keyword delphiReservedWord const out threadvar var

syn keyword delphiLoop for to downto while repeat until do
" TODO handle `of` conditionally: "case..of" is conditional; "array of" isn't
syn keyword delphiConditional if then case else
syn keyword delphiExcept try finally except on raise at
syn keyword delphiStructure class interface object record

syn keyword delphiCallingConv cdecl pascal register safecall stdcall winapi
syn keyword delphiDirective library package program unit
syn keyword delphiDirective absolute abstract assembler delayed deprecated dispid dynamic experimental export external final forward implements inline name message overload override packed platform readonly reintroduce static unsafe varargs virtual writeonly
syn keyword delphiDirective helper reference sealed
syn keyword delphiDirective "contains" requires
syn keyword delphiDirective far near resident
syn keyword delphiVisibility private protected public published strict

syn keyword delphiPropDirective default index nodefault read stored write

syn keyword delphiNil nil
syn keyword delphiBool true false
syn keyword delphiPredef result self
syn keyword delphiAssert assert

syn keyword delphiOperator and as div in is mod not or shr shl xor

syn keyword delphiTodo contained TODO FIXME NOTE
syn region delphiComment start="{" end="}" contains=delphiTodo
syn region delphiComment start="(\*" end="\*)" contains=delphiTodo
syn region delphiLineComment start="//" end="$" oneline contains=delphiTodo
syn region delphiDefine start="{\$" end="}"
syn region delphiDefine start="(\*\$" end="\*)"

syn keyword delphiWindowsType bool dword ulong
syn match delphiWindowsType "\v<h(dc|result|wnd)>"
syn match delphiType "\v<(byte|word|long)bool>"
syn keyword delphiType boolean
syn match delphiType "\v<(short|small|long|nativeu?)int>"
syn match delphiType "\v<u?int(8|16|32|64|128)>"
syn match delphiType "\v<(long)?word>"
syn keyword delphiType byte integer cardinal pointer
syn keyword delphiType single double extended comp currency
syn match delphiType "\v<real(48)?>"
syn match delphiType "\v<(ansi|wide)?char>"
syn match delphiType "\v<(ansi|wide|unicode|short)?string>"
syn match delphiType "\v<(ole)?variant>"
" Let's define a type as being anything that starts with a capital E, I, P, or
" T, has a capital second letter, and has some lowercase letter. We require
" the capital second letter to exclude variable and function names that happen
" to start with E, I, P, or T, and we require the lowercase letter to exclude
" translated macros and abbreviations that just happen to be in all caps. It's
" not perfect, but it's a good approximation in the absence of a symbol table.
syn match delphiClassType "\v\C[IPTE][A-Z]\w*[a-z]\w*"

syn match delphiInteger "\v[-+]?\$[0-9a-f]+"
syn match delphiInteger "\v[-+]?\d+"
syn match delphiReal "\v[-+]?\d+\.\d*(e[-+]?\d+)?"
syn match delphiReal "\v[-+]?\.\d+(e[-+]?\d+)?"
syn match delphiReal "\v[-+]?\d+e[-+]?\d+"

syn region delphiString start="'" end="'" skip="''" oneline
syn match delphiChar "\v\#\d+"
syn match delphiChar "\v\#\$[0-9a-f]{1,6}"

syn region delphiAsmBlock start="\v<asm>" end="\v<end>" contains=delphiComment,delphiLineComment,delphiAsm keepend

syn match delphiBadChar "\v\%|\?|\\|\!|\"|\||\~"

syn sync fromstart

" highlight abKeywords guifg=blue
" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
if version >= 508 || !exists("did_delphi_syntax_inits")
  if version < 508
    let did_delphi_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink   delphiTodo            Todo         
  HiLink   delphiFunc            Function
  HiLink   delphiBeginEnd        Keyword
  HiLink   delphiLineComment     Comment
  HiLink   delphiComment         PreProc
  HiLink   delphiType            Type
  HiLink   delphiClassType       Function
  HiLink   delphiWindowsType     Type
  HiLink   delphiReservedWord    Keyword
  HiLink   delphiAsm             Keyword
  HiLink   delphiInteger         Number
  HiLink   delphiReal            Float
  HiLink   delphiDefine          PreProc
  HiLink   delphiString          String
  HiLink   delphiChar            Character
  HiLink   delphiIdentifier      NONE
  HiLink   delphiOperator        Operator
  HiLink   delphiNil             Constant
  HiLink   delphiBool            Boolean
  HiLink   delphiPredef          Special
  HiLink   delphiAssert          Debug
  HiLink   delphiLoop            Repeat
  HiLink   delphiConditional     Conditional
  HiLink   delphiExcept          Exception
  HiLink   delphiBadChar         Error
  HiLink   delphiVisibility      StorageClass
  HiLink   delphiCallingConv     StorageClass
  HiLink   delphiDirective       StorageClass
  HiLink   delphiPropDirective   StorageClass
  HiLink   delphiStructure       Structure
  delcommand HiLink
endif

let b:current_syntax = "delphi"

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: ts=8
