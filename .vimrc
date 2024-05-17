" This is a comment
set spell
syntax on
set ignorecase
set smartcase
"set mouse=a
set number
set clipboard+=unnamed

" AUDIT should be highlighted
" https://stackoverflow.com/questions/11709965/vim-highlight-the-word-todo-for-every-filetype
augroup HiglightAudit
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'AUDIT', -1)
augroup END


" Put language specific settings in a config group so they won't get
" evaluated twice.
augroup configgroup
	au BufRead,BufNewFile *.rs setfiletype rust
	autocmd BufRead,BufNewFile *.rs setlocal expandtab
	" Tab settings for various languages
	" Python follows PEP8
	autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.c setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.h setlocal shiftwidth=4 tabstop=4 expandtab
	" Haskell is allergic to tabs.
	autocmd BufRead,BufNewFile *.hs setlocal shiftwidth=2 tabstop=2 expandtab nospell
	" JavaScript follows AirBnB style guide, which the OSL uses
	autocmd BufRead,BufNewFile *.js setlocal shiftwidth=2 tabstop=2 expandtab
	autocmd BufRead,BufNewFile *.ts setlocal shiftwidth=2 tabstop=2 expandtab syntax=javascript
	autocmd BufRead,BufNewFile *.json setlocal shiftwidth=2 tabstop=2 expandtab syntax=javascript
	autocmd BufRead,BufNewFile *.coffee setlocal shiftwidth=2 tabstop=2 expandtab syntax=python
	" C++ follows whatever style Puppet uses
	autocmd BufRead,BufNewFile *.cpp setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.cc setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.cppm setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.ixx setlocal shiftwidth=4 tabstop=4 expandtab

	autocmd BufRead,BufNewFile *.m setlocal shiftwidth=4 tabstop=4 expandtab filetype=objc
	" Make actually uses tabs
	autocmd BufRead,BufNewFile Makefile setlocal shiftwidth=4 tabstop=4
	autocmd BufRead,BufNewFile *yml setlocal shiftwidth=2 tabstop=2 expandtab
	autocmd BufRead,BufNewFile *rb setlocal shiftwidth=2 tabstop=2 expandtab
	" These are ruby DSLs, or very similar to ruby
	autocmd BufRead,BufNewFile *.pp setlocal shiftwidth=2 tabstop=2 expandtab syntax=ruby
	autocmd BufRead,BufNewFile Gemfile setlocal shiftwidth=2 tabstop=2 expandtab syntax=ruby
	autocmd BufRead,BufNewFile Vagrantfile setlocal shiftwidth=2 tabstop=2 expandtab syntax=ruby
	autocmd BufRead,BufNewFile *.go setlocal shiftwidth=4 tabstop=4 syntax=go

	" Human readable files which typically contain prose
	autocmd BufRead,BufNewFile *.md setlocal formatoptions+=t syntax= spell
	autocmd BufRead,BufNewFile *.rst setlocal formatoptions+=t tw=79 spell
	autocmd BufRead,BufNewFile *.tex setlocal formatoptions+=t spell expandtab
	autocmd BufRead,BufNewFile *.txt setlocal formatoptions+=t spell expandtab

	autocmd BufRead,BufNewFile *.asm setlocal formatoptions+=t spell syntax=arm64
	autocmd BufRead,BufNewFile *.S setlocal formatoptions+=t spell syntax=arm64
	autocmd BufRead,BufNewFile *.s setlocal formatoptions+=t spell syntax=arm64

	" The file where git commit messages are stored while they're being edited
	autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t tw=79 spell
	autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell
	au BufRead,BufNewFile *.zig setfiletype rust
	autocmd BufRead,BufNewFile *.zig setlocal expandtab

	autocmd BufNewFile,BufRead *.cidl4 setlocal spell syntax=swift
	autocmd BufNewFile,BufRead *.tightbeam setlocal nospell syntax=swift
	autocmd BufNewFile,BufRead *.swift setlocal nospell syntax=swift

	autocmd BufNewFile,BufRead *.diff setlocal nospell
	autocmd BufNewFile,BufRead *.v setlocal filetype=verilog
	autocmd BufNewFile,BufRead *.thy setlocal filetype=isabelle
	au BufRead,BufNewFile *.thy set conceallevel=2
