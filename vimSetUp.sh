#!/bin/bash

vimDir="$HOME/.vim"
mkdir -p "$vimDir"/{autoload,bundle}

# Install pathogen
curl -LSso "$vimDir"/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install plugins
cd "$vimDir"/bundle
git clone https://github.com/xuhdev/vim-latex-live-preview  
git clone https://github.com/vim-airline/vim-airline 
git clone https://github.com/vim-airline/vim-airline-themes 
git clone https://github.com/sheerun/vim-polyglot 
git clone https://github.com/AlessandroYorba/Alduin
git clone https://github.com/skammer/vim-css-color
git clone https://github.com/rust-lang/rust.vim
