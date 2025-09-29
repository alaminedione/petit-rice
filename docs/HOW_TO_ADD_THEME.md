## ➕ How to Add a New Theme

Adding a new theme involves finding a color palette, creating theme-specific configuration files for each application, and then creating a shell script to apply these theme files.

Here's a step-by-step guide:

### Step 1: Find a Color Palette

Before you start, you need the color palette for your new theme. Most popular themes (like Nord, Gruvbox, Catppuccin, etc.) have official websites where you can find their color palettes with hex codes.

A web search for `"<your-theme-name> color palette"` should give you what you need.

### Step 2: Create Theme Files for Each Application

For each application, you'll need to create a new theme file in its respective theme directory. Use the color palette you found in Step 1. The naming convention should be consistent (e.g., `your-new-theme.ini`, `your-new-theme.conf`, `your-new-theme.css`).

*   **foot**: Create a `.ini` file in `foot/themes/`.
*   **wofi**: Create a `.css` file in `wofi/themes`.
*   **waybar (Hyprland & Sway)**: Create `.css` files in `hypr/waybar/themes` and `sway/waybar/themes`.
*   **mako**: Create a configuration file in `mako/themes`.
*   **sway**: Create a theme file in `sway/themes/`.
*   **hyprland**: Create a `.conf` file in `hypr/themes/`.
*   **ghostty**: Check if the theme is already supported with `ghostty --list-themes`.
*   **vim / nvim**: You may need to install a plugin for the theme.
*   **gsettings**: You'll need to install GTK themes, icon themes, and cursor themes separately.
*   **kvantum**: You may need to install a Kvantum theme separately.
*   **wallpaper**: Place your wallpaper in `home/.wallpaper/`.
*   **rmpc**: Create a `.ron` file in `rmpc/themes`.

### Step 3: Create a Theme Application Script

Create a new shell script in `scripts/change-theme/` (e.g., `set-your-new-theme.sh`). This script will apply your new theme to all relevant applications.

Here's a template to adapt:

```bash
#!/bin/bash

# Sway
sed -i "s|^include ./themes/.*|include ./themes/your-new-theme|" ~/.config/sway/config

# Hyprland
cp ~/.config/hypr/themes/your-new-theme.conf ~/.config/hypr/colors.conf

# Foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/your-new-theme.ini|" ~/.config/foot/foot.ini

# Wofi
cp ~/.config/wofi/themes/your-new-theme.css ~/.config/wofi/style.css

# Waybar (Sway)
cp ~/.config/sway/waybar/themes/your-new-theme.css ~/.config/sway/waybar/style.css

# Waybar (Hyprland)
cp ~/.config/hypr/waybar/themes/your-new-theme.css ~/.config/hypr/waybar/style.css

# Mako
cp ~/.config/mako/themes/your-new-theme ~/.config/mako/config

# Ghostty
sed -i "/^theme=/s|.*|theme=your-new-theme|" ~/.config/ghostty/config

# Vim
# For a dark theme:
sed -i "s|^set background=.*|set background=dark|" ~/.vimrc
sed -i "s|^colorscheme .*|colorscheme your-new-theme|" ~/.vimrc
# For a light theme:
# sed -i "s|^set background=.*|set background=light|" ~/.vimrc

# Nvim
sed -i "s|theme = .*|theme = \"your-new-theme\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require(\"base46\").load_all_highlights()'

# GSettings (GTK, Icons, etc.)
gsettings set org.gnome.desktop.interface gtk-theme "your-new-theme"
gsettings set org.gnome.desktop.interface icon-theme "your-new-icon-theme"
gsettings set org.gnome.desktop.interface cursor-theme "your-new-cursor-theme"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.wm.preferences theme "your-new-theme"
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface cursor-size 24

# Wallpaper
sed -i "s|output * bg .*|output * bg ~/.wallpaper/your-new-wallpaper.png fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/your-new-wallpaper.png|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/your-new-wallpaper.png|" ~/.config/hypr/hyprpaper.conf

# RMPC
sed -i 's|theme:Some.*|theme:Some(\"your-new-theme\"),|' ~/.config/rmpc/config.ron

# Kvantum
kvantummanager --set YourNewKvantumTheme

# Reload the configuration
bash "$HOME/.config/petit-rice-scripts/reload-config.sh"

# Fin
echo "Your New Theme applied successfully!"
echo "Restart your applications to see the changes."
```

Remember to make the new script executable:
`chmod +x scripts/change-theme/set-your-new-theme.sh`

### Step 4: Test Your New Theme

The easiest way to apply your new theme is to use the theme selector:
*   Press `Super + t` to open Wofi.
*   Select your new theme from the list.

Alternatively, you can run your script directly from the terminal:
`./scripts/change-theme/set-your-new-theme.sh`

Restart your applications or your session to ensure all changes are applied correctly.