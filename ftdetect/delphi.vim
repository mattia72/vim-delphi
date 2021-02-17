" Vim ftdetect plugin file
" Language:           Delphi
" Maintainer:         mattia72
" Version:            1.0
" Project Repository: https://github.com/mattia72/vim-delphi

augroup delphi_ftdetect
  "autocmd! 
  "autocmd! BufNewFile,BufRead *.pas,*.dpr,*.dpk,*.inc
  autocmd BufNewFile,BufRead *.pas,*.dpr,*.dpk,*.inc set ft=delphi
  autocmd FileType delphi compiler delphi
augroup END
