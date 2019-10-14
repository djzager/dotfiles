scriptencoding utf-8

" Mostly copied from
" https://github.com/wincent/wincent/blob/4dfc009f1f8b710ce728d5383241074529ef3781/roles/dotfiles/files/.vim/plugin/statusline.vim
if has("statusline")
	set statusline=%7*                                 " Switch to User7 highlight group
	set statusline+=%{dzager#statusline#lhs()}
	set statusline+=%*                                 " Reset highlight group.
	set statusline+=%4*                                " Switch to User4 highlight group (Powerline arrow).
	set statusline+=                                  " Powerline arrow.
	set statusline+=%*                                 " Reset highlight group.
	set statusline+=\                                  " Space.
	set statusline+=%<                                 " Truncation point, if not enough width available.
	set statusline+=%{dzager#statusline#fileprefix()}  " Relative path to file's directory.
	set statusline+=%2*                                " Switch to User4 highlight group.
	set statusline+=%t                                 " Filename.
	set statusline+=%*                                 " Reset highlight group.
	set statusline+=\                                  " Space.
	set statusline+=%1*                                " Switch to User1 highlight group (italics).

  " Needs to be all on one line:
  "   %(                           Start item group.
  "   [                            Left bracket (literal).
  "   %R                           Read-only flag: ,RO or nothing.
  "   %{dzager#statusline#ft()}    Filetype (not using %Y because I don't want caps).
  "   %{dzager#statusline#fenc()}  File-encoding if not UTF-8.
  "   ]                            Right bracket (literal).
  "   %)                           End item group.
	set statusline+=%([%R%{dzager#statusline#ft()}%{dzager#statusline#fenc()}]%)

	set statusline+=%*                                 " Reset highlight group.
  set statusline+=%=                                 " Split point for left and right groups.
  set statusline+=\                                  " Space.
  set statusline+=                                  " Powerline arrow.
  set statusline+=%5*                                " Switch to User5 highlight group.
  set statusline+=%{dzager#statusline#rhs()}
  set statusline+=%*                                 " Reset highlight group.
endif
