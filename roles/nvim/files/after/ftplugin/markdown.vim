setlocal textwidth=80

let b:delimitMate_expand_cr = 2
let b:delimitMate_expand_inside_quotes = 1
let b:delimitMate_expand_space = 0
let b:delimitMate_nesting_quotes = ['`']

inoremap ,1 #<Space><Enter><++><Esc>kA
map <localleader>2 ##<Space><Enter><++><Esc>kA
map <localleader>3 ###<Space><Enter><++><Esc>kA
map <localleader>4 ####<Space><Enter><++><Esc>kA
map <localleader>5 #####<Space><Enter><++><Esc>kA
