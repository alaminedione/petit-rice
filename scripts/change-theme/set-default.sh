#!/bin/bash

# This script applies the default theme by calling the specific theme script.
# The default theme is Catppuccin Macchiato.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/set-macchiato.sh"