# vim-delphi  

A VIM syntax plugin for Delphi Pascal and Delphi Form files.

See also [doc/delphi.txt](http://raw.github.com/mattia72/vim-delphi/master/doc/delphi.txt)
for detailed documentation.

##  Installation
Copy the included directories into your .vim or vimfiles directory.
The [tabular](http://github.com/godlygeek/tabular "Tabular") and the 
[neosnippet](http://github.com/Shougo/neosnippet.vim "Neosnippet") plugin is also
recommended, but not necessary.

### Plugin managers
It is recommended to use a plugin manager for Vim plugins.
If you prefer [vim-plug](https://github.com/junegunn/vim-plug "vim-plug") as
well, put this lines into your plugin list:
```
Plug 'Shougo/neosnippet'            
Plug 'godlygeek/tabular',           
Plug 'mattia72/vim-delphi' 
```
## Syntax highlight 
**.pas*, **.dfm* and **.fmx* files are recognized automatically:

![Screenshot](/../screenshot/screenshot.jpg?raw=true "Screenshot")

## Matchit support  
`b:match_words` contains matching words to jump between "begin" and "end" with `%`

## Indent (under construction! :construction:)
Indentation works well (in most cases :)) 
![Screenshot](/../screenshot/align.gif?raw=true "Aligning")

1. Select the lines you wan't to indent. (eg. with `V%` on a "begin" keyword)
2. Push `=`

## Tabular 
To format lines, that assigns values (contains `:=` ), we can use the 
famous [tabular](http://github.com/godlygeek/tabular) plugin.
[vim-delphi](http://github.com/mattia72/vim-delphi) maps the appropriate
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

