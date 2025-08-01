#!/bin/bash

# sway
sed -i "s|^include ./themes/.*|include ./themes/catppuccin-macchiato|" ~/.config/sway/config

# hyprland
cp ~/.config/hypr/themes/catppuccin-macchiato.conf ~/.config/hypr/colors.conf


# foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/catppuccin-macchiato.ini|" ~/.config/foot/foot.ini

# wofi
cp ~/.config/wofi/themes/macchiato.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/themes/macchiato.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/themes/macchiato.css ~/.config/hypr/waybar/style.css

# vim
sed -i "s|^set background=.*|set background=dark|" ~/.vimrc
sed -i "s|^colorscheme .*|colorscheme catppuccin_macchiato|" ~/.vimrc

# nvim
sed -i "s|theme = .*|theme = \"catppuccin\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa


# sway
sed -i "s|^include=./themes/.*|include=./themes/catppuccin-mocha|" ~/.config/sway/config

# mako
cp ~/.config/mako/themes/macchiato ~/.config/mako/config

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
echo "Catppuccin Macchiato theme applied successfully!"
echo "Restart your applications to see the changes."

# reload the configuration
bash "$HOME/.config/petit-rice-scripts/reload-config.sh"
