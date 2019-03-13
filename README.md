# vim-abinitio
A VIM syntax plugin for Ab Initio Data Manipulation Language.
##  Installation
Copy the included directories into your .vim or vimfiles directory.
The [tabular](http://github.com/godlygeek/tabular "Tabular") and the 
[neosnippet](http://github.com/Shougo/neosnippet.vim "Neosnippet") plugin is also
recommended, but not necessary.

### Dein
Or better to use a plugin manager, like
[dein](http://github.com/Shougo/dein.vim "Dein"). Put this lines in your
plugin list:
```
call dein#add('Shougo/neosnippet')      " Recommended  
call dein#add('godlygeek/tabular',     
      \{ 'on_cmd' : 'Tabularize' })     " Recommended 
call dein#add('mattia72/vim-abinitio' , 
      \{ 'on_ft': ['abinitio' ] }) 
```
So the plugin will loaded only if you open a *.dml file or call `set filetype=abinitio`.

### Neobundle
Another, but depricated aproach to use [neobundle](http://github.com/Shougo/neobundle.vim "Neobundle") 
simply put this line after your neobundle list in your .vimrc:
```
NeoBundleLazy 'mattia72/vim-abinitio'
```
then add this line in your auto commands section:
```
autocmd FileType abinitio NeoBundleSource vim-abinitio
```
So the plugin will loaded only if you open a *.dml file or call `set filetype=abinitio`.

## Syntax highlight
![Screenshot](/../screenshot/screenshot.png?raw=true "Screenshot")

## Matchit support
`b:match_words` contains matching words to jump between "begin" and "end" or
"record" and "end" with `%`

## Indent
Indentation works well (in most cases :)) 
![Screenshot](/../screenshot/align.gif?raw=true "Aligning")

1. Select the lines you wan't to indent. (eg. with `V%` on a "begin" keyword)
2. Push `=`

## Tabular
To format lines, that assigns values (contains `=` or `::`), we can use the 
famous [tabular](http://github.com/godlygeek/tabular) plugin.
[vim-abinitio] (http://github.com/mattia72/vim-abinitio) maps the appropriate
commands for you.
* `<leader>t=` helps you line up assignments by aligning the `=` on each line.
* `<leader>t:` helps you line up assignments by aligning the `::` on each line.

## Neosnippet support
For this feature you need to install [neosnippet](http://github.com/Shougo/neosnippet.vim "Neosnippet").

The snippet file should loaded automatically, if not, you can load it by:
```
:NeoSnippetSource <path_to_the_vim-abinitio_plugin>\snippets\abinitio.snip
```    
Then you can start type a snippet alias eg. `func`. 
* `C-k` selects and expands a snippet from the [neocomplcache](https://github.com/Shougo/neocomplcache.vim)/ [neocomplete](https://github.com/Shougo/neocomplete.vim) popup (Use `C-n` and `C-p` to select it). 
* `C-k` can be used to jump to the next field in the snippet.
* `Tab` to select the next field to fill in the snippet.

Available snippets are in the snippets directory. Feel free to extend them.

## How to use it from AbInitio GDE?
 1. Download the exe file from here: [AbInitioPlus](https://github.com/mattia72/autohotkey/blob/master/AbInitioPlus/win32/AbInitioPlus.exe "Exe")
 2. Start it!
 3. Open an editor in GDE.
 4. Push the corresponding [hotkey](https://github.com/mattia72/autohotkey/tree/master/AbInitioPlus#hotkeys "hotkeys")

## Thanks
* for the first inspiration: https://sites.google.com/site/abinitiobyte/
* for this indent script howto: http://psy.swansea.ac.uk/staff/Carter/Vim/vim_indent.htm

