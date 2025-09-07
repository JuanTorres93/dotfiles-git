"     _                     _____
"    | |_   _  __ _ _ __   |_   _|__  _ __ _ __ ___  ___
" _  | | | | |/ _` | '_ \    | |/ _ \| '__| '__/ _ \/ __|
"| |_| | |_| | (_| | | | |   | | (_) | |  | | |  __/\__ \
" \___/ \__,_|\__,_|_| |_|   |_|\___/|_|  |_|  \___||___/
"
"						~/.vimrc


set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sheerun/vim-polyglot'
Plugin 'AlessandroYorba/Alduin'
Plugin 'dracula/vim'
Plugin 'mhartington/oceanic-next'
Plugin 'rust-lang/rust.vim'
Plugin 'xuhdev/vim-latex-live-preview'
" Consult YouCompleteMe github page in order to install it correctly
"Plugin 'ycm-core/YouCompleteMe'
" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required

" Enable systax highliting
syntax on

"======== Plugins configuration =========
" vim-airline-themes
let g:airline_theme='onedark'
colo dracula

" vim-latex-live-preview
let g:livepreview_previewer = 'zathura'

" vimtex
" let g:tex_flavor ='latex'

"======== Vim parameters configuration =========
set number
set relativenumber
set cursorline
set incsearch
set ruler
set hlsearch
set ignorecase
set title
set foldlevel=10
set foldmethod=indent
set viminfo+=n~/.vim/viminfo

set splitbelow splitright
set clipboard=unnamedplus

set lazyredraw	" Don't update screen during macro and script execution

"======== General bindings configuration =========
" Move between splits with Crtl+key
map <C-l> <C-W>l
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k

