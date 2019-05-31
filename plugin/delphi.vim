"=============================================================================
" File:          delphi.vim
" Author:        Mattia72 
" Description:   plugin definitions
" Created:       16.03.2019
" Project Repo:  https://github.com/Mattia72/delphi
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

scriptencoding utf-8

" Preprocessing
if exists('g:loaded_vim_delphi')
  finish
elseif v:version < 700
  echoerr 'vim-delphi does not work this version of Vim "' . v:version . '".'
  finish
endif

let g:loaded_vim_delphi = 1

let s:save_cpo = &cpo
set cpo&vim

" ----------------------
" Global options 
" ----------------------

set mouse=a     "Enables mouse click

let delphi_space_errors = 1
let delphi_leading_space_error = 1
"let  delphi_leading_tab_error = 1
let delphi_trailing_space_error = 1
let delphi_highlight_function_parameters = 1

let g:delphi_build_config = 'Debug'

" ----------------------
" Functions
" ----------------------

function! g:delphi#SwitchPasOrDfm()
  if (expand ("%:e") == "pas")
    find %:t:r.dfm
  else
    find %:t:r.pas
  endif
endfunction

function! g:delphi#HighlightMsBuildOutput()
	let qf_cmd = getqflist({'title' : 1})['title']
	if (qf_cmd =~ 'rsvars\" && msbuild')
	  match none
    match Special '\<\(_PasCoreCompile\|Delphi\)\>'
    2match Error " \zs\w\+ \([EF]\d\{4}\|[Ee]rror\)\ze:" 
    3match Warning " \zs\w\+ [WH]\d\{4}\ze:" 
  endif
endfunction

function! g:delphi#FindProject(...)
  let active_file_dir = expand('%:p:h')
  let project_file = ''
  let project_name = '*.dproj'

  if a:0 != 0 && !empty(a:1)
    let project_name = a:1
  endif

  "echom ''.project_name
  "
  if project_name =~ '^*'
    " let project_name = '*.dproj'
    let cwd_orig = getcwd()
    while getcwd() !~ '^[A-Z]:\\$'
      echom 'Search upwards in '.getcwd()
      let project_file = globpath('.', project_name)
      if !empty(project_file) 
        let project_file = fnamemodify(project_file,':p' )
        break 
      else 
        chdir .. 
      endif
    endwhile
    execute 'chdir '.cwd_orig
  else
    "echom 'Search '.project_name.' in path '.&path
    " find file in set path +=...
    " faster if we are in the dir
    let project_file = findfile(project_name)
  endif
  redraw
	echohl ModeMsg | echo 'Project found: '.project_file | echohl None
  if filereadable(project_file) | return project_file | else | return '' | endif
endfunction

function! g:delphi#SearchAndSaveRecentProjectFullPath(project_name)
  "echom a:project_name

  if filereadable(a:project_name)
    let project_path = a:project_name
  else
    let project_path = findfile(a:project_name)
  endif

  if filereadable(project_path)
    let g:delphi_recent_project = fnamemodify(project_path,':p')
  endif
endfunction

function! g:delphi#SetRecentProject(...)
  let g:delphi_recent_project = ''
  let project_name = ''

  if a:0 != 0 && !empty(a:1)
    let project_name = a:1
  else
    call inputsave()
    let project_name = input('Enter project name (*.dproj, *.groupproj): ', '', 'file_in_path') 
    call inputrestore()
  endif
  "echom project_name
  call delphi#SearchAndSaveRecentProjectFullPath(project_name)

  if empty(g:delphi_recent_project)
    redraw
	  echohl ErrorMsg |  echom 'Can''t find project "'.project_name.'". Set path or g:delphi_project_path and try again!' | echohl None
		"unlet g:delphi_recent_project
  endif
  redraw
endfunction

function! g:delphi#FindAndMake(...)
  if a:0 != 0 && !empty(a:1)
    let project_name =  a:1
  else
    let project_name = '*.dproj'
  endif

  let project_file = delphi#FindProject(project_name)

  "echom 'FindAndMake args: '.a:0.' "'.project_name.'" found: '.project_file
  if !empty(project_file) 
	  echohl ModeMsg | echo 'Make '.project_file | echohl None
    execute 'make! /p:config='.g:delphi_build_config.' '.project_file 
  else  
	  echohl ErrorMsg | redraw | echom 'Can''t find project "'.project_name.'"' | echohl None
  endif
endfunction

function! g:delphi#HandleRecentProject(...)
  if a:0 != 0 && !empty(a:1)
    "echom 'set recent '.a:1
    call delphi#SetRecentProject(a:1) 
    "echom 'recent '.g:delphi_recent_project
  else
    if !exists('g:delphi_recent_project') || !filereadable(g:delphi_recent_project)
      call delphi#SetRecentProject() 
    endif                    
  endif
