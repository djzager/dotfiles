" Most helpful other configs I have taken from:
" https://github.com/LukeSmithxyz/voidrice
" https://github.com/wincent/wincent
" https://github.com/jessfraz/dotfiles
let mapleader = " "
let maplocalleader = "\\"

" Plugins
	if empty(glob("$XDG_CONFIG_HOME/nvim/autoload/plug.vim"))
		silent !mkdir -p "$XDG_CONFIG_HOME/nvim/autoload"
		silent !curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > "$XDG_CONFIG_HOME/nvim/autoload/plug.vim"
		" autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
		autocmd VimEnter * PlugInstall --sync
	endif

	call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
		Plug 'airblade/vim-gitgutter'
		Plug 'autozimu/LanguageClient-neovim', {
				\ 'branch': 'next',
				\ 'do': 'bash install.sh',
		\ }
		Plug 'chriskempson/base16-vim'
		Plug 'christoomey/vim-tmux-navigator'
		" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
		Plug 'junegunn/fzf'
		Plug 'junegunn/fzf.vim'
		Plug 'kopischke/vim-fetch'
		Plug 'sheerun/vim-polyglot'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-fugitive'
		Plug 'wincent/loupe'
	call plug#end()

" LanguageServer
	let g:LanguageClient_useFloatingHover=1
	let g:LanguageClient_hoverPreview='Always'
	let g:LanguageClient_serverCommands = {
		\ 'go': ['~/go/bin/gopls'],
		\ }

" Polyglot
	let g:vim_markdown_conceal_code_blocks = 0