augroup END

hi clear SpellBad
hi SpellBad cterm=underline	ctermfg=red
" Set style for gVim
hi SpellBad gui=undercurl ctermfg=red

hi clear SpellCap
hi SpellCap cterm=underline	ctermfg=blue
" Set style for gVim
hi SpellCap gui=undercurl ctermfg=blue



"  http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
" Don't mark URL-like things as spelling errors
syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
" Don't count acronyms / abbreviations as spelling errors
" (all upper-case letters, at least three characters)
" Also will not count acronym with 's' at the end a spelling error
" Also will not count numbers that are part of this
" Recognizes the following as correct:
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

"set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.

" move vertically by visual line
nnoremap j gj
nnoremap k gk


" Default settings for anything else
"set cc=80
set shiftwidth=4
set tabstop=4
set ai
set hlsearch            " Highlight search matches
set incsearch           " search as characters are entered
" show line/char number
set ruler


" za folds

" Insert breakpoints
let @g = "Orequire 'pry';binding.pry"
let @h = "Oimport pdb;pdb.set_trace()"

" Clear trailing whitespace
let @w = ":%s/\\s\\+$//"


"" Convert each NAME_LIKE_THIS to NameLikeThis in the current line.
"let @c =":s#_*\(\u\)\(\u*\)#\1\L\2#g"
"
"" Convert each name_like_this to NameLikeThis in current line.
"let @c = ":s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g"

" Convert each name-like-this to NameLikeThis in current line.
let @c = ":s#\(\%(\<\l\+\)\%(-\)\@=\)\|-\(\l\)#\u\1\2#g"


"let s:uname = system("uname -s")
"if s:uname == "Darwin"
"	" On OS X
"	" Copy selection to clipboard
"	nma <leader>c :'<,'>w!pbcopy<CR>
"else
"	" On Linux
"	" Copy selection to clipboard
"	nma <leader>c :'<,'>w!xclip<CR>
"endif

" Remap common typos
"map :WA<cr> :wa<cr>
"map :Wa<cr> :wa<cr>
"map :WQ<cr> :wq<cr>
"map :Wq<cr> :wq<cr>
"map :W<cr> :w<cr>
"map :Q<cr> :q<cr>
"map :Qa<cr> :qa<cr>
command Q q
command QA qa
command Qa qa
command W w
command WA wa
command Wa wa
command WQ wq
command Wq wq



" toggle paste
nma <leader>p :set paste!<CR>
" line numbers toggle
nma <leader>n :set invnumber<CR>
" wrapping toggle
nma <leader>w :set wrap!<CR>
" remove search highlights
nma <leader>h :noh<CR>
" remove search highlights
nma <leader>t :set expandtab!<CR>

" space=page down, shift space=page up
nnoremap <Space> <C-d>
nnoremap <S-Space> <C-u>




"colorscheme seoul256

"set list listchars=tab:→\ ,trail:·

" Bash like autocomplete.
set wildmode=longest,list,full
set wildmenu
" Experiment with different autcomplete
set completeopt=longest,menuone

syn keyword AuditHighlightGroup AUDIT
hi link AuditHighlightGroup Todo
"hi AuditHighlightGroup guifg=Blue ctermfg=Blue term=bold


"if executable('rls')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'rls',
"        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
"        \ 'whitelist': ['rust'],
"        \ })
"endif

let c_no_curly_error=1

if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    nmap <C-@>s :tab cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :tab cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>c :tab cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :tab cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :tab cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :tab cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :tab cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :tab cs find d <C-R>=expand("<cword>")<CR><CR>

    nmap <C-@><C-@>s :tab cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :tab cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :tab cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :tab cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :tab cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :tab cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :tab cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :tab cs find d <C-R>=expand("<cword>")<CR><CR>

endif

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif

hi Search cterm=NONE ctermfg=black ctermbg=blue

command Link :exe "!stashlink.py " . expand("%") . " " . line(".") . " | pbcopy"
