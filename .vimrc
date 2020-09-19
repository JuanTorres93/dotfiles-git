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
Plugin 'rust-lang/rust.vim'
Plugin 'xuhdev/vim-latex-live-preview'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Enable systax highliting
syntax on

"======== Plugins configuration =========
" vim-airline-themes
let g:airline_theme='onedark'
colo alduin

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

" General purpose bindings in normal mode
nnoremap <F11> :set spell spelllang=es <Return>
nnoremap <F12> :set spell spelllang=en <Return>
nnoremap ++ "+P
nnoremap ** "*P

" Write  place holder
inoremap ;PH <++>
" Go to place holder
inoremap <Space><Space> <Esc>/<++><Return>"_c4l

" Comments for each fileType
" LaTeX
autocmd FileType tex nnoremap ;;c @='I%<C-V><Esc>j'<CR> 
autocmd FileType tex nnoremap ;;u @='^x<C-V><Esc>j'<CR> 
" Rust
autocmd FileType rust nnoremap ;;c @='I//<C-V><Esc>j'<CR> 
autocmd FileType rust nnoremap ;;u @='^2x<C-V><Esc>j'<CR> 
" C
autocmd FileType c nnoremap ;;c @='I//<C-V><Esc>j'<CR> 
autocmd FileType c nnoremap ;;u @='^2x<C-V><Esc>j'<CR> 
" C++
autocmd FileType cpp nnoremap ;;c @='I//<C-V><Esc>j'<CR> 
autocmd FileType cpp nnoremap ;;u @='^2x<C-V><Esc>j'<CR> 
" Haskell
autocmd FileType haskell nnoremap ;;c @='I--<C-V><Esc>j'<CR> 
autocmd FileType haskell nnoremap ;;u @='^2x<C-V><Esc>j'<CR> 
" Python
autocmd FileType python nnoremap ;;c @='I#<C-V><Esc>j'<CR> 
autocmd FileType python nnoremap ;;u @='^x<C-V><Esc>j'<CR> 
" Bash
autocmd FileType sh nnoremap ;;c @='I#<C-V><Esc>j'<CR> 
autocmd FileType sh nnoremap ;;u @='^x<C-V><Esc>j'<CR> 


"======== LaTeX bindings configuration =========
" Preview with vim-latex-live-preview
autocmd FileType tex nnoremap ;PREV :LLPStartPreview<Return>
" Compilation with texlive
autocmd FileType tex nnoremap ;COMP :!pdflatex -synctex=1 -interaction=nonstopmode *.tex<Return>

" LaTeX environment snippets 
autocmd FileType tex inoremap ;EE <Esc>:r !LatexSnippets env<Return><Esc><Esc>i
" LaTeX mathematic snippets
autocmd FileType tex inoremap ;MM <Return><Esc>:-1r !LatexSnippets mat<Return>kA<Del><Esc>A<Del><Esc><Esc>i
" LaTeX section snippets
autocmd FileType tex inoremap ;SS <Esc>:r !LatexSnippets sec<Return><Esc><Esc>i
" LaTeX image snippets
autocmd FileType tex inoremap ;II <Esc>:r !LatexSnippets img<Return><Esc><Esc>i
autocmd FileType tex inoremap ;FF <Esc>:r !LatexSnippets fig<Return><Esc><Esc>i
autocmd FileType tex inoremap ;WF <Esc>:r !LatexSnippets wrapfig<Return><Esc><Esc>i
" LaTeX Reference snippets 
autocmd FileType tex inoremap ;RR <Return><Esc>:-1r !LatexSnippets ref<Return>kA<Del><Esc>A<Del><Esc><Esc>i
" LaTeX Bibliography Reference snippets 
autocmd FileType tex inoremap ;RB <Return><Esc>:-1r !LatexSnippets bib<Return>kA<Del><Esc>A<Del><Esc><Esc>i
" LaTeX table snippets 
autocmd FileType tex inoremap ;TT <Esc>:r !LatexSnippets tab<Return><Esc><Esc>i

autocmd FileType tex inoremap ;;<Space> \;<Space>
autocmd FileType tex inoremap ;NI \item 
autocmd FileType tex inoremap ;NB \bibitem{bib:<++>}<Space>\textsc{<++>}<Space>\textit{<++>}
"" Italics
autocmd FileType tex inoremap ;IT \textit{} <++><Esc>F{a
" Bold text
autocmd FileType tex inoremap ;BO \textbf{} <++><Esc>F{a
" Create new command
autocmd FileType tex inoremap ;NC \newcommand{\}[<++>]{<++>}<Esc>F}i




"======== Rust bindings configuration =========
" Compile code
autocmd FileType rust nnoremap ;CB :!cargo build<Return>
" Compile and run code
autocmd FileType rust nnoremap ;CR :!cargo run<Return>
" Run tests
autocmd FileType rust nnoremap ;CT :!cargo test<Return>
" Save session
autocmd FileType rust nnoremap ;SS :mks! ~/.vim/sessions/rust-session.vim<Return>
" Load session
autocmd FileType rust nnoremap ;LS :source ~/.vim/sessions/rust-session.vim<Return>
" Rust files (.rs)
autocmd FileType rust nnoremap ;F :RustFmt<CR>
" Create function
autocmd FileType rust inoremap ;FN fn (<++>) -> <++> {<Return><++><Return>}<Esc>2k0ea<Space>
" Insert println!
autocmd FileType rust inoremap ;PR println!("");<Esc>2hi
" Create struct
autocmd FileType rust inoremap ;ST struct {<Return><++>,<Return>}<Return><Return>impl <++> {<Return><++><Return>}<Esc>6k0ea<Space>
" Insert for
autocmd FileType rust inoremap ;FOR for in <++> {<Return><++><Return>}<Esc>2k0ea<Space>
" Insert if
autocmd FileType rust inoremap ;IF if {<Return><++><Return>}<Esc>2k0ea<Space>
" Create match
autocmd FileType rust inoremap ;MATCH match {<Return><++> => <++>,<Return>}<Esc>2k0ea<Space>
" Insert arg from clap crate
autocmd FileType rust inoremap ;ARG .arg(<Return>Arg::with_name("<++>")<Return>.short("<++>")<Return>.long("<++>")<Return>.multiple(<++>)<Return>.takes_value(<++>)<Return>.help("<++>")<Return>.required(<++>)<Return>)
