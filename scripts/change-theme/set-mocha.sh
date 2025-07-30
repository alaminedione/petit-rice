#!/bin/bash

# foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/catppuccin-macchiato.ini|" ~/.config/foot/foot.ini

# kitty
echo "include themes/macchiato.conf" > ~/.config/kitty/colors.conf

# wofi
cp ~/.config/wofi/macchiato.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/macchiato.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/macchiato.css ~/.config/hypr/waybar/style.css

# vim
sed -i "s|^set background=light|set background=dark|" ~/.vimrc
sed -i "s|^colorscheme .*|colorscheme catppuccin_macchiato|" ~/.vimrc

# nvim
sed -i "s|theme = .*|theme = \"catppuccin\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa


# sway
sed -i "s|^include=./themes/.*|include=./themes/catppuccin-mocha|" ~/.config/sway/config

# mako
cp ~/.config/mako/macchiato ~/.config/mako/config

# ghostty
sed -i "/^theme=/s|.*|theme=catppuccin-macchiato|" ~/.config/ghostty/config

# gsettings
gsettings set org.gnome.desktop.interface icon-theme 'Luv'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface cursor-theme 'Layan-white Cursors'
gsettings set org.gnome.desktop.interface cursor-size 24

echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini
echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-4.0/settings.ini

#  kvantum 
sed -i "s|theme=.*|theme=KvArcDark|" ~/.config/Kvantum/kvantum.kvconfig

# Wallpaper
sed -i "s|output \* bg .*|output * bg ~/.wallpaper/lofi-anime-girl2.png fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/lofi-anime-girl2.png|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/lofi-anime-girl2.png|" ~/.config/hypr/hyprpaper.conf

# Fin
echo "Thème Catppuccin Macchiato appliqué avec succès !"
echo "Redémarrez vos applications pour voir les changements."
