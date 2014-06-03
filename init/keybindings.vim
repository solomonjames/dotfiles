let mapleader = ","
let maplocalleader = ";"

" Easy access to the shell
map <Leader><Leader> :!

" Shortcut to saving files as sudo.
cmap w!! %!sudo tee > /dev/null %

" In command-line mode, <C-A> should go to the front of the line, as in bash.
cmap <C-A> <C-B>

" Toggle Nerd Tree
nnoremap \ :NERDTreeToggle<Cr><Cr>

" Window navigation
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
