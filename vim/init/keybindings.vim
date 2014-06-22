let mapleader = ","
let maplocalleader = ";"


" Easy access to the shell
map <Leader><Leader> :!


" Shortcut to saving files as sudo.
cmap w!! %!sudo tee > /dev/null %


" In command-line mode, <C-A> should go to the front of the line, as in bash.
cmap <C-A> <C-B>


" Toggle Nerd Tree
nnoremap \ :NERDTreeTabsToggle <Cr>


" Window navigation
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l


" cntrl-h highlights all words the cursor is over
nnoremap <C-h> :exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')) <Cr>


" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>""


" easymotion
map <Leader> <Plug>(easymotion-prefix)

nnoremap <silent> <Leader>C :call fzf#run({
\   'source':
\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
\   'sink':       'colo',
\   'options':    '+m',
\   'tmux_width': 20,
\   'launcher':   'xterm -geometry 20x30 -e bash -ic %s'
\ })<CR>
