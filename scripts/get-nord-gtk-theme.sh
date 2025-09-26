#!/bin/bash

# Script to download and install the Nordic GTK theme by copying files

set -e

# --- CONFIGURATION ---
readonly THEME_NAME="Nordic"
readonly REPO_URL="https://github.com/EliverLara/Nordic.git"
readonly TEMP_DIR="/tmp/nordic-theme-install"
readonly THEMES_DIR="$HOME/.themes"

# --- COLORS ---
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# --- UTILITY FUNCTIONS ---
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# --- MAIN LOGIC ---
main() {
    print_info "Starting installation of the ${THEME_NAME} GTK theme..."

    # 1. Check for git dependency
    if ! command -v git &> /dev/null; then
        print_error "'git' is not installed. Please install it to continue."
        exit 1
    fi

    # 2. Create themes directory if it doesn't exist
    print_info "Ensuring theme directory exists at ${THEMES_DIR}..."
    mkdir -p "${THEMES_DIR}"

    # 3. Clone the repository
    print_info "Cloning ${THEME_NAME} repository into ${TEMP_DIR}..."
    rm -rf "${TEMP_DIR}" # Clean up previous attempts
    git clone "${REPO_URL}" "${TEMP_DIR}" --depth 1

    # 4. Copy theme files
    print_info "Copying theme folders to ${THEMES_DIR}..."
    # Find all directories inside the temp folder that start with "Nordic" and copy them
    find "${TEMP_DIR}" -maxdepth 1 -type d -name "${THEME_NAME}*" -exec cp -r {} "${THEMES_DIR}/" \;

    # 5. Clean up the temporary directory
    print_info "Cleaning up temporary installation files..."
    rm -rf "${TEMP_DIR}"

    print_success "${THEME_NAME} GTK theme and its variants have been installed successfully!"
    echo "You can now apply the theme using your desktop environment's settings or a tweak tool."
}

# --- EXECUTION ---
main "$@"
