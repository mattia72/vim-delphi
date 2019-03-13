"=============================================================================
" File:          abinitio.vim
" Author:        Mattia72 
" Description:   Vim syntax file for Ab Initio Data Manipulating Language   
" Created:       24 okt. 2015
" Project Repo:  https://github.com/Mattia72/vim-abinitio
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

syn case match

syn cluster abNotTop contains=abSpecial,abTodo
syn cluster abTypes contains=abType,abRecordType,abVectorType,abUnionType
syn cluster abTypeDeclContent contains=@abTypes,abKeyword,abString,abConstant,abNumber,abVariable,
syn cluster abExpression contains=@abTypeDeclContent,abOperator,abColumnName

" Operators
syn match  abOperator "-=\|/=\|\*=\|&=\|&&\|/=\|||\|%=\|+=\|!\~\|!=\|=="
syn keyword abOperator or
syn keyword abOperator and
syn keyword abOperator not
syn match abAssignOp "::"

syn match abSpecial  display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match abSpecial  display contained '%\(?:\d+\$\)\?[dfsu]'


" Integer with - + or nothing in front
syn match abNumber '\d\+'
syn match abNumber '[-+]\d\+'
" Floating point number with decimal no E or e (+,-)
syn match abNumber '\d\+\.\d*'
syn match abNumber '[-+]\d\+\.\d*'
" Floating point like number with E and no decimal point (+,-)
syn match abNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match abNumber '\d[[:digit:]]*[eE][\-+]\=\d\+'
" Floating point like number with E and decimal point (+,-)
syn match abNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
syn match abNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

syn region abParen transparent start='(' end=')' contains=ALLBUT,@Spell

"Variable is: name but not .name
syn match abVariable "^\<\h[a-zA-Z0-9#_]*\>"
syn match abVariable "[^.]\zs\<\h[a-zA-Z0-9#_]*\>"
syn match abColumnName "\.\zs\%(\<\h[a-zA-Z0-9#_]*\>\|\*\)"
syn match abPort "\<\%(in\|out\|error\|\(file\)*reject\|log\)\d*\>" nextgroup=abColumnName 

"TODO key specifier 
syn match abKeySpec "{\<\h[a-zA-Z0-9#_]*\>*}"

"TODO: After abPort.abColumnName '=' is not allowed
syn match abAssignError display contained "\%(\<\%(in\|out\|error\|\(file\)*reject\|log\)\d*\>\.\%(\<\h[a-zA-Z0-9#_]*\>\|\*\)\s*\)\zs=" 

syn keyword abType type  
syn keyword abType string date datetime short signed unsigned void skipwhite nextgroup=abParen
syn keyword abType decimal float real long int integer double skipwhite nextgroup=abParen

syn keyword abLet let skipwhite nextgroup=@abTypes

syn keyword abConstant NULL

syn keyword abInclude include 

syn keyword abKeyword _KEYTYPE_ constant delimiter 
syn keyword abKeyword member metadata package packed 

syn keyword abCodePage iso_8859_1 iso_8859_2 iso_8859_3 iso_8859_4 iso_8859_5 iso_8859_6 iso_8859_7 iso_8859_8 iso_8859_9 
syn keyword abCodePage iso_arabic iso_cyrillic iso_easteuropean iso_turkish iso_greek iso_hebrew iso_latin_1 iso_latin_2 iso_latin_3 iso_latin_4 jis_201
syn keyword abCodePage ascii ebcdic endian euc_jis ibm ieee unicode utf8 big little 

syn keyword abComponent reformat join rollup normalize denormalize scan 

syn keyword abConditional if else case default

syn keyword abRepeat while for do

syn keyword abBuiltInFunc reformat first_defined reinterpret_as shift_jis 
syn keyword abBuiltInFunc this_record 

