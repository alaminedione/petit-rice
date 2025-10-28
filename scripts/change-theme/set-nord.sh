#!/bin/bash

# sway
sed -i "s|^include ./themes/.*|include ./themes/nord|" ~/.config/sway/config

# hyprland
cp ~/.config/hypr/themes/nord.conf ~/.config/hypr/colors.conf


# foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/nord.ini|" ~/.config/foot/foot.ini

# wofi
cp ~/.config/wofi/themes/nord.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/themes/nord.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/themes/nord.css ~/.config/hypr/waybar/style.css

# vim
sed -i "s|^set background=.*|set background=dark|" ~/.vimrc
sed -i "s|^colorscheme .*|colorscheme nord|" ~/.vimrc

# nvim
sed -i "s|theme = .*|theme = \"nord\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require(\"base46\").load_all_highlights()' +qa


# mako
cp ~/.config/mako/themes/nord ~/.config/mako/config

# ghostty
sed -i "/^theme=/s|.*|theme=Nord|" ~/.config/ghostty/config

# gsettings
gsettings set org.gnome.desktop.interface icon-theme 'Luv'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"

# Police d'interface (menus, boutons, titres de fenêtres)
gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'

# Police de documents (lecture, texte courant)
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 12'

# Police monospace (terminal, code)
gsettings set org.gnome.desktop.interface monospace-font-name 'Noto Sans Mono 11'

gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface cursor-theme 'Layan-white Cursors'
gsettings set org.gnome.desktop.interface cursor-size 24

echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini
echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-4.0/settings.ini

#  kvantum 
mkdir -p "$HOME/.config/Kvantum"
kvantummanager --set KvArcDark

# Wallpaper
sed -i "s|output * bg .*|output * bg ~/.wallpaper/wall-05_1.webp fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/wall-05_1.webp|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/wall-05_1.webp|" ~/.config/hypr/hyprpaper.conf

#rmpc
sed -i 's|theme:Some.*|theme:Some(\"nord\"),|' ~/.config/rmpc/config.ron

# Fin
echo "Nord theme applied successfully!"
echo "Restart your applications to see the changes."

# reload the configuration
bash "$HOME/.config/petit-rice-scripts/reload-config.sh"
