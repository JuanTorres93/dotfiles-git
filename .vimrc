" This two lines are needed in order to get pathogen functional
execute pathogen#infect()
" In addition, filetype allows the detection of different file types
filetype plugin indent on
"
" Do not make compatible with vi
set nocompatible              
" Enable systax highliting
syntax on

"======== Plugin configurations =========
" vim-airline-themes
let g:airline_theme='onedark'
colo iceberg
"colo minimalist
let g:livepreview_previewer = 'zathura'
"======= End plugin configurations ======= 

set number
set relativenumber
set cursorline
set incsearch
set ruler
set hlsearch
set ignorecase
set title
set foldlevel=0
set foldmethod=indent
set backup
set backupdir=~/.vim/backups
set viminfo+=n~/.vim/viminfo

set splitbelow splitright
set clipboard=unnamedplus

" General bindings
" Move between splits with Crtl+key
map <C-l> <C-W>l
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k

" General bindings in normal mode
nnoremap <F11> :set spell spelllang=es <Return>
nnoremap <F12> :set spell spelllang=en <Return>
nnoremap ++ "+P
nnoremap ** "*P
" Go to place holder
inoremap <Space><Space> <Esc>/<++><Return>"_c4l
" Write  place holder
inoremap ;;ph <++>
imap ww <Esc>
vmap ww <Esc>

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
" Python
autocmd FileType py nnoremap ;;c @='I#<C-V><Esc>j'<CR> 
autocmd FileType py nnoremap ;;u @='^x<C-V><Esc>j'<CR> 
" Bash
autocmd FileType sh nnoremap ;;c @='I#<C-V><Esc>j'<CR> 
autocmd FileType sh nnoremap ;;u @='^x<C-V><Esc>j'<CR> 


" LaTeX bindings
" Preview with vim-latex-live-preview
autocmd FileType tex nnoremap ;prev :LLPStartPreview
" Compilation with texlive
autocmd FileType tex nnoremap ;comp :!pdflatex -synctex=1 -interaction=nonstopmode *.tex
" LaTeX environment snippets (WORK IN PROGRESS)
autocmd FileType tex inoremap ;env <Esc>:r !LatexSnippets env<Return><Esc><Esc>i
" LaTeX mathematic snippets (WORK IN PROGRESS)
"autocmd FileType tex inoremap ;mat <Esc>:r !LatexSnippets mat<Return><Esc><Esc>i
autocmd FileType tex inoremap ;mat <Return><Esc>:-1r !LatexSnippets mat<Return>kA<Del><Esc>A<Del><Esc><Esc>i
" LaTeX section snippets (WORK IN PROGRESS)
autocmd FileType tex inoremap ;sec <Esc>:r !LatexSnippets sec<Return><Esc><Esc>i
" LaTeX image snippets (WORK IN PROGRESS)
autocmd FileType tex inoremap ;img <Esc>:r !LatexSnippets img<Return><Esc><Esc>i
" LaTeX Reference snippets (WORK IN PROGRESS)
autocmd FileType tex inoremap ;ref <Return><Esc>:-1r !LatexSnippets ref<Return>kA<Del><Esc>A<Del><Esc><Esc>i
" LaTeX table snippets (WORK IN PROGRESS)
autocmd FileType tex inoremap ;tab <Esc>:r !LatexSnippets tab<Return><Esc><Esc>i
autocmd FileType tex inoremap ;;<Space> \;<Space>
autocmd FileType tex inoremap ;ni \item 
autocmd FileType tex inoremap ;nb \bibitem{bib:<++>}<Space>\textsc{<++>}<Space>\textit{<++>}
"" Italics
autocmd FileType tex inoremap ;;i \textit{} <++><Esc>F{a
" Bold text
autocmd FileType tex inoremap ;;b \textbf{} <++><Esc>F{a
" Create new command
autocmd FileType tex inoremap ;;nc \newcommand{\}[<++>]{<++>}<Esc>F}i




" Rust files (.rs)
autocmd FileType rust inoremap ;F <Esc>:RustFmt<CR>
