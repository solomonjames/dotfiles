" =============================================================================
" Filename: plugin/lightline.vim
" Version: 0.0
" Author: itchyny
" License: MIT License
" Last Change: 2014/06/11 14:12:52.
" =============================================================================

if exists('g:loaded_lightline') && g:loaded_lightline
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

augroup LightLine
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType,ColorScheme,SessionLoadPost * call lightline#update()
  autocmd ColorScheme,SessionLoadPost * call lightline#highlight()
  autocmd CursorMoved,BufUnload * call lightline#update_once()
augroup END

let g:loaded_lightline = 1

let &cpo = s:save_cpo
unlet s:save_cpo
