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
let delphi_highlight_uppercase_consts = 1
let delphi_highlight_field_names = 1
let delphi_highlight_hungarian_notated_variables = 1

let g:delphi_build_config = 'Debug'

" ----------------------
" Functions
" ----------------------

function delphi#OpenInDevEnv(...)
  if a:0 != 0 && !empty(a:1)
    let filepath = a:1
  else
    let filepath = expand("%")
  endif                    

  let file_extension = fnamemodify(filepath,":e") 
  let extension_supported = file_extension =~? '\v(pas|dfm|dproj)'
  if (extension_supported)
    call system(filepath)
	  echohl ModeMsg |  echom 'vim-delphi: '.fnamemodify(filepath,":t").' opened in external editor.' | echohl None
  endif
endfunction

function! g:delphi#SwitchPasOrDfm()
  let file_name_without_extension = expand('%:t:r')
  if (expand ("%:e") == "pas")
    let switch_file = file_name_without_extension.'.dfm'
  else
    let switch_file = file_name_without_extension.'.pas'
  endif

  if (findfile(switch_file) != '')
    execute 'silent! find '.switch_file
  else
	  echohl ErrorMsg |  echom 'vim-delphi: Can''t find "'.switch_file.'" in path' | echohl None
  endif
endfunction

function! g:delphi#CDProjectDir()
  if exists('g:delphi_recent_project') && filereadable(g:delphi_recent_project)
    let cmd = 'chdir '.fnamemodify(g:delphi_recent_project,':p:h')  
    echom cmd
    execute cmd
  endif
endfunction

function! g:delphi#PostBuildSteps()
  " highlight errors
	let qf_cmd = getqflist({'title' : 1})['title']
	if (qf_cmd =~ 'rsvars\" && msbuild')
	  match none
    match Special '\<\(_PasCoreCompile\|Delphi\)\>'
    2match Error " \zs\w\+ \([EF]\d\{4}\|[Ee]rror\)\ze:" 
    3match Warning " \zs\w\+ [WH]\d\{4}\ze:" 
  endif

  call delphi#GoToFirstValidErrorLineInQuickfix()
endfunction

" Not used yet, but sometimes it may be usefull...
function! g:delphi#CorrectQfDirectory()
  let qf_valid_entries = filter(getqflist(), 'v:val.valid')
  if (len(qf_valid_entries) > 0 )
    echom 'qf first bufnr: '.qf_valid_entries[0].bufnr
    if qf_valid_entries[0].bufnr && !filereadable(bufname(qf_valid_entries[0].bufnr))
      echom 'Valid but not readable: '.qf_valid_entries[0].bufnr
      call delphi#CDProjectDir()
    endif
  endif
endfunction

function! g:delphi#GoToFirstValidErrorLineInQuickfix()
  let first_valid_line_nr = 1
  let valid_found = 0
  for item in getqflist() 
    if (item.valid == 1)
      let valid_found = 1
      if item.bufnr && !filereadable(bufname(item.bufnr))
        echom 'Valid but not readable: '. item.bufnr
        call delphi#CDProjectDir()
      endif
      break
    endif
    let first_valid_line_nr += 1
  endfor
  let msg = 'vim-delphi: '
  " go to the first valid line or last line
  if (valid_found == 1)
    let msg .= 'Build failed.'
    execute 'copen | '.first_valid_line_nr
  else
    let msg .= 'Build succeeded.'
    execute 'copen | normal! G'
  endif
	echohl ModeMsg | echo msg | echohl None
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
      "echom 'Search upwards in '.getcwd()
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
	echohl ModeMsg | echo 'vim-delphi: Project found: '.project_file | echohl None
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
	  echohl ErrorMsg |  echom 'vim-delphi: Can''t find project "'.project_name.'". Set path or g:delphi_project_path and try again!' | echohl None
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
	  echohl ModeMsg | echo 'vim-delphi: Make '.project_file | echohl None
    execute 'make! /p:config='.g:delphi_build_config.' '.project_file 
  else  
	  echohl ErrorMsg | redraw | echom 'vim-delphi: Can''t find project "'.project_name.'"' | echohl None
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
		echohl ErrorMsg | echom 'vim-delphi: Project not found or g:delphi_recent_project is not defined properly.' | echohl None
  endif
endfunction

function! g:delphi#SetBuildConfig(config)
  if a:0 != 0 && !empty(a:1)
    let g:delphi_build_config = a:config
  endif
	echohl ModeMsg | echo 'vim-delphi: Build config: '.g:delphi_build_config | echohl None
endfunction

function! g:delphi#PostOpenQuickfix()
  "echom 'Set properties'
  set nocursorcolumn cursorline
  " highlight errors in reopened qf window
  call delphi#PostBuildSteps()
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
  autocmd QuickFixCmdPost make copen 8 | wincmd J | call delphi#PostOpenQuickfix() 
  " close with q or esc
  autocmd FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
  autocmd FileType qf if mapcheck('q', 'n') ==# '' | nnoremap <buffer><silent> q :cclose<bar>lclose<CR>

  autocmd FileType delphi call DefineCommands()
  autocmd FileType delphi call DefineMappings()
  autocmd FileType delphi call SetPlugins()
  autocmd FileType delphi call BuildGuiMenus()

  autocmd FileType dfm call DefineCommands()
  autocmd FileType dfm nnoremap <buffer> <F12> :DelphiSwitchToDfm <CR>
  autocmd FileType dfm nnoremap <buffer> <F2>  :DelphiOpenInDevEnv <CR>
augroup END

" ----------------------
" Commands
" ----------------------
 
function! DefineCommands()
  " Retab spaced range, but only indentation
  command! -range -nargs=? -bang -bar RetabIndent call delphi#RetabIndent(<q-bang>, <line1>, <line2>, <q-args>)

  command! -nargs=0 -bar DelphiSwitchToDfm call delphi#SwitchPasOrDfm()
  command! -nargs=0 -bar DelphiSwitchToPas call delphi#SwitchPasOrDfm()
  command! -nargs=? -bar -complete=file_in_path DelphiOpenInDevEnv 
        \ call delphi#OpenInDevEnv(<f-args>)

  if (exists(':AsyncRun'))
    command! -bang -bar -nargs=? -complete=file_in_path DelphiMakeRecent
	        \ call delphi#HandleRecentProject(<f-args>) 
	        \| execute 'AsyncRun'.<bang>.' -post=call\ delphi\#PostBuildSteps() -auto=make -program=make @ /p:config='.g:delphi_build_config.' '.g:delphi_recent_project  

    command! -bang -bar -nargs=? -complete=file_in_path DelphiMake
	        \ execute 'AsyncRun'.<bang>.' -post=call\ delphi\#PostBuildSteps() -auto=make -program=make @ /p:config='.g:delphi_build_config.' '.delphi#FindProject(<f-args>) 
  else
    command! -nargs=? -bar -complete=file_in_path DelphiMakeRecent 
          \ call delphi#SetRecentProjectAndMake(<f-args>)
    command! -nargs=? -bar -complete=file_in_path DelphiMake 
          \ call delphi#FindAndMake(<q-args>)
  endif

  command! -nargs=? DelphiBuildConfig call delphi#SetBuildConfig(<q-args>)
endfunction

" ----------------------
" Mappings
" ----------------------

function! DefineMappings()

  " highlight selcted word
  nnoremap <buffer> <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>
  " Save & Build
  nnoremap <buffer> <F7> :wa <bar> DelphiMakeRecent<CR>
  inoremap <buffer> <F7> <esc>:wa <bar> DelphiMakeRecent<CR>
  " switch to dfm
  nnoremap <buffer> <F12> :DelphiSwitchToDfm <CR>
  nnoremap <buffer> <F2>  :DelphiOpenInDevEnv <CR>
  "change trailing spaces to tabs or vice versa
  vnoremap <buffer> <leader>dt :RetabIndent<CR>
  nnoremap <buffer> <leader>dt :RetabIndent<CR>
  " put ; to the end of line
  nnoremap <buffer> <leader>d; :s/$/;/<CR>:noh<CR>

  " jumpings
  nnoremap <buffer> <leader>dU gg:/^\s*\<uses\><CR>:noh<CR>
  nnoremap <buffer> <leader>du gg:/^\s*\<uses\><CR>n:noh<CR>
  nnoremap <buffer> <leader>df gg:/^\s*\<interfaces\><CR>:noh<CR>
  nnoremap <buffer> <leader>di gg:/^\s*\<implementation\><CR>:noh<CR>
  nnoremap <buffer> <leader>dv ?^\s*\<var\><CR>:noh<CR>
  nnoremap <buffer> <leader>db ?^\s*\<begin\><CR>:noh<CR>
  nnoremap <buffer> <leader>de /^\s*\<end\><CR>:noh<CR>
  nnoremap <buffer> <leader>dP ?^\s*\(\<class\>\s*\)\?\zs\(\<\(procedure\\|function\)\>\)\ze.*;<CR>
  nnoremap <buffer> <leader>dp /^\s*\(\<class\>\s*\)\?\zs\(\<\(procedure\\|function\)\>\)\ze.*;<CR>

  if &foldmethod=='syntax'
    " select inside a begin-end block with vif or vaf
    vnoremap <buffer> af :<C-U>silent! normal! [zV]z<CR>
    vnoremap <buffer> if :<C-U>silent! normal! [zjV]zk<CR>
    omap <buffer> af :normal Vaf<CR>
    omap <buffer> if :normal Vif<CR>
  endif

  "FIXME read tabularize.doc for extension
  if exists(':Tabularize') " Align selected assignes in nice columns with plugin
    vnoremap <buffer> <leader>t= :Tabularize /:=<CR>
    vnoremap <buffer> <leader>t: :Tabularize /:<CR>
  endif

endfunction

" ----------------------
" Other Plugins
" ----------------------
 
function! SetPlugins()
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

function! BuildGuiMenus()
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

  if (exists(':AsyncRun'))
    call s:CreateMenu('a', "Make &project (Async)"     , ":DelphiMake"      , ":DelphiMake<CR>")
    call s:CreateMenu('a', "Make &recent project (Async)", ":DelphiMakeRecent", ":DelphiMakeRecent<CR>")
  else
    call s:CreateMenu('a', "Make &project"             , ":DelphiMake"           , ":DelphiMake<CR>")
    call s:CreateMenu('a', "Make recent pro&ject"      , ":DelphiMakeRecent"     , ":DelphiMakeRecent<CR>")
  endif
  call s:CreateMenu('a', "-Separator4-"                , ""                      , ":")

  call s:CreateMenu('a', "&View build config"          , ":DelphiBuildConfig"     , ":DelphiBuildConfig<CR>")
  call s:CreateMenu('a', "&Save all && Build"          , "F7"                     , ":wa <bar> DelphiMakeRecent<CR>")
  call s:CreateMenu('a', "-Separator5-"                , ""                       , ":")
  call s:CreateMenu('a', "Switch between pas/dfm"      , "F12"                    , ":DelphiSwitchToDfm<CR>")
  call s:CreateMenu('a', "Open in Delphi Dev Env"      , "F2"                     , ":DelphiOpenInDevEnv<CR>")
endfunc

let &cpo = s:save_cpo
unlet s:save_cpo