endfunction

function! g:delphi#SetRecentProjectAndMake(...)
  if a:0 != 0 && !empty(a:1)
    call delphi#HandleRecentProject(a:1)
  endif                    

  if exists('g:delphi_recent_project') && filereadable(g:delphi_recent_project)
    call delphi#FindAndMake(g:delphi_recent_project)
  else
    redraw
		echohl ErrorMsg | echom 'Project not found or g:delphi_recent_project is not defined properly.' | echohl None
  endif
endfunction

function! g:delphi#SetBuildConfig(config)
  if a:0 != 0 && !empty(a:1)
    let g:delphi_build_config = a:config
  endif
	echohl ModeMsg | echo 'Build config: '.g:delphi_build_config | echohl None
endfunction

function! g:delphi#SetQuickFixWindowProperties()
  "echom 'Set properties'
  set nocursorcolumn cursorline
  " highlight errors in reopened qf window
  call delphi#HighlightMsBuildOutput()
endfunction

" Retab the indent of a file - ie only the first nonspace.
" Tab: Optional argument specified the value of the new tabstops
" Bang: (!) causes trailing whitespace to be gobbled.
" Orig: https://github.com/vim-scripts/Smart-Tabs/blob/master/plugin/ctab.vim
fun! g:delphi#RetabIndent( bang, firstl, lastl, tab )
  let checkspace=((!&expandtab)? "^\<tab>* ": "^ *\<tab>")
  let l = a:firstl
  let force= a:tab != '' && a:tab != 0 && (a:tab != &tabstop)
  "let checkalign = ( &expandtab || !(&autoindent || &indentexpr || &cindent)) 
  let newtabstop = (force?(a:tab):(&tabstop))
  while l <= a:lastl
    let txt=getline(l)
    let store=0
    if a:bang == '!' && txt =~ '\s\+$'
      let txt=substitute(txt,'\s\+$','','')
      let store=1
    endif
    if force || txt =~ checkspace
      let i=indent(l)
      let tabs= (&expandtab ? (0) : (i / newtabstop))
      let spaces=(&expandtab ? (i) : (i % newtabstop))
      let txtindent=repeat("\<tab>",tabs).repeat(' ',spaces)
      let store = 1
      let txt=substitute(txt,'^\s*',txtindent,'')
    endif
    if store
      call setline(l, txt )
      "if checkalign
        "call s:CheckAlign(l)
      "endif
    endif

    let l=l+1
  endwhile
  if newtabstop != &tabstop | let &tabstop = newtabstop | endif
endfun

" ----------------------
" Autocommands
" ----------------------

augroup delphi_vim_global_command_group
  autocmd!
  "autocmd FileType qf call delphi#SetQuickFixWindowProperties() 
  "autocmd QuickFixCmdPre make call delphi#HighlightMsBuildOutput()
  autocmd QuickFixCmdPost make copen 8 | wincmd J | call delphi#SetQuickFixWindowProperties() 
  " close with q or esc
  autocmd FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
  autocmd FileType qf nnoremap <buffer><silent> q :cclose<bar>lclose<CR>

  autocmd FileType delphi call DefineCommands()
  autocmd FileType delphi call DefineMappings()
  autocmd FileType delphi call BuildPluginMenus()
augroup END

" ----------------------
" Commands
" ----------------------
 
function! DefineCommands()
  " Retab spaced range, but only indentation
  command! -range -nargs=? -bang -bar RetabIndent call delphi#RetabIndent(<q-bang>, <line1>, <line2>, <q-args>)

  command! -nargs=0 -bar DelphiSwitchToDfm call delphi#SwitchPasOrDfm()
  command! -nargs=0 -bar DelphiSwitchToPas call delphi#SwitchPasOrDfm()

  if (exists(':AsyncRun'))
    command! -bang -bar -nargs=? -complete=file_in_path DelphiMakeRecentAsync
	        \ call delphi#HandleRecentProject(<f-args>) 
	        \| execute 'AsyncRun'.<bang>.' -post=call\ delphi\#HighlightMsBuildOutput() -auto=make -program=make @ /p:config='.g:delphi_build_config.' '.g:delphi_recent_project  

    command! -bang -bar -nargs=? -complete=file_in_path DelphiMakeAsync
	        \ execute 'AsyncRun'.<bang>.' -post=call\ delphi\#HighlightMsBuildOutput() -auto=make -program=make @ /p:config='.g:delphi_build_config.' '.delphi#FindProject(<f-args>) 
  endif

  command! -nargs=? -bar -complete=file_in_path DelphiMakeRecent 
        \ call delphi#SetRecentProjectAndMake(<f-args>)
  command! -nargs=? -bar -complete=file_in_path DelphiMake 
        \ call delphi#FindAndMake(<q-args>)
  command! -nargs=? DelphiBuildConfig call delphi#SetBuildConfig(<q-args>)
