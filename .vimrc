syntax on
set number
au BufRead,BufNewFile *.rs setfiletype rust
autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.c setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.cpp setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.h setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile Makefile setlocal shiftwidth=4 tabstop=4
autocmd BufRead,BufNewFile *.md setlocal formatoptions+=t tw=80
set cc=80
set shiftwidth=4
set tabstop=4
set ai

colorscheme seoul256
