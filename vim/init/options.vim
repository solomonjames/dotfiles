" Look and feel
let t_Co=256
set background=dark
set backspace=indent,eol,start     " Let backspace work over anything.
set hidden                         " Allow hidden, unsaved buffers
set history=1024
set laststatus=2                   " Always show statusline
" set mouse=a                        " Use mouse support in XTerm/iTerm.
set nocompatible                   " be iMproved
set notimeout                      " No command timeout
set number                         " Line numbers
set scrolloff=3                    " Scroll when the cursor is 3 lines from edge
set shell=/bin/bash                " Make Vim use bash, incompatible with fish
set showcmd                        " Show typed command prefixes while waiting for operator
set showmatch                      " Show matching brackets
set splitright                     " Add new windows towards the right
set splitbelow                     " ... and bottom
set wildmode=list:longest          " Bash-like tab completion
set term=screen-256color           " so the background color isn't fucked
set wildmenu                       " autocomplete after tab
set paste                          " Make a ctrl-v work nicely
set rtp+=~/.fzf

colorscheme seoul256

syntax on

" Show 100 column limit as colored line
if exists('+colorcolumn')
  set colorcolumn=100
endif


" Disable arrow keys
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>


" Tab behavior
set shiftwidth=4                   " Width of autoindent
set expandtab                      " Use soft tabs
set tabstop=4                      " Tab settings
set smarttab                       " Use shiftwidth to tab at line beginning


" Indentation
set autoindent


" Search
set incsearch                      " Incremental search
set hlsearch                       " search with highlights by default
set ignorecase
set smartcase


" Highlight cursorline
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40


" Highlights extrawhitespace
hi ExtraWhitespace ctermbg=red guibg=red guifg=red guibg=red
au CursorMoved * match ExtraWhitespace /\s\+\%#\@<!$/


" Saving
set swapfile                               " Keep swapfiles
set directory=~/.vim-tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/tmp,/var/tmp,/tmp
" Write all writeable buffers when changing buffers or losing focus.
set autowriteall                           " Save when doing various buffer-switching things.
autocmd BufLeave,FocusLost * silent! wall  " Save anytime we leave a buffer or MacVim loses focus.


" Visible characters
set list                                   " Show whitespace
if has("gui_running")
  set listchars=trail:·
else
  set listchars=trail:~
endif


" Uncomment the following to have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif


" Turn off ri tooltips that don't work with Ruby 1.9 yet
" http://code.google.com/p/macvim/issues/detail?id=342
if has("gui_running")
  set noballooneval
endif

" Detect asciidoc files
autocmd BufRead,BufNewFile *.asciidoc setfiletype asciidoc
