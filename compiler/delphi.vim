" Vim compiler file
" Compiler    : Delphi pascal
" Maintainer  : mattia72
" Last Change : 30.04.2019 

if exists("current_compiler")
  finish
endif
let current_compiler = "delphi"

let s:keepcpo= &cpo
set cpo&vim

" if makeprg settings fails with "unknown option...", set isfname& could help...
let s:keepisfname = &isfname
set isfname&

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

"https://flukus.github.io/vim-errorformat-demystified.html
"error with line number
CompilerSet  errorformat=%f(%l):\ %m
"error with line number and column
CompilerSet errorformat+=%f(%l\\,%c):\ %m

let s:rsvars_path = expand('$BDS') 
if s:rsvars_path == '$BDS'
  let s:rsvars_path = 'rsvars'
else
  let s:rsvars_path .= '/bin/rsvars'
endif

let s:makeprg_cmd = '"'.s:rsvars_path.'" && msbuild /nologo /v:m /property:GenerateFullPaths=true'
execute 'CompilerSet makeprg='.escape(s:makeprg_cmd, ' "\')
"echom "Set makeprg? ".&makeprg 
unlet s:makeprg_cmd
unlet s:rsvars_path

let &isfname = s:keepisfname
unlet s:keepisfname

let &cpo = s:keepcpo
unlet s:keepcpo