endfunction

" ----------------------
" Mappings
" ----------------------

function! DefineMappings()

  " highlight selcted word
  nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>
  " Save & Build
  nnoremap <buffer> <F7> :wa <bar> DelphiMakeRecentAsync <CR>
  nnoremap <buffer> <F12> :DelphiSwitchToDfm <CR>
  "change trailing spaces to tabs
  vnoremap <buffer> <leader>tt :RetabIndent<CR>
  nnoremap <buffer> <leader>tt :RetabIndent<CR>

  if &foldmethod=='syntax'
    " select inside a begin-end block with vif or vaf
    vnoremap af :<C-U>silent! normal! [zV]z<CR>
    vnoremap if :<C-U>silent! normal! [zjV]zk<CR>
    omap af :normal Vaf<CR>
    omap if :normal Vif<CR>
  endif

  "FIXME read tabularize.doc for extension
  if exists(':Tabularize') " Align selected assignes in nice columns with plugin
    vnoremap <leader>t= :Tabularize /:=<CR>
    vnoremap <leader>t: :Tabularize /:<CR>
  endif

  if exists(':RainbowToggle')
    let delphi_rainbow_conf = {
	        \	'separately': {
	        \		'delphi': {
	        \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/begin/ end=/end/'],
	        \		},
	        \	}
	        \}
    if exists('g:rainbow_conf')
	    call extend(g:rainbow_conf, delphi_rainbow_conf)
	  else
	    let g:rainbow_conf = delphi_rainbow_conf
	  endif
  endif
endfunction

" ----------------------
" Menus
" ----------------------

function! s:CreateMenu(mode, title, map, cmd)
  " mode: a,v,i ... for amenu, vmenu etc...
  " title: menu title
  " map : shortcut
  " cmd : command 
  let menu_root = "&Plugin.&Delphi"
  let menu_command = a:mode . 'menu <silent> ' . menu_root . '.' . escape(a:title, ' ')
  if strlen(a:map)
    let menu_command .= '<Tab>'
    if(a:map =~ '^<leader>')
      let leader = exists('g:mapleader') ? g:mapleader : '\'
      let menu_command .= escape( substitute(a:map, '<leader>', leader, ''),'\' )
    else
      let menu_command .= a:map
    endif
  endif
  let menu_command .= ' ' . a:cmd
  execute menu_command
endfunction

function! BuildPluginMenus()
  "let b:browsefilter = "Delphi projects\t*.dproj\nDelphi group projects\t*.groupproj\n"
  if exists(':Tabularize') " Align selected assignes in nice columns with plugin
    call s:CreateMenu('v', "Align &assignments" , "<leader>t=", ":Tabularize /:=<CR>")
    call s:CreateMenu('v', "Align &declarations", "<leader>t:", ":Tabularize /:<CR>")
    call s:CreateMenu('a', "Retab &indent"      , "<leader>tt"        , ":RetabIndent")
    call s:CreateMenu('a', "-Separator1-"       , ""          , ":")
  endif

  if exists(':RainbowToggle')
    call s:CreateMenu('a', "Highlight parentheses", "", ":RainbowToggle")
    call s:CreateMenu('a', "-Separator2-"         , "", ":")
  endif

  if &foldmethod=='syntax'
    call s:CreateMenu('a', "Select all in &block", "vif", "vif")
    call s:CreateMenu('a', "Select whole block"  , "vaf", "vaf")
    call s:CreateMenu('a', "-Separator3-"        , ""   , ":")
  endif

  call s:CreateMenu('a', "Make a &project (Async)"     , ":DelphiMakeAsync"      , ":DelphiMakeAsync<CR>")
  call s:CreateMenu('a', "Make &recent project (Async)", ":DelphiMakeRecentAsync", ":DelphiMakeRecentAsync<CR>")
  call s:CreateMenu('a', "-Separator4-"                , ""                      , ":")

  call s:CreateMenu('a', "Make a &project"             , ":DelphiMake"           , ":DelphiMake<CR>")
  call s:CreateMenu('a', "Make recent pro&ject"        , ":DelphiMakeRecent"     , ":DelphiMakeRecent<CR>")
  call s:CreateMenu('a', "-Separator5-"                , ""                      , ":")

  call s:CreateMenu('a', "&View build config"          , ":DelphiBuildConfig"     , ":DelphiBuildConfig<CR>")
  call s:CreateMenu('a', "&Save all && Build"          , "F7"                     , ":wa <bar> DelphiMakeRecentAsync <CR>")
  call s:CreateMenu('a', "-Separator6-"                , ""                       , ":")
  call s:CreateMenu('a', "Switch between pas/dfm"      , "F12"                    , ":DelphiSwitchToDfm<CR>")
endfunc

let &cpo = s:save_cpo
unlet s:save_cpo

