" Focus window
function! dzager#focus#FocusWindow()
	set list
	if has("conceal")
		set conceallevel=1
	endif
endfunction

" Blur window
function! dzager#focus#BlurWindow()
	set nolist
	if has("conceal")
		set conceallevel=0
	endif
endfunction
