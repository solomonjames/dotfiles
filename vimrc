""""""""""""
" Vim Config
""""""""""""
" How this works:
"
" This file should be minimal. General configuration should be added to
" .vim/init.

""""""""""""""""""""""""""""""""""
" Vundle and bundles configuration
""""""""""""""""""""""""""""""""""
source bundles.vim

"""""""""""""""""""""""""""""
" Source initialization files
"""""""""""""""""""""""""""""
runtime! init/**.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Machine-local vim settings - keep this at the end
"""""""""""""""""""""""""""""""""""""""""""""""""""
silent! source ~/.vimrc.local
