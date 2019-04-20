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
syn keyword delphiConditional   if then else
syn keyword delphiConstant      nil maxint
syn keyword delphiLabel         goto label continue break exit
syn keyword delphiOperator      not and or xor div mod as in is shr shl 
syn keyword delphiLoop          for to downto while repeat until do
syn keyword delphiReservedWord  array dispinterface finalization inherited initialization of packed set type with
syn keyword delphiReservedWord  unit implementation 
syn keyword delphiPredef        result self
syn keyword delphiAssert        assert

"syn match delphiOperator "\v\+|-|\*|/|\@|\=|:\=|\<|\<\=|\>|\>\=|<>|\.\.|\^" 
"syn match delphiOperator "\v|\[|\]|\.|\:"

"syn match delphiSemicolonError display "\zs[^;]\ze\s*$"

if exists("delphi_space_errors")
  " based on c_space_errors; to enable, use "delphi_space_errors".
  if exists("delphi_trailing_space_error")
    syn match delphiSpaceError display excludenl "\s\+$"
  endif
  if exists("delphi_leading_tab_error")
    syn match delphiSpaceError "^ *\zs\t\+" display
  elseif exists("delphi_leading_space_error")
    syn match delphiSpaceError "^\t*\zs \+" display
  endif
endif

" TODO handle `of` conditionally: "case..of" is conditional; "array of" isn't
syn keyword delphiExcept try on raise at
syn keyword delphiStructure class object record

syn keyword delphiCallingConv cdecl pascal register safecall stdcall winapi

syn keyword delphiDirective absolute abstract assembler "contains" delayed deprecated
syn keyword delphiDirective dispid dynamic experimental export external far final
syn keyword delphiDirective forward helper implements inline library message name near
syn keyword delphiDirective overload override package packed platform program readonly
syn keyword delphiDirective reference reintroduce requires resident sealed static unsafe
syn keyword delphiDirective varargs virtual writeonly 

syn keyword delphiVisibility private protected public published strict

syn keyword delphiPropDirective default index nodefault read stored write

syn keyword delphiWindowsType bool dword ulong
syn match delphiWindowsType "\v<h(dc|result|wnd)>" display

syn keyword delphiType boolean
syn keyword delphiType byte integer cardinal pointer
syn keyword delphiType single double extended comp currency

syn match delphiType "\v<(byte|word|long)bool>" display
syn match delphiType "\v<(short|small|long|nativeu?)int>" display
syn match delphiType "\v<u?int(8|16|32|64|128)>" display
syn match delphiType "\v<(long)?word>" display
syn match delphiType "\v<real(48)?>" display
syn match delphiType "\v<(ansi|wide)?char>" display
syn match delphiType "\v<(ansi|wide|unicode|short)?string>" display
syn match delphiType "\v<(ole)?variant>" display

syn match  delphiNumber		"-\?\<\d\+\>" display
syn match  delphiFloat		"-\?\<\d\+\.\d\+\>" display
syn match  delphiFloat		"-\?\<\d\+\.\d\+[eE]-\=\d\+\>"   display
syn match  delphiHexNumber	"\$[0-9a-fA-F]\+\>" display

syn match delphiChar "\v\#\d+" display
syn match delphiChar "\v\#\$[0-9a-f]{1,6}" display

syn match delphiBadChar "\v\%|\?|\\|\!|\"|\||\~" display

" FIXME: It can be faster : "end\.\ze\(\(end\.\)\@!\_.\)*\%$"
syn match delphiUnitEnd "^end\." display

" -----------------------------
"  Dangerous part ...
" -----------------------------

syn match delphiIdentifier "\v\&?<[a-z]\w+>"  containedin=delphiBeginEndBlock contained  display

" case sensitive \C
syn match delphiConstant "\v\C<[A-Z_][A-Z0-9_]+>" display

if exists("delphi_highlight_function_parameters")
  syn match delphiFunctionParameter "\v<_\w+>\ze[^(]"
endif
syn match delphiTemplateParameter "<\zs\(\w\+\(\s*,\?\s*\w\+\)*\)\+\ze>" contained display
"syn match delphiClassParameter "\<class\>\s*(\zs\(\w\+\(\s*,\?\s*\w\+\)*\)\+\ze)" contained display

" -----------------------------
" Regions...
" -----------------------------

" Highlight all function names and function definitions 
syn match delphiFunctionName   "\v<[a-z_]\w*>\ze\(" contains=delphiParenthesis display nextgroup=delphiFunctionParams 
syn match delphiCallableType "\<function\>"
syn match delphiCallableType "\<procedure\>"
syn match delphiCallableType "\<constructor\>"
syn match delphiCallableType "\<destructor\>"
syn match delphiCallableType "\<operator\>"

syn region delphiFunctionParams matchgroup=delphiParenthesis start="(" end=")" fold
      \ contains=ALLBUT,delphiVarBlock,delphiUnitName,delphiSemicolonError
syn region delphiFunctionDefinition matchgroup=delphiFunctionDefSeparator start="\v<%(constructor|destructor|function|operator|procedure)>\s+\ze%(\w+\.)+" end="\v\.\ze\w+\("me=e-1 keepend display

" Var block: last line before begin, const or fuction etc...
syn match delphiTypeModifier  "\<const\>"
syn match delphiTypeModifier  "\<out\>"
syn match delphiTypeModifier  "\<threadvar\>"
syn match delphiTypeModifier  "\<var\>"
syn match delphiTypeModifier  "\<property\>"
syn region delphiVarBlock matchgroup=delphiVarBlockSeparator start="\v%(^\s*)\zsvar>" end="\v%(\n+)\ze\s*<%(var|implementation|const|begin|function|procedure)>" 
      \ contains=ALLBUT,delphiTypeModifier,delphiBeginEndBlock,delphiUnitName keepend fold 
