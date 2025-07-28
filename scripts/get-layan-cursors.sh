#!/bin/bash

# Create a temporary directory
tmp_dir=$(mktemp -d)

# Clone the repository into this temporary directory
git clone https://github.com/vinceliuice/Layan-cursors.git "$tmp_dir"

# Navigate into the cloned directory
cd "$tmp_dir" || { echo "Error: Unable to access temporary directory"; exit 1; }

# Make the install.sh script executable (just in case)
chmod +x install.sh

# Execute the installation script
./install.sh

# Optional: remove the temporary directory after installation
rm -rf "$tmp_dir"
