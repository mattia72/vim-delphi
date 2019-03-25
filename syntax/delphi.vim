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
syn sync lines=250

" http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Fundamental_Syntactic_Elements_(Delphi)
"
syn keyword delphiBool          true false
syn keyword delphiConditional   if then case else
syn keyword delphiConstant      nil maxint
syn keyword delphiLabel         goto label
syn keyword delphiOperator      not and or xor div mod as in is shr shl 
syn keyword delphiLoop          for to downto while repeat until do
syn keyword delphiReservedWord  array dispinterface finalization inherited initialization of packed set type with
syn keyword delphiReservedWord  const out threadvar var property
syn keyword delphiReservedWord  unit implementation interface 

syn keyword delphiPredef        result self
syn keyword delphiAssert        assert

"syn match delphiOperator "\v\+|-|\*|/|\@|\=|:\=|\<|\<\=|\>|\>\=|<>|\.\.|\^" 
"syn match delphiOperator "\v|\[|\]|\.|\:"
syn match delphiComma "\v[,;]"

" based on c_space_errors; to enable, use "delphi_space_errors".
if exists("delphi_space_errors")
  if exists("delphi_trailing_space_error")
    syn match delphiSpaceError "\s\+$"
  endif
  if exists("delphi_leading_tab_error")
    syn match delphiSpaceError " \+\t"me=e-1
  endif
endif

" TODO handle `of` conditionally: "case..of" is conditional; "array of" isn't
syn keyword delphiExcept try finally except on raise at
syn keyword delphiStructure class object record

syn keyword delphiCallingConv cdecl pascal register safecall stdcall winapi
syn keyword delphiDirective library package program 
syn keyword delphiDirective absolute abstract assembler delayed deprecated dispid dynamic experimental export external final forward implements inline name message overload override packed platform readonly reintroduce static unsafe varargs virtual writeonly
syn keyword delphiDirective helper reference sealed
syn keyword delphiDirective "contains" requires
syn keyword delphiDirective far near resident
syn keyword delphiVisibility private protected public published strict

syn keyword delphiPropDirective default index nodefault read stored write

syn keyword delphiWindowsType bool dword ulong
syn keyword delphiType boolean
syn keyword delphiType byte integer cardinal pointer
syn keyword delphiType single double extended comp currency


syn match delphiWindowsType "\v<h(dc|result|wnd)>"
syn match delphiType "\v<(byte|word|long)bool>"
syn match delphiType "\v<(short|small|long|nativeu?)int>"
syn match delphiType "\v<u?int(8|16|32|64|128)>"
syn match delphiType "\v<(long)?word>"
syn match delphiType "\v<real(48)?>"
syn match delphiType "\v<(ansi|wide)?char>"
syn match delphiType "\v<(ansi|wide|unicode|short)?string>"
syn match delphiType "\v<(ole)?variant>"

syn match  delphiNumber		"-\?\<\d\+\>"
syn match  delphiFloat		"-\?\<\d\+\.\d\+\>"
syn match  delphiFloat		"-\?\<\d\+\.\d\+[eE]-\=\d\+\>"
syn match  delphiHexNumber	"\$[0-9a-fA-F]\+\>"

syn match delphiChar "\v\#\d+"
syn match delphiChar "\v\#\$[0-9a-f]{1,6}"
syn match delphiBadChar "\v\%|\?|\\|\!|\"|\||\~"



" most common region begin .. end

syn match delphiIdentifier "\v<[a-z_]\w*>[^(]"me=e-1  containedin=delphiBeginEndBlock contained
"syn match delphiContainerType "\v<[a-z_]\w*>\."me=e-1  contains=delphiScopeSeparator containedin=delphiBeginEndBlock contained
syn match delphiQualifiedIdentifier "\v\.<[a-z_]\w*>[^(]"ms=s+1,me=e-1 contains=delphiScopeSeparator,delphiIdentifier containedin=delphiBeginEndBlock contained

syn region delphiBeginEndBlock  matchgroup=delphiBeginEnd start="\<begin\>" end="\<end\>" 
      \ contains=ALLBUT,delphiUsesBlock,delphiUnitName,delphiDeclareType fold 

" Highlight all function names ...after identifier!!!
syn match delphiCallableType "\v<%(constructor|destructor|function|operator|procedure)>"
syn match delphiParenthesis  "\v[()]"  contained 
syn match delphiCustomFunc   "\v<[a-z_]\w*>\s*\(" contains=delphiParenthesis 


" -----------------------------
" Regions...
" -----------------------------

" Type declaration TClassName = Class(...) ... end;
syn region delphiTypeBlock matchgroup=delphiTypeBlockSeparator start="\v<[T]\w*>\s*\=\s*<%(class|record)>" end="end;" 
      \ contains=ALLBUT,delphiBeginEndBlock,delphiUnitName keepend fold

" Uses unit list
syn match delphiScopeSeparator    "\." contained
syn match delphiUnitName "\v<[a-z_]\w*>" containedin=delphiUsesBlock contained
syn region delphiUsesBlock matchgroup=delphiUsesBlockSeparator start="\v<uses>" end=";" 
      \ contains=delphiComment,delphiLineComment,delphiUnitName,delphiScopeSeparator,delphiComma keepend fold

" Declaration
syn match    delphiScopeSeparator "\:" contained
syn match    delphiDeclareType    "\v\:\s*<[a-z_]\w*>" contains=delphiScopeSeparator

" Asm syntax
syn include @asm syntax/tasm.vim
syn region delphiAsmBlock matchgroup=delphiAsmBlockSeparator start="\v<asm>" end="\v<end>" contains=@asm

" Comments
syn keyword delphiTodo contained TODO FIXME NOTE
syn match delphiSpecialComment "@\w\+" 
syn region delphiComment start="{" end="}" contains=delphiTodo,delphiSpecialComment 
syn region delphiComment start="(\*" end="\*)" contains=delphiTodo,delphiSpecialComment 
syn region delphiLineComment start="//" end="$" oneline contains=delphiTodo
syn region delphiDefine start="{\$" end="}"
syn region delphiDefine start="(\*\$" end="\*)"

" String
syn region delphiString start="'" end="'" skip="''" oneline

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
  HiLink   delphiSpecialComment  SpecialComment         
  HiLink   delphiBeginEnd        Keyword 
  HiLink   delphiLineComment     Comment
  HiLink   delphiComment         Comment
  HiLink   delphiType            Type
  HiLink   delphiClassType       Type
  HiLink   delphiWindowsType     Type
  HiLink   delphiReservedWord    Keyword
  HiLink   delphiAsmBlockSeparator  PreProc
  HiLink   delphiNumber          Number
  HiLink   delphiHexNumber       Number
  HiLink   delphiFloat           Float
  HiLink   delphiDefine          Macro
  HiLink   delphiString          String
  HiLink   delphiChar            Character
  HiLink   delphiIdentifier      Identifier
  HiLink   delphiOperator        Operator
  HiLink   delphiConstant        Constant
  HiLink   delphiBool            Boolean
  HiLink   delphiPredef          Constant
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
  HiLink   delphiLabel           Label
  HiLink   delphiSpaceError	 Error
  HiLink   delphiCustomFunc      Function
  HiLink   delphiCallableType    Keyword
  HiLink   delphiQualifiedIdentifier Identifier
  HiLink   delphiDeclareType     Type
  HiLink   delphiContainerType   Type
  HiLink   delphiUsesBlockSeparator Keyword
  HiLink   delphiTypeBlockSeparator Type
  HiLink   DelphiUnitName        Type
  delcommand HiLink
endif

let b:current_syntax = "delphi"

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: ts=8