syn region delphiVarBlock matchgroup=delphiVarBlockSeparator start="\v%(^\s*)\zsconst>" end="\v%(\n+)\ze\s*<%(var|implementation|const|begin|function|procedure)>" 
      \ contains=ALLBUT,delphiTypeModifier,delphiBeginEndBlock,delphiUnitName keepend fold 

syn cluster delphiInterfaceContents contains=delphiUsesBlock,delphiVarBlock,delphiUnitName,delphiContainerType,delphiDeclareType

" begin .. end
syn region delphiBeginEndBlock matchgroup=delphiBeginEnd start="\<begin\>" end="\<end\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 
syn region delphiTryEndBlock matchgroup=delphiBeginEnd start="\<try\>" end="\<finally\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 
syn region delphiFinallyEndBlock matchgroup=delphiBeginEnd start="\<finally\>" end="\<end\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 
syn region delphiExceptEndBlock matchgroup=delphiBeginEnd start="\<except\>" end="\<end\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 
syn region delphiCaseEndBlock matchgroup=delphiBeginEnd start="\<case\>" end="\<end\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 
syn region delphiRecordEndBlock matchgroup=delphiBeginEnd start="\<record\>" end="\<end\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 
syn region delphiObjectEndBlock matchgroup=delphiBeginEnd start="\<object\>" end="\<end\>" 
      \ contains=ALLBUT,@delphiInterfaceContents extend fold 


" FIXME parenthesis after class(...)
" Type declaration TClassName = class|record ... end;
syn match delphiInterfaceSection "\<interface\>"
syn region delphiTypeBlock matchgroup=delphiTypeBlockSeparator start="\v<[TI]\w+>\s*\=\s*<%(class|record|interface)>" end="\<end\>;" 
      \ contains=ALLBUT,delphiVarBlock,delphiBeginEndBlock,delphiUnitName,delphiFunctionDefinition extend fold

syn cluster delphiComments contains=delphiComment,delphiLineComment,delphiRegion

" Uses unit list
syn match delphiScopeSeparator "\." contained
syn match delphiUnitName "\v<[a-z_]\w*>" containedin=delphiUsesBlock contained
syn region delphiUsesBlock matchgroup=delphiUsesBlockSeparator start="\v<uses>" end=";"me=e-1 
      \ contains=@delphiComments,delphiUnitName,delphiScopeSeparator keepend fold

" Declaration
syn match    delphiScopeSeparator "\:" contained
syn match    delphiDeclareType    "\v\:\s*<[a-z_]\w*>" contains=delphiScopeSeparator

" Asm syntax
syn include @asm syntax/tasm.vim
syn region delphiAsmBlock matchgroup=delphiAsmBlockSeparator start="\v<asm>" end="\v<end>" contains=@asm fold

" Comments
syn keyword delphiTodo contained TODO FIXME NOTE
syn match delphiSpecialComment "@\w\+" 
syn region delphiComment start="{" end="}" contains=delphiTodo,delphiSpecialComment fold
syn region delphiComment start="(\*" end="\*)" contains=delphiTodo,delphiSpecialComment fold
syn region delphiLineComment start="//" end="$" oneline contains=delphiTodo


" FIXME contains ALL highlights everything to delphiUnitName :( so it won't work
" properly in UsesBlock
syn region delphiRegion start="{\$region.*}" end="{\$endregion}" contains=ALLBUT,delphiUnitName keepend fold
syn region delphiDefine start="(\*\$" end="\*)"
syn region delphiDefine start="{\$" end="}"

" String
syn region delphiString start="'" end="'" skip="''" oneline display keepend



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
  HiLink   delphiWindowsType     Type
  HiLink   delphiReservedWord    Keyword
  HiLink   delphiInterfaceSection Keyword
  HiLink   delphiUnitEnd         Keyword
  HiLink   delphiTypeModifier    Keyword
  HiLink   delphiVarBlockSeparator Keyword
  HiLink   delphiAsmBlockSeparator  PreProc
  HiLink   delphiNumber          Number
  HiLink   delphiHexNumber       Number
  HiLink   delphiFloat           Float
  HiLink   delphiDefine          Macro
  HiLink   delphiString          String
  HiLink   delphiChar            Character
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
  HiLink   delphiTemplateParameter StorageClass
  HiLink   delphiPropDirective   Function
  HiLink   delphiStructure       Structure
  HiLink   delphiLabel           Label
  HiLink   delphiSpaceError	 Error
  HiLink   delphiSemicolonError Error
  HiLink   delphiFunctionName      Function
  HiLink   delphiCallableType    Keyword
  HiLink   delphiFunctionDefSeparator delphiCallableType
  HiLink   delphiDeclareType     Type
  HiLink   delphiContainerType   Type
  HiLink   delphiUsesBlockSeparator Keyword
  HiLink   delphiTypeBlockSeparator Type
  HiLink   DelphiUnitName        Type
  HiLink   delphiIdentifier      Normal
  HiLink   delphiFunctionParameter Identifier
  HiLink   delphiFunctionDefinition Type
  HiLink   delphiQualifiedIdentifier Identifier
  HiLink   delphiParenthesis Normal
  delcommand HiLink
endif

let b:current_syntax = "delphi"

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: ts=2
