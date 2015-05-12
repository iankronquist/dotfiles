" This is a comment
syntax on
set number
au BufRead,BufNewFile *.rs setfiletype rust

" Tab settings for various languages
autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.c setlocal shiftwidth=4 tabstop=8 expandtab
autocmd BufRead,BufNewFile *.js setlocal shiftwidth=2 tabstop=2 expandtab
autocmd BufRead,BufNewFile *.ts setlocal shiftwidth=2 tabstop=2 expandtab syntax=javascript
autocmd BufRead,BufNewFile *.json setlocal shiftwidth=2 tabstop=2 expandtab syntax=javascript
autocmd BufRead,BufNewFile *.cpp setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.h setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile Makefile setlocal shiftwidth=4 tabstop=4
autocmd BufRead,BufNewFile *yml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd BufRead,BufNewFile *rb setlocal shiftwidth=2 tabstop=2 expandtab
" TODO: add actual golang syntax, don't just set the syntax to be like c
autocmd BufRead,BufNewFile *.go setlocal shiftwidth=4 tabstop=4 syntax=c

" Human readable files which typically contain prose
autocmd BufRead,BufNewFile *.md setlocal formatoptions+=t tw=79 syntax=markdown spell
autocmd BufRead,BufNewFile *.rst setlocal formatoptions+=t tw=79 spell
autocmd BufRead,BufNewFile *.tex setlocal formatoptions+=t tw=79 spell
autocmd BufRead,BufNewFile *.txt setlocal formatoptions+=t tw=79 spell

" The file where git commit messages are stored while they're being edited
autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t tw=79 spell

" Default settings for anything else
set cc=80
set shiftwidth=4
set tabstop=4
set ai
set hlsearch

" line numbers toggle
nma <leader>n :set invnumber<CR>
" wrapping toggle
nma <leader>w :set wrap!<CR>
" remove search highlights
nma <leader>h :noh<CR>

colorscheme seoul256
autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell

set list listchars=tab:→\ ,trail:·
