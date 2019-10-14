scriptencoding utf-8

" Swtich to last buffer
map <leader><leader> <c-^>

" Copy whole file
map <leader>a :%y+<CR>
" Paste from system clipboard
map <leader>p "+p
map <leader>P "+P

" Delete all trailing whitespace
map <leader>zz %s/\s\+$//e

nmap <leader>w :write<CR>
nmap <leader>x :xit<CR>

" Custom commands
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
nnoremap <C-o> :Files<cr>
nnoremap <C-f> :Rg<cr>
