scriptencoding utf-8

function s:CheckColorScheme()
	if !has("termguicolors")
		let g:base16colorspace=256
	endif

	if filereadable(expand("~/.vimrc_background"))
		source ~/.vimrc_background
		execute 'highlight link EndOfBuffer ColorColumn'
		" Only need this stuff if I want transparent terminal
		" highlight Normal guibg=None ctermbg=none
		" highlight NonText guibg=None ctermbg=none
		" highlight LineNr guibg=None ctermbg=none
		" highlight SignColumn guibg=None ctermbg=none
		" highlight Folded guibg=None ctermbg=none
		" highlight FoldColumn guibg=None ctermbg=none
		" highlight GitGutterAdd guibg=None ctermbg=none
		" highlight GitGutterChange guibg=None ctermbg=none
		" highlight GitGutterDelete guibg=None ctermbg=none
		" highlight GitGutterChangeDelete guibg=None ctermbg=none
	else " default
		set background=dark
		colorscheme base16-default-dark
	endif

	let mybg=synIDattr(synIDtrans(hlID('StatusLine')), 'bg')
	let myfg=synIDattr(synIDtrans(hlID('StatusLine')), 'fg')
	execute 'highlight User1 gui=ITALIC guifg=brightwhite guibg=' . mybg
	execute 'highlight User2 gui=BOLD guifg=brightwhite guibg=' . mybg
	execute 'highlight User4 gui=BOLD guifg=darkred guibg=' . mybg
	execute 'highlight User5 gui=BOLD guifg=' . mybg . ' guibg=' . myfg
	execute 'highlight User7 guifg=white guibg=darkred'
endfunction

if v:progname !=# 'vi'
	if has("autocmd")
		augroup dzagerAutocolor
			autocmd!
			autocmd FocusGained * call s:CheckColorScheme()
		augroup END
	endif
	call s:CheckColorScheme()
endif
