if has("autocmd")
	augroup dzagerAutocmds
		autocmd!

		" When editing a file, always jump to the last known cursor position.
		autocmd BufReadPost *
		\ if line("'\"") >= 1 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif

		" http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
		autocmd VimEnter * autocmd WinEnter * let w:created=1
		autocmd VimEnter * let w:created=1

		" Use relative numbering
		autocmd FocusLost * :set norelativenumber
		autocmd FocusGained * :set relativenumber
		autocmd InsertEnter * :set norelativenumber
		autocmd InsertLeave * :set relativenumber

		" Focus gained/lost
		" Color column
		" Turn off if you want transparency"
		" if exists("+winhighlight")
		" 	autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=
		" 	autocmd FocusLost,WinLeave * set winhighlight=CursorLineNr:LineNr,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn
		" 	if exists('+colorcolumn')
		" 		autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
		" 	endif
		" elseif exists("+colorcolumn")
		" 	autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
		" 	autocmd FocusLost,WinLeave * let &l:colorcolumn=join(range(1, 255), ',')
		" endif
		" if has("statusline")
		" 	autocmd BufEnter,FocusGained,VimEnter,WinEnter * setlocal statusline=
		" 	autocmd FocusLost,WinLeave * setlocal statusline=%f
		" endif
		" autocmd InsertLeave,VimEnter,WinEnter * setlocal cursorline
		" autocmd InsertEnter,WinLeave * setlocal nocursorline
		" autocmd BufEnter,FocusGained,VimEnter,WinEnter * call dzager#focus#FocusWindow()
		" autocmd FocusLost,WinLeave * call dzager#focus#BlurWindow()

		" " Automatically delete all trailing whitespace on save.
		" autocmd BufWritePre * %s/\s\+$//e

		" Disables automatic commenting on newline:
		autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
	augroup END
endif
