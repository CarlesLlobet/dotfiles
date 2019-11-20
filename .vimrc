" Author: Eric Nova
" Source:
"


" Preamble ---------------------------------------------------------------- {{{
filetype off
filetype plugin indent on
set nocompatible
"Font {{{
" Full screen
if has("gui_running")
  set lines=75 columns=200
endif
" }}}
" }}}
" Basic options ----------------------------------------------------------- {{{
set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set ttyfast
set autochdir
"set ruler
set backspace=indent,eol,start
set number
set relativenumber
"set norelativenumber
set laststatus=2
set history=1000
"set undofile
"set undoreload=10000
"set list
"set listchars=tab:▸\ ,extends:❯,precedes:❮
set shell=/bin/bash\ --login
set lazyredraw
set matchtime=3
"set showbreak=↪
set splitbelow
set splitright
"set fillchars=diff:⣿,vert:│
set autowrite
set autoread
set shiftround
set title
set linebreak
set spellfile=~/.vim/custom-dictionary.utf-8.add


" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
set complete=.,w,b,u,t
set completeopt=menuone,longest

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

" Paste toggle
nnoremap <F3> :set invpaste paste?<CR>
set pastetoggle=<F3>
set showmode
setlocal fo+=aw

" Short message
set shortmess=aT


" Cursorline {{{
" Only show cursorline in the current window and in normal mode.

augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" }}}
" Wildmenu completion {{{

set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" }}}
" Line Return {{{

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
" }}}
" Tabs, spaces, wrapping {{{

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=140
set formatoptions=qrn1

" }}}
" Leader {{{
let mapleader = ","
let maplocalleader = "_"
" }}}
" Color scheme {{{

syntax on
set background=dark
let g:badwolf_tabline = 2
let g:badwolf_html_link_underline = 0
set t_Co=256
colorscheme badwolf

" Reload the colorscheme whenever we write the file.
augroup color_badwolf_dev
    au!
    au BufWritePost badwolf.vim color badwolf
augroup END

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}

" }}}
" Autocmd ----------------------------------------------------------------- {{{
"Jump to the last position
if has("autocmd")
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    autocmd BufWritePost .vimrc source $MYVIMRC
    autocmd BufEnter * highlight OverLength ctermbg=237 guibg=#111111
    autocmd BufEnter * match OverLength /\%80v.*/
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
endif
" }}}
" Abbreviations ----------------------------------------------------------- {{{

" iabbrev sl@ ericnova1@gmail.com
" iabbrev vrcf `~/.vimrc` file

" }}}
" Convenience mappings ---------------------------------------------------- {{{
map <leader><leader> <c-^>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

"TODO: hacer que pregunte el archivo que quiero abrir
nnoremap <leader>s :split<cr>
nnoremap <leader>vs :vsplit<cr>

" easier mappings for searching
nnoremap - /
nnoremap _ ?

" Sort lines
vnoremap <leader>s :!sort<cr>

" Tabs
" TODO: Poner un buen atajo de teclado
" nnoremap <leader>( :tabprev<cr>
" nnoremap <leader>) :tabnext<cr>

" Emacs bindings in command line mode
inoremap <C-a> <home>
inoremap <C-e> <end>
inoremap <C-w> <esc>vbda
inoremap <C-k> <esc>d$i
inoremap <C-u> <esc>d0i

" Change inside the ()
nnoremap ci( %ci(

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>

" Insert Mode Completion 
inoremap <c-f> <c-x><c-f>
"}}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <Leader>x :bdelete<cr>
nnoremap <leader>ev :vsplit /media/Zero/dotfiles/vimrc<cr>
nnoremap <leader>eb :vsplit /media/Zero/dotfiles/bashrc<cr>
nnoremap <leader>el :vsplit /home/rayenok/org/software/bash/confLinux.sh<cr>
nnoremap <leader>ec :vsplit /usr/local/src/dwm-6.0/config.h<cr>
nnoremap <leader>ed :vsplit /home/rayenok/software/init/dwmstart<cr>

" }}}
" Searching and movement -------------------------------------------------- {{{

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Easy buffer navigation {{{
noremap <C-j> <c-w><down>
noremap <C-k> <c-w><up>
noremap <C-h> <c-w><left>
noremap <C-l> <c-w><right>
" noremap <C-S-h> 3<C-w><
" noremap <C-S-l> 3<C-w>>

" }}}
" List navigation {{{

nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz

" }}}

" }}}
" Folding ----------------------------------------------------------------- {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Filetype-specific ------------------------------------------------------- {{{

" C {{{
augroup ft_c
    au!
    au FileType c setlocal foldmethod=marker foldmarker={,}
    au FileType c set foldlevel=99

augroup END
" }}}
" Markdown {{{

augroup ft_markdown
    au!

    au BufNewFile,BufRead *.m*down setlocal filetype=markdown foldlevel=1

    " Use <localleader>1/2/3 to add headings.
    au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
    au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
    au Filetype markdown nnoremap <buffer> <localleader>3 mzI###<space>`zllll <ESC>
augroup END

" }}}
" Others {{{
set foldmethod=marker
" }}}
" Puppet {{{

augroup ft_puppet
    au!

    au Filetype puppet setlocal foldmethod=marker
    au Filetype puppet setlocal foldmarker={,}
augroup END

" }}}
" Python {{{

augroup ft_python
    au!

    au FileType python set makeprg=python2.7\ %
    au FileType python set sw=4 sts=4
    au FileType python setlocal define=^\s*\\(def\\\\|class\\)
    au FileType man nnoremap <buffer> <cr> :q<cr>
    au FileType python nnoremap <buffer> <Leader>ju :exec '!python' shellescape(@%, 1)<cr>

    " Jesus tapdancing Christ, built-in Python syntax, you couldn't let me
    " override this in a normal way, could you?
    au FileType python if exists("python_space_error_highlight") | unlet python_space_error_highlight | endif

    au FileType python iabbrev <buffer> afo assert False, "Okay"
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
" }}}
" Plugin settings --------------------------------------------------------- {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdcommenter'
Plugin 'valloric/youcompleteme'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'sirver/ultisnips'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

inoremap <Tab> <c-r>=UltiSnips#ExpandSnippet()<cr>
" Airline {{{
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
    endif

    " unicode symbols
    let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '␊'
    let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'

    " airline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
" }}}
" }}}
" Debug ------------------------------------------------------------------- {{{
nnoremap <leader>zz :profile start profile.log<cr>:profile func *<cr>:profile file *<cr>
nnoremap <leader>zx :profile pause<cr>
" }}}
" Environments (GUI/Console) ---------------------------------------------- {{{
if has('gui_running')
    " GUI Vim
    "set guifont=Consolas\ for\ Powerline\ FixedD:h9

    "set guifont=Menlo\ Regular\ for\ Powerline:h3
    "set guifont=Terminus\ 10
    set guifont=FreeMono\ 10

    " Remove all the UI cruft
    set go-=T
    set go-=l
    set go-=L
    set go-=r
    set go-=R

    highlight SpellBad term=underline gui=undercurl guisp=Orange

    " Different cursors for different modes.
    set guicursor=n-c:block-Cursor-blinkon0
    set guicursor+=v:block-vCursor-blinkon0
    set guicursor+=i-ci:ver20-iCursor
    " Console Vim
    " For me, this means iTerm2, possibly through tmux

    " Mouse support
    set mouse=a
endif
" }}}
