" Start fullscreen.
autocmd GUIEnter * simalt ~x
"set spell
syntax on
set smartindent
" Case insensitive search for lower case searches
set ignorecase
set smartcase
set number
" Turn off awful windows-chime bell
set belloff=all

" Bash like autocomplete.
set wildmode=longest,list,full
set wildmenu

" Experiment with different autcomplete
set completeopt=longest,menuone

" Display trailing whitespace.
" Tabs show as double arrows pointing left.
" Trailing whitespace shows as double arrows pointing right.
set list listchars=tab:»\ ,trail:«

augroup configgroup
	" C and C++
	autocmd BufRead,BufNewFile *.c setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.cc setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.cxx setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.cpp setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.hh setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.h setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
	autocmd BufRead,BufNewFile *.hxx setlocal shiftwidth=4 tabstop=4 expandtab
	" Special preprocessor files part of the windows build system which are basically headers with magic annotations.
	autocmd BufRead,BufNewFile *.w setlocal shiftwidth=4 tabstop=4 expandtab syntax=c
	autocmd BufRead,BufNewFile *.api setlocal shiftwidth=4 tabstop=4 expandtab syntax=c
	autocmd BufRead,BufNewFile *.tpl setlocal shiftwidth=4 tabstop=4 expandtab syntax=c
	" Powershell. Use csh syntax highlighting since that's close enough.
	autocmd BufRead,BufNewFile *.ps1 setlocal shiftwidth=4 tabstop=4 expandtab syntax=csh
	" :hi Error NONE
	autocmd BufRead,BufNewFile *.ps1 hi Error NONE
	autocmd BufRead,BufNewFile *.psm1 setlocal shiftwidth=4 tabstop=4 expandtab syntax=csh
	autocmd BufRead,BufNewFile *.psm1 hi Error NONE
	" Windows build files are make.
	autocmd BufRead,BufNewFile sources* setlocal noexpandtab syntax=make
	autocmd BufRead,BufNewFile dirs setlocal noexpandtab syntax=make
	" Prose
	autocmd BufRead,BufNewFile *.txt setlocal spell
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

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 13
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")

    " gvim window position should be on the far left of the screen
    "winpos -7 0
    colorscheme desert

    " Set font to something sane
    set guifont=Consolas:h10:cANSI

    " Disable ugly blinking cursor
    set guicursor+=a:blinkon0

    "Disable bell in windows
    autocmd GUIEnter * set vb t_vb

  endif
  " Disable toolbar
  set guioptions-=T
  " Disable menu bar
  set guioptions-=m
else " Terminal
    colorscheme default
endif

" Make backspace work
set backspace=indent,eol,start

" Don't indent namespaces
set cino=N-s

" Highlight all occurences of search terms
set hlsearch
" search as characters are entered
set incsearch
" load filetype-specific indent files
filetype indent on
filetype plugin on

" Clear trailing whitespace
let @w = ":%s/\\s\\+$//"

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
" toggle tab expansion
nma <leader>t :set expandtab!<CR>
" toggle ruler
nma <leader>r :set ruler!<CR>
nma <leader>l :set list!<CR>

function! Concentrate()
	set list!
	set spell!
	noh
	set number!
endfunction

" Concentration, toggle screen noise
nma <leader>c :call Concentrate()

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Windows style copy paste, etc.
"source $VIMRUNTIME/mswin.vim
"behave mswin

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

if has("clipboard")
    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    " no, I like CTRL-V as is thanks.
    "map <C-V>		"+gP
    map <S-Insert>		"+gP

    "cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+
endif


" show line/char number
set ruler

""disable esc. May break things?
" noremap   <Esc>    <NOP>
":noremap   <Esc>    <NOP>
":inoremap   <Esc>    <NOP>
":cnoremap   <Esc>    <NOP>
":onoremap   <Esc>    <NOP>

:nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

" space=page down, shift space=page up
nnoremap <Space> <C-d>
nnoremap <S-Space> <C-u>


" NOTE!!!!!!!!!!!!!!!!!!!!!!! Try the * command.
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
noremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=8000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=1000
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

let g:mwDefaultHighlightingPalette = 'extended'

" :Tlist -- show tags

" Ctrl-n takes too long, don't scan every header in the world. May want to
" change this to limit the number of buffers scanned instead??
set complete-=i

" Apparently by default vim will add a newline at the end of the file.
" This is conventional in unixland, but we aren't in unixland, are we?
set nofixendofline
