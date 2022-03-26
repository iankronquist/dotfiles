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
	autocmd BufRead,BufNewFile *.h setlocal shiftwidth=4 tabstop=4 noexpandtab
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

	autocmd BufRead,BufNewFile *.m setlocal shiftwidth=4 tabstop=4 expandtab filetype=objc
	" Make actually uses tabs
	autocmd BufRead,BufNewFile Makefile setlocal shiftwidth=4 tabstop=4
	autocmd BufRead,BufNewFile *yml setlocal shiftwidth=2 tabstop=2 expandtab
	autocmd BufRead,BufNewFile *rb setlocal shiftwidth=2 tabstop=2 expandtab
	" These are ruby DSLs, or very similar to ruby
	autocmd BufRead,BufNewFile *.pp setlocal shiftwidth=2 tabstop=2 expandtab syntax=ruby
	autocmd BufRead,BufNewFile Gemfile setlocal shiftwidth=2 tabstop=2 expandtab syntax=ruby
	autocmd BufRead,BufNewFile Vagrantfile setlocal shiftwidth=2 tabstop=2 expandtab syntax=ruby
	autocmd BufRead,BufNewFile *.go setlocal shiftwidth=4 tabstop=4 syntax=java

	" Human readable files which typically contain prose
	autocmd BufRead,BufNewFile *.md setlocal formatoptions+=t syntax= spell
	autocmd BufRead,BufNewFile *.rst setlocal formatoptions+=t tw=79 spell
	autocmd BufRead,BufNewFile *.tex setlocal formatoptions+=t spell expandtab
	"autocmd BufRead,BufNewFile *.txt setlocal formatoptions+=t tw=79 spell expandtab

	autocmd BufRead,BufNewFile *.asm setlocal formatoptions+=t tw=79 spell syntax=C
	autocmd BufRead,BufNewFile *.S setlocal formatoptions+=t tw=79 spell syntax=C
	autocmd BufRead,BufNewFile *.s setlocal formatoptions+=t tw=79 spell syntax=C
	" The file where git commit messages are stored while they're being edited
	autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t tw=79 spell
	autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell
	au BufRead,BufNewFile *.zig setfiletype rust
	autocmd BufRead,BufNewFile *.zig setlocal expandtab

augroup END

"  http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
" Don't mark URL-like things as spelling errors
syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
" Don't count acronyms / abbreviations as spelling errors
" (all upper-case letters, at least three characters)
" Also will not count acronym with 's' at the end a spelling error
" Also will not count numbers that are part of this
" Recognizes the following as correct:
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.

" move vertically by visual line
nnoremap j gj
nnoremap k gk


" Default settings for anything else
set cc=80
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
map :WA<cr> :wa<cr>
map :Wa<cr> :wa<cr>
map :WQ<cr> :wq<cr>
map :Wq<cr> :wq<cr>
map :W<cr> :w<cr>
map :Q<cr> :q<cr>



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




colorscheme seoul256

set list listchars=tab:→\ ,trail:·

" Bash like autocomplete.
set wildmode=longest,list,full
set wildmenu
" Experiment with different autcomplete
set completeopt=longest,menuone

syn keyword AuditHighlightGroup AUDIT
hi link AuditHighlightGroup Todo
"hi AuditHighlightGroup guifg=Blue ctermfg=Blue term=bold




" space=page down, shift space=page up
nnoremap <Space> <C-d>
nnoremap <S-Space> <C-u>

"if executable('rls')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'rls',
"        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
"        \ 'whitelist': ['rust'],
"        \ })
"endif