"Core functions
syn keyword abBuiltInFunc accumulation avg close_output concatenation copy_data count 
syn keyword abBuiltInFunc final_log_output first input_connected last log_error 
syn keyword abBuiltInFunc make_error max min  new_xml_doc output_connected output_for_error  
syn keyword abBuiltInFunc peek_object previous product read_byte read_object read_record 
syn keyword abBuiltInFunc read_string reject_data  set_starting_byte_offset stdev sum 
syn keyword abBuiltInFunc vector_concatenation write_data write_record write_string 
syn keyword abBuiltInFunc xml_add_attribute xml_add_cdata  xml_add_element  xml_begin_document  
syn keyword abBuiltInFunc xml_begin_element  xml_end_document xml_end_element xml_format  
syn keyword abBuiltInFunc xml_get_attribute xml_get_element xml_parse 
"String functions
syn keyword abBuiltInFunc char_string decimal_lpad decimal_lrepad decimal_strip edit_distance 
syn keyword abBuiltInFunc ends_with hamming_distance is_blank is_bzero make_byte_flags re_get_match 
syn keyword abBuiltInFunc re_get_matches re_get_matches re_index re_match_replace re_match_replace_all re_replace 
syn keyword abBuiltInFunc re_replace_first re_split re_split_no_empty starts_with string_char string_cleanse 
syn keyword abBuiltInFunc string_cleanse_euc_jp string_cleanse_shift_jis string_compare string_concat string_convert_explicit string_downcase 
syn keyword abBuiltInFunc string_filter string_filter_out string_from_hex string_han_to_zen_hiragana string_han_to_zen_katakana string_index 
syn keyword abBuiltInFunc string_is_alphabetic string_is_numeric string_join string_length string_like string_lpad 
syn keyword abBuiltInFunc string_lrepad string_lrtrim string_ltrim string_pad string_prefix string_repad 
syn keyword abBuiltInFunc string_replace string_replace_first string_rindex string_split string_split_no_empty string_substring 
syn keyword abBuiltInFunc string_split_quoted string_suffix string_to_hex string_trim string_truncate_explicit string_upcase 
syn keyword abBuiltInFunc test_characters_all test_characters_any to_json to_xml unicode_char_string url_decode_escapes 
syn keyword abBuiltInFunc url_encode_escapes 
"Date time functions
syn keyword abBuiltInFunc date_add_months date_day date_day_of_month date_day_of_week date_day_of_year date_difference_days 
syn keyword abBuiltInFunc date_difference_months date_month date_month_end date_to_int date_year datetime_add 
syn keyword abBuiltInFunc datetime_add_months datetime_change_zone datetime_day datetime_day_of_month datetime_day_of_week datetime_day_of_year 
syn keyword abBuiltInFunc datetime_difference datetime_difference_abs datetime_difference_days datetime_difference_hours datetime_difference_minutes datetime_difference_months 
syn keyword abBuiltInFunc datetime_difference_seconds datetime_from_390_tod datetime_from_unixtime datetime_hour datetime_microsecond datetime_minute 
syn keyword abBuiltInFunc datetime_month datetime_second datetime_to_unixtime datetime_year datetime_zone_offset decode_date 
syn keyword abBuiltInFunc decode_date_record decode_datetime decode_datetime_as_local encode_date encode_datetime encode_local_datetime 
syn keyword abBuiltInFunc local_now now now1 today today1 utc_now 

syn keyword abTodo contained TODO FIXME NOTE
syn match abLineComment "//.*$" contains=abTodo

syn region abComment   matchgroup=abCommentStart start="/\*" end="\*/" contains=cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell fold extend

syn region  abString   start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=abSpecial,@Spell extend
syn region  abString   start=+L\='+ skip=+\\\\\|\\'+ end=+'+ contains=abSpecial,@Spell extend

syn match  abUnionDef    "\[\s*union\>.*\]"
syn match  abRecordDef   "\[\s*record\>.*\]"
syn match  abVectorDef   "\[\s*vector\>.*\]"
syn match  abUnionTypeDecl   "\<\%(union\|end\)\>"
syn match  abRecordTypeDecl "\<\%(record\|end\)\>"
syn match  abVectorTypeDecl "\<\%(vector\|end\)\>"
syn match  abSwitchBlock     "\<\%(switch\|end\)\>"
syn match  abBlock      "\<\%(begin\|end\)\>"

" [vector val1, val2 ] [record field "val" ... ] ok
syn region abVectorVal  matchgroup=abVectorDef     start="\[\s*\<vector\>" end="\]"      contains=ALL fold 
syn region abUnionVal   matchgroup=abUnionDef      start="\[\s*\<union\>"  end="\]"      contains=ALL fold 
syn region abRecordVal  matchgroup=abRecordDef     start="\[\s*\<record\>" end="\]"      contains=ALL fold 
" 
syn region abVectorType  matchgroup=abVectorTypeDecl start="\<vector\>"    end="\<end\>" contains=ALL fold 
syn region abUnionType   matchgroup=abUnionTypeDecl  start="\<union\>"     end="\<end\>" contains=ALL fold 
syn region abRecordType  matchgroup=abRecordTypeDecl start="\<record\>"    end="\<end\>" contains=ALL  fold 
syn region abSwitch  matchgroup=abSwitchBlock   start="\<switch\>"      end="\<end\>"  contains=ALL fold 
syn region abBegEnd  matchgroup=abBlock         start="\<begin\>"       end="\<end\>"  contains=ALL fold 

syn sync fromstart

" highlight abKeywords guifg=blue
" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
if version >= 508 || !exists("did_abinitio_syntax_inits")
  if version < 508
    let did_abinitio_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink abTodo        Todo         
  HiLink abLineComment Comment      
  HiLink abComment     PreProc      
  HiLink abCommentStart PreProc      
  HiLink abKeyword    Keyword    
  HiLink abBlock       Type
  HiLink abSwitchBlock Statement 
  HiLink abUnionDef    Structure 
  HiLink abUnionTypeDecl   Type 
  HiLink abRecordDef   Structure 
  HiLink abRecordTypeDecl  Type 
  HiLink abVectorDef   Structure 
  HiLink abVectorTypeDecl  Type 
  HiLink abBuiltInFunc Function    
  HiLink abPort        Type
  HiLink abKeySpec     Identifier
  HiLink abVariable    Normal    
  HiLink abColumnName  Identifier    
  HiLink abLet         Statement    
  HiLink abNumber      Constant     
  HiLink abOperator    Operator     
  HiLink abAssignOp    Normal     
  HiLink abConditional Conditional
  HiLink abConstant    Constant
  HiLink abString      String       
  HiLink abRepeat      Repeat       
  HiLink abType        Type         
  HiLink abCodePage    Type         
  HiLink abInclude     Include      
  HiLink abSpecial     SpecialChar
  HiLink abAssignError Error
  delcommand HiLink
endif

let b:current_syntax = "abinitio"

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: ts=8
