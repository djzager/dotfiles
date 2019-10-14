scriptencoding utf-8

function! dzager#statusline#gutterpadding()
	let l:signcolumn=0
	if exists('+signcolumn')
		if &signcolumn == 'yes'
			let l:signcolumn=2
		elseif &signcolumn == 'auto'
			if exists('*execute')
				let l:signs=execute('sign place buffer=' .bufnr('$'))
			else
				let l:signs=''
				silent! redir => l:signs
				silent execute 'sign place buffer=' . bufnr('$')
				redir END
			end
			if match(l:signs, 'line=') != -1
				let l:signcolumn=2
			endif
		endif
	endif

	let l:minwidth=2
	let l:gutterWidth=max([strlen(line('$')) + 1, &numberwidth, l:minwidth]) + l:signcolumn
	let l:padding=repeat(' ', l:gutterWidth - 1)
	return l:padding
endfunction

function! dzager#statusline#lhs()
	let l:line=dzager#statusline#gutterpadding()
	" HEAVY BALLOT X - Unicode: U+2718, UTF-8: E2 9C 98
	let l:line.=&modified ? '✘ ' : '  '
	return l:line
endfunction

function! dzager#statusline#rhs() abort
  let l:rhs=' '
  if winwidth(0) > 80
    let l:column=virtcol('.')
    let l:width=virtcol('$')
    let l:line=line('.')
    let l:height=line('$')

    " Add padding to stop rhs from changing too much as we move the cursor.
    let l:padding=len(l:height) - len(l:line)
    if (l:padding)
      let l:rhs.=repeat(' ', l:padding)
    endif

    let l:rhs.='ℓ ' " (Literal, \u2113 "SCRIPT SMALL L").
    let l:rhs.=l:line
    let l:rhs.='/'
    let l:rhs.=l:height
    let l:rhs.=' 𝚌 ' " (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
    let l:rhs.=l:column
    let l:rhs.='/'
    let l:rhs.=l:width
    let l:rhs.=' '

    " Add padding to stop rhs from changing too much as we move the cursor.
    if len(l:column) < 2
      let l:rhs.=' '
    endif
    if len(l:width) < 2
      let l:rhs.=' '
    endif
  endif
  return l:rhs
endfunction

function! dzager#statusline#fileprefix()
	let l:basename=expand('%:h')
	if l:basename ==# '' || l:basename ==# '.'
		return ''
	elseif has('modify_fname')
		" Make sure we show $HOME as ~.
		return substitute(fnamemodify(l:basename, ':~:.'), '/$', '', '') . '/'
	else
		" Make sure we show $HOME as ~.
		return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
	endif
endfunction

function! dzager#statusline#ft() abort
  if strlen(&ft)
    return ',' . &ft
  else
    return ''
  endif
endfunction

function! dzager#statusline#fenc()
	if strlen(&fenc) && &fenc !=# 'utf-8'
		return ',' . &fenc
	else
		return ''
	endif
endfunction
