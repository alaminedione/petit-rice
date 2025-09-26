#!/bin/bash

# This script configures npm to use a user-specific directory for global packages
# and updates the .zshrc file to add the new directory to the system's PATH.

# Set the directory for global npm packages
NPM_GLOBAL_DIR="$HOME/.npm-global"

echo "Creating npm global directory at $NPM_GLOBAL_DIR..."
mkdir -p "$NPM_GLOBAL_DIR/lib"

echo "Configuring npm to use the new prefix..."
npm config set prefix "$NPM_GLOBAL_DIR"

# --- Update .zshrc ---
ZSHRC_FILE="$HOME/.zshrc"
EXPORT_LINE="export PATH=$NPM_GLOBAL_DIR/bin:\$PATH"
COMMENT_LINE="# Set path for globally installed npm packages"

echo "Checking if $ZSHRC_FILE needs to be updated..."

# Check if the comment or the export line is already in .zshrc
if grep -qF -- "$COMMENT_LINE" "$ZSHRC_FILE" || grep -qF -- "$NPM_GLOBAL_DIR/bin" "$ZSHRC_FILE"; then
    echo "npm global path seems to be already configured in $ZSHRC_FILE."
else
    echo "Adding npm global path to $ZSHRC_FILE..."
    # Append the configuration to .zshrc
    {
        echo ""
        echo "$COMMENT_LINE"
        echo "$EXPORT_LINE"
    } >> "$ZSHRC_FILE"
    echo "Successfully updated $ZSHRC_FILE."
    echo "Please run 'source $ZSHRC_FILE' or restart your shell to apply the changes."
fi

echo "npm configuration is complete."