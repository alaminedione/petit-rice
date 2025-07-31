#!/bin/bash

# Automatic installation of Luv Icon Theme in the user's directory

# verify that the icon theme is not already installed
if [ -d "$HOME/.icons/Luv/" ]; then
	echo "Luv icon theme is already installed. Skipping..."
	exit 0
fi


set -e


# Variables
REPO_URL="https://github.com/Nitrux/luv-icon-theme.git"
TEMP_DIR="/tmp/luv-icon-theme"
USER_ICON_DIR="$HOME/.local/share/icons"
MAX_RETRIES=3
RETRY_DELAY=5

# Cleanup function
cleanup() {
    [ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"
}

# Error handling and cleanup on interruption
trap 'echo "Error: Installation interrupted" >&2; cleanup; exit 1' ERR INT TERM

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed" >&2
    exit 1
fi

# Clean up the temporary directory if it exists
cleanup

# Function to download with retries
download_with_retry() {
    local attempt=1
    
    while [ $attempt -le $MAX_RETRIES ]; do
        echo "Downloading theme (attempt $attempt/$MAX_RETRIES)..."
        
        if git clone "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
            echo "Download successful"
            return 0
        else
            echo "Download failed" >&2
            
            if [ $attempt -lt $MAX_RETRIES ]; then
                echo "Retrying in $RETRY_DELAY seconds..." >&2
                sleep $RETRY_DELAY
                cleanup
            fi
        fi
        
        ((attempt++))
    done
    
    echo "Error: Unable to download after $MAX_RETRIES attempts" >&2
    return 1
}

# Download with retries
if ! download_with_retry; then
    exit 1
fi

# Check if the Luv folder exists
if [ ! -d "$TEMP_DIR/Luv" ]; then
    echo "Error: Luv folder not found in the repository" >&2
    cleanup
    exit 1
fi

# Create the installation directory
if ! mkdir -p "$USER_ICON_DIR" 2>/dev/null; then
    echo "Error: Unable to create installation directory" >&2
    cleanup
    exit 1
fi

# Copy theme files
if ! cp -r "$TEMP_DIR/Luv" "$USER_ICON_DIR/" 2>/dev/null; then
    echo "Error: Unable to copy files" >&2
    cleanup
    exit 1
fi

# Update icon cache if possible
command -v gtk-update-icon-cache &> /dev/null && gtk-update-icon-cache "$USER_ICON_DIR/Luv" 2>/dev/null || true

# Clean up
cleanup

echo "Luv Icon Theme installed in $USER_ICON_DIR"
