" Most helpful other configs I have taken from:
" https://github.com/LukeSmithxyz/voidrice
" https://github.com/wincent/wincent
" https://github.com/jessfraz/dotfiles
let mapleader = " "
let maplocalleader = "\\"

" Settings
	scriptencoding utf-8

	set nocompatible                " Use Vim settings, rather than Vi settings (much better!).
	set ttyfast                     " Draw faster
	set number relativenumber       " Relative line numbers
	set wildmode=longest,list,full  " Command autocompletion
	filetype indent plugin on       " Enable file type detection.

	syntax on                       " Syntax highlighting
	set showmatch                   " Highlight curlybraces!
	set backspace=indent,eol,start  " Allow backspacing over everything in insert mode.
	set encoding=utf-8              " Use utf-8 when displaying
	set winwidth=120                " Minimum number of columns for current window
	set list listchars=tab:¬\       " Show hidden characters
	set tabstop=2 shiftwidth=2      " Handle <Tab> and indent
	set expandtab
	set splitright splitbelow       " New splits → New splits ↓
	set scrolloff=10                " Show a few lines of context around the cursor.
	set ignorecase                  " ignore case when searching
	set incsearch                   " search as we enter text
	set hlsearch                    " highlight matches

	" Folding
	set foldmethod=indent           " fold on indent level
	set foldignore=                 " don't ignore #
	set foldnestmax=10              " max depth 10
	set foldlevelstart=1            " starting fold level

	" Copy/Paste
	" set clipboard=unnamedplus
	set clipboard=unnamed

	if has("termguicolors")
		let g:base16colorspace=256
		set termguicolors
	endif

" Plugins
	if empty(glob("$XDG_CONFIG_HOME/nvim/autoload/plug.vim"))
		silent !mkdir -p "$XDG_CONFIG_HOME/nvim/autoload"
		silent !curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > "$XDG_CONFIG_HOME/nvim/autoload/plug.vim"
		autocmd VimEnter * PlugInstall --sync
	endif

	call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
		Plug 'airblade/vim-gitgutter'
		Plug 'autozimu/LanguageClient-neovim', {
			\ 'do': ':UpdateRemotePlugins',
		\ }
		Plug 'chriskempson/base16-vim'
		Plug 'christoomey/vim-tmux-navigator'
		" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
		Plug 'prettier/vim-prettier', {
			\ 'do': 'yarn install --frozen-lockfile --production',
			\ 'for': ['javascript', 'typescript*', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'],
		\ }
		Plug 'junegunn/fzf'
		Plug 'junegunn/fzf.vim'
		Plug 'kopischke/vim-fetch'
		Plug 'sheerun/vim-polyglot'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-fugitive'
		Plug 'rust-lang/rust.vim'
		Plug 'wincent/loupe'
	call plug#end()

" LanguageServer
	let g:LanguageClient_useFloatingHover=1
	let g:LanguageClient_hoverPreview='Always'
	let g:LanguageClient_serverCommands = {
		\ 'go': ['~/go/bin/gopls'],
		\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
		\ 'typescript': ['typescript-language-server', '--stdio'],
	\ }

" Polyglot
	let g:vim_markdown_conceal_code_blocks = 0
