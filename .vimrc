" This is a comment
set spell
syntax on
set number

" Put language specific settings in a config group so they won't get
" evaluated twice.
augroup configgroup
	au BufRead,BufNewFile *.rs setfiletype rust

	" Tab settings for various languages
	" Python follows PEP8
	autocmd BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.c setlocal shiftwidth=4 tabstop=4 noexpandtab
	autocmd BufRead,BufNewFile *.h setlocal shiftwidth=4 tabstop=4 noexpandtab
	" Haskell is allergic to tabs.
	autocmd BufRead,BufNewFile *.hs setlocal shiftwidth=2 tabstop=2 expandtab nospell
	" JavaScript follows AirBnB style guide, which the OSL uses
	autocmd BufRead,BufNewFile *.js setlocal shiftwidth=2 tabstop=2 expandtab
	autocmd BufRead,BufNewFile *.ts setlocal shiftwidth=2 tabstop=2 expandtab syntax=javascript
	autocmd BufRead,BufNewFile *.json setlocal shiftwidth=2 tabstop=2 expandtab syntax=javascript
	" C++ follows whatever style Puppet uses
	autocmd BufRead,BufNewFile *.cpp setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.cc setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
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
	autocmd BufRead,BufNewFile *.md setlocal formatoptions+=t tw=79 syntax= spell
	autocmd BufRead,BufNewFile *.rst setlocal formatoptions+=t tw=79 spell
	autocmd BufRead,BufNewFile *.tex setlocal formatoptions+=t spell expandtab
	autocmd BufRead,BufNewFile *.txt setlocal formatoptions+=t tw=79 spell expandtab

	autocmd BufRead,BufNewFile *.asm setlocal formatoptions+=t tw=79 spell
	autocmd BufRead,BufNewFile *.S setlocal formatoptions+=t tw=79 spell

	" The file where git commit messages are stored while they're being edited
	autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t tw=79 spell
	autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell

augroup END

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

" za folds

" Insert breakpoints
let @g = "Orequire 'pry';binding.pry"
let @h = "Oimport pdb;pdb.set_trace()"

" Clear trailing whitespace
let @w = ":%s/\\s\\+$//"

" toggle paste
nma <leader>p :set paste!<CR>
" line numbers toggle
nma <leader>n :set invnumber<CR>
" wrapping toggle
nma <leader>w :set wrap!<CR>
" remove search highlights
nma <leader>h :noh<CR>

" OS X only
let @p = ":w!pbcopy"

colorscheme seoul256

set list listchars=tab:→\ ,trail:·
