#!/bin/bash

# Script to install vim-plug and automatically run PlugInstall

set -e

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "Error: curl is not installed. Please install it before continuing."
  exit 1
fi

# Check if vim is installed
if ! command -v vim &> /dev/null; then
  echo "Error: vim is not installed. Please install it before continuing."
  exit 1
fi

echo "Installing vim-plug..."

# Download plug.vim to the autoload folder (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "vim-plug installed successfully."

echo "Installing Vim plugins via :PlugInstall..."

# Launch vim in batch mode to install plugins
vim +PlugInstall +qall

echo "Plugins installed successfully."
echo "You can now use Vim with your vim-plug managed plugins."
