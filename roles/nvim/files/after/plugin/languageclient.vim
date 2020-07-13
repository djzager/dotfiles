scriptencoding utf-8

function! s:Config()
	if has_key(g:LanguageClient_serverCommands, &filetype)
		" if &filetype == 'reason'
		" 	" Format selection with gq.
		" 	setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

		" 	" <Leader>f -- Format buffer.
		" 	nnoremap <buffer> <silent> <leader>f :call LanguageClient_textDocument_formatting()<CR>
		" endif
		nnoremap <buffer> <silent> <leader>f :call LanguageClient_textDocument_formatting()<CR>

		" <Leader>ca -- perform code action (like fixing imports).
		nnoremap <buffer> <silent> <leader>ca :call LanguageClient_textDocument_codeAction()<CR>

		" gd -- go to definition
		nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
		nnoremap <buffer> <silent> gv :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
		nnoremap <buffer> <silent> gs :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>

		" K -- lookup keyword
		nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>

		" R -- rename keyword
		nnoremap <buffer> <silent> R :call LanguageClient#textDocument_rename()<CR>

		if exists("+signcolumn")
			setlocal signcolumn=yes
		endif
	endif
endfunction

function! s:Bind()
	nnoremap <buffer> <silent> K :call LanguageClient#closeFloatingHover()<CR>
	nnoremap <buffer> <silent> <Esc> :call LanguageClient#closeFloatingHover()<CR>
endfunction

if has("autocmd")
	augroup dzagerLanguageClientAutocmds
		autocmd!
		" Add LanguageServer functionality if it exists for the filetype
		autocmd FileType * call s:Config()

		" Add ability to exit floating windows from languageclient
		if has("nvim") && exists("*nvim_open_win")
			" Can use floating window
			autocmd BufEnter __LanguageClient__ call s:Bind()
		endif
	augroup END
endif
