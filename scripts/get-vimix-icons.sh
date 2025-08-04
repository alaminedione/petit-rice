#!/bin/bash

# Clone the vimix icon theme repository
git clone --depth 1 https://github.com/vinceliuice/vimix-icon-theme
cd vimix-icon-theme
chmod +x install.sh
./install.sh -a

# Remove the temporary directory
cd ..
rm -rf vimix-icon-theme

