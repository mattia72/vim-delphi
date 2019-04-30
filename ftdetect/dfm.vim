" Vim ftdetect plugin file
" Language:           Delphi
" Maintainer:         mattia72
" Version:            1.0
" Project Repository: https://github.com/mattia72/vim-delphi

autocmd BufNewFile,BufRead *.dfm,*.fmx set ft=dfm
autocmd FileType dfm compiler delphi
