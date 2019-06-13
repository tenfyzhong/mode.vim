#!/bin/bash -
set -e

vim -Nu <(cat << VIMRC
filetype off
set rtp+=~/.vim/bundle/vader.vim
set rtp+=~/.vim/bundle/mode.vim
filetype plugin indent on
syntax enable
VIMRC) -c 'Vader! ~/.vim/bundle/mode.vim/vader/*' > /dev/null

