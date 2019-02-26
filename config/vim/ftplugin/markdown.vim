setlocal textwidth=80
" Compile using pandoc
map <leader>c :w! \| !pandoc % -f gfm -o %:r.html<CR><CR>
" Preview
map <leader>p :!google-chrome --new-window %:r.html<CR><CR>
