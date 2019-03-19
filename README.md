# vim-delphi  (under construction) 

**This plugin is under development! Don't use it, unless you know what you do!**

A VIM syntax plugin for Delphi Pascal the primary programming language of
Delphi IDE.

##  Installation
Copy the included directories into your .vim or vimfiles directory.
The [tabular](http://github.com/godlygeek/tabular "Tabular") and the 
[neosnippet](http://github.com/Shougo/neosnippet.vim "Neosnippet") plugin is also
recommended, but not necessary.

### Plugin managers
It is recommended to use a popular plugin manager for Vim plugins.

#### Dein
If you prefer [dein](http://github.com/Shougo/dein.vim "Dein"). Put this lines in your
plugin list:
```
call dein#add('Shougo/neosnippet')      " Recommended  
call dein#add('godlygeek/tabular',     
      \{ 'on_cmd' : 'Tabularize' })     " Recommended 
call dein#add('mattia72/vim-delphi' , 
      \{ 'on_ft': ['delphi' ] }) 
```

#### Plug
If you prefer [vim-plug](http://github.com/Shougo/dein.vim "vim-plug"). Put this lines in your
plugin list:
```
Plug 'Shougo/neosnippet'            " Recommended  
Plug 'godlygeek/tabular',     
      \{ 'on' : 'Tabularize' })     " Recommended 
call dein#add('mattia72/vim-delphi', 
      \{ 'for': ['delphi' ] }) 
```
## Syntax highlight (under construction)
![Screenshot](/../screenshot/screenshot.png?raw=true "Screenshot")

## Matchit support  (under construction)
`b:match_words` contains matching words to jump between "begin" and "end" with `%`

## Indent (under construction)
Indentation works well (in most cases :)) 
![Screenshot](/../screenshot/align.gif?raw=true "Aligning")

1. Select the lines you wan't to indent. (eg. with `V%` on a "begin" keyword)
2. Push `=`

## Tabular (under construction)
To format lines, that assigns values (contains `:=` ), we can use the 
famous [tabular](http://github.com/godlygeek/tabular) plugin.
[vim-delphi] (http://github.com/mattia72/vim-delphi) maps the appropriate
commands for you.
* `<leader>t=` helps you line up assignments by aligning the `:=` on each line.
* `<leader>t:` helps you line up assignments by aligning the `:=` on each line.

## Neosnippet support (under construction)
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

