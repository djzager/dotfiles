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
	set termguicolors
endif
