## ➕ How to Add a New Theme

Adding a new theme involves creating theme-specific configuration files for each application and then creating a shell script to apply these theme files.

Here's a step-by-step guide:

### Step 1: Create Theme Files for Each Application

For each application, you'll need to create a new theme file in its respective theme directory. The naming convention should be consistent (e.g., `your-new-theme.ini`, `your-new-theme.conf`, `your-new-theme.css`).

*   **foot**: Create a `.ini` file in `foot/themes/` (e.g., `foot/themes/your-new-theme.ini`).
*   **wofi**: Create a `.css` file in `wofi/themes` (e.g., `wofi/themes/your-new-theme.css`).
*   **waybar (Hyprland)**: Create a `.css` file in `hypr/waybar/themes` (e.g., `hypr/waybar/themes/your-new-theme.css`).
*   **waybar (Sway)**: Create a `.css` file in `sway/waybar/themes` (e.g., `sway/waybar/themes/your-new-theme.css`).
*   **mako**: Create a configuration file in `mako/themes` (e.g., `mako/themes/your-new-theme`).
*   **sway**: Create a theme directory in `sway/themes/` containing your Sway-specific configurations (e.g., `sway/themes/your-new-theme`).
*   **ghostty**: ghostty support already a lot of themes `ghostty +list-themes`.
*   **vim**: You'll need to install a theme with vim-plug.
*   **nvim**: NvChad support a lot of themes `<leader>th` in nvim.to see all themes.
*   **gsettings**: You'll need to install a theme (cursors, icons, themes).
*   **kvantum**: open Kvantum and add your theme. 
*   **wallpaper**: put your wallpaper in `~/.wallpaper/` .

### Step 2: Create a Theme Application Script

Create a new shell script in `scripts/change-theme/` (e.g., `scripts/change-theme/set-your-new-theme.sh`). This script will be responsible for applying your new theme to all relevant applications.

Here's the template to adapt:

```bash
#!/bin/bash

# foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/your-new-theme.ini|" ~/.config/foot/foot.ini

# wofi
cp ~/.config/wofi/themes/your-new-theme.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/themes/your-new-theme.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/themes/your-new-theme.css ~/.config/hypr/waybar/style.css

# vim
sed -i "s|^colorscheme .*|colorscheme your-new-theme|" ~/.vimrc
# if the theme is dark do this:
sed -i "s|^set background=.*|set background=dark|" ~/.vimrc
# if the theme is light do this:
sed -i "s|^set background=.*|set background=light|" ~/.vimrc

# nvim
sed -i "s|theme = .*|theme = \"your-new-theme\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa


# sway
sed -i "s|^include=./themes/.*|include=./themes/your-new-theme|" ~/.config/sway/config

# mako
cp ~/.config/mako/themes/your-new-theme ~/.config/mako/config

# ghostty
sed -i "/^theme=/s|.*|theme=your-new-theme|" ~/.config/ghostty/config

# gsettings
gsettings set org.gnome.desktop.interface icon-theme 'your-new-theme'
gsettings set org.gnome.desktop.interface color-scheme 'your-new-color-scheme'
gsettings set org.gnome.desktop.interface gtk-theme "your-new-theme"
gsettings set org.gnome.desktop.wm.preferences theme "your-new-theme"
gsettings set org.gnome.desktop.interface font-name 'your-new-font size'
gsettings set org.gnome.desktop.interface document-font-name 'your-new-font size'
gsettings set org.gnome.desktop.interface monospace-font-name 'your-new-font size'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface cursor-theme 'your-new-cursor'
gsettings set org.gnome.desktop.interface cursor-size 'size-cursor'

# if the theme is dark do this:
echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini
echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-4.0/settings.ini
# if the theme is light do this:
echo "" > ~/.config/gtk-3.0/settings.ini
echo "" > ~/.config/gtk-4.0/settings.ini

#  kvantum 
sed -i "s|theme=.*|theme=your-new-theme|" ~/.config/Kvantum/kvantum.kvconfig

# Wallpaper
sed -i "s|output \* bg .*|output * bg ~/.wallpaper/your-new-wallpaper fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/your-new-wallpaper|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/your-new-wallpaper|" ~/.config/hypr/hyprpaper.conf

# Fin
echo "Catppuccin Macchiato theme applied successfully!"
echo "Restart your applications to see the changes."

# reload the configuration
bash "$HOME/.config/petit-rice-scripts/reload-config.sh"

```

Remember to make the new script executable:

```bash
chmod +x scripts/change-theme/set-your-new-theme.sh
```

### Step 3: Test Your New Theme

Run your newly created script:

```bash
./scripts/change-theme/set-your-new-theme.sh
```

Then, restart your applications (or your session) to see the changes take effect.
