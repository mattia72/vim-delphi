# vim-delphi  

A VIM syntax plugin for Delphi Pascal and Delphi Form files.

See also [doc/delphi.txt](http://raw.github.com/mattia72/vim-delphi/master/doc/delphi.txt)
for detailed documentation.

##  Installation
It is recommended to use a plugin manager for Vim plugins.
If you prefer [vim-plug](https://github.com/junegunn/vim-plug "vim-plug") as
well, put this lines into your plugin list:
```
Plug 'skywind3000/asyncrun.vim'  " For async make 
Plug 'Shougo/neosnippet'         " For snippet support   
Plug 'godlygeek/tabular',        " For aligning    
Plug 'mattia72/vim-delphi' 
```
## Syntax highlight 
**.pas*, **.dfm* and **.fmx* files are recognized automatically:

![Screenshot](/../screenshot/screenshot.jpg?raw=true "Screenshot")

## Commands

The following commands are defined:
* :**DelphiMake** [{project}] <br>
                              searches {project} in the path and calls 
                              :make! /p:config=|g:delphi_build_config| {project}
                              without argument, it tries to find a *.dproj
                              file in the current directory and then upwards
                              It works async if |skywind3000/asyncrun.vim|
                              is installed.
* :**DelphiMakeRecent** [{project}] <br>
                              same as DelphiMake, but full path of the given 
                              {project} will be stored in the variable 
                              |g:delphi_recent_project|.
                              Without any argument |g:delphi_recent_project|
                              will be built. On first run the project name will
                              be asked, then searched in the |path|.
                              It works async if |skywind3000/asyncrun.vim|
                              is installed.
* :**DelphiBuildConfig** [{config}] <br>Debug or Release
* :**DelphiOpenInDevEnv** [{file}]  <br>
                              Opens a file in the default external pascal editor. It is usually the Delphi Develpment Environment. Without argument, the current file is used.
* :**DelphiSwitchToDfm** or :**DelphiSwitchToPas** <br>
                              Switch between dfm and pas files. 
                              Note: Both command works with dfm and pas files too.

## Mappings

The plugin provides some useful mapping definition also. 

Common mappings for *.dfm and *.pas files (defined in ftplugin/common.vim):
                                                                               
    <leader>sd      Switch to *.dfm  
    <leader>sp      Switch to *.pas
    <F12>           Switch between *dfm and *.pas

Mappings for *.pas files only (defined in plugin/delphi.vim):
                                                                               
    vif             Select all in a block (works only if *foldmethod* is 'syntax')   
    vaf             Select a whole block  (works only if *foldmethod* is 'syntax')
    <F7>            Save all and make 

Edit helpers for *.pas files
                                                                               
    <leader>t=      Align selected assignes in nice columns with Tabularize 
    <leader>t:      Align selected declarations in nice columns with Tabularize 
    <leader>dt      Retab current line or selection
    <leader>d;      Put ';' to the end of line

Jumpings in *.pas files
                                                                               
    <leader>dU      Jump to the first 'uses' clause in file
    <leader>du      Jump to the second 'uses' clause in file
    <leader>di      Jump to the 'implementation' section
    <leader>df      Jump to the 'interface' section 
    <leader>dv      Jump to the previous 'var' section 
    <leader>db      Jump to the previous 'begin' 
    <leader>de      Jump to the next 'end' 

## Matchit support  
`b:match_words` contains matching words to jump between words with `%`.

Such words are, eg. 
* "begin", "end"
* "repeat", "until"
* "try", "finally"
* "unit", "interface", "implementation", "end."

and so on.

## Menu
![Screenshot](/../screenshot/vim-delphi-menu.png?raw=true "Aligning")

## Indent (under construction! :construction:)
Indentation works well (in most cases :)) 
![Screenshot](/../screenshot/align.gif?raw=true "Aligning")

1. Select the lines you wan't to indent. (eg. with `V%` on a "begin" keyword)
2. Push `=`

## Tabular 
To format lines, that assigns values like this: `variable := value;`, we can use the 
[tabular](http://github.com/godlygeek/tabular) plugin.  [vim-delphi](http://github.com/mattia72/vim-delphi) maps the appropriate
commands for you.
* `<leader>t=` helps you line up assignments by aligning to `:=` on each line.
* `<leader>t:` helps you line up declarations by aligning to `:` on each line.

## Neosnippet support
For this feature you need to install [neosnippet](http://github.com/Shougo/neosnippet.vim "Neosnippet").

The snippet file should loaded automatically, if not, you can load it by:
```
:NeoSnippetSource <path_to_the_vim-delphi_plugin>\snippets\delphi.snip
```    
Then you can start type a snippet alias eg. `func`. 
* `C-k` selects and expands a snippet from the [neocomplcache](https://github.com/Shougo/neocomplcache.vim)/ [neocomplete](https://github.com/Shougo/neocomplete.vim) popup (Use `C-n` and `C-p` to select it). 
* `C-k` can be used to jump to the next field in the snippet.
* `Tab` to select the next field to fill in the snippet.

Available snippets are in the snippets directory. Feel free to extend them.

## Thanks
* for this indent script howto: http://psy.swansea.ac.uk/staff/Carter/Vim/vim_indent.htm

