#!/bin/bash


# sway
sed -i "s|^include ./themes/.*|include ./themes/gruvbox-dark|" ~/.config/sway/config

# hyprland
cp ~/.config/hypr/themes/gruvbox-dark.conf ~/.config/hypr/colors.conf

# foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/gruvbox-dark.ini|" ~/.config/foot/foot.ini

# wofi
cp ~/.config/wofi/themes/gruvbox-dark.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/themes/gruvbox-dark.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/themes/gruvbox-dark.css ~/.config/hypr/waybar/style.css

# mako
cp ~/.config/mako/themes/gruvbox-dark ~/.config/mako/config

# ghostty
sed -i "/^theme=/s|.*|theme=GruvboxDark|" ~/.config/ghostty/config

# vim
sed -i "s|^set background=.*|set background=dark|" ~/.vimrc
sed -i "s|^colorscheme .*|colorscheme gruvbox|" ~/.vimrc

# nvim
sed -i "s|theme = .*|theme = \"gruvchad\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa

# Wallpaper
sed -i "s|output \* bg .*|output * bg ~/.wallpaper/lofi-anime-girl2.png fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/lofi-anime-girl2.png|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/lofi-anime-girl2.png|" ~/.config/hypr/hyprpaper.conf


# gsettings
gsettings set org.gnome.desktop.interface icon-theme 'Vimix'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Gruvbox-Dark"
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface cursor-theme 'Layan-white Cursors'
gsettings set org.gnome.desktop.interface cursor-size 24

echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini
echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-4.0/settings.ini

#  kvantum 
mkdir -p "$HOME/.config/Kvantum"
kvantummanager --set KvArcDark

#rmpc
sed -i 's|theme:Some.*|theme:Some("gruvbox-dark"),|' ~/.config/rmpc/config.ron

echo "Gruvbox Dark theme applied successfully!"
echo "Restart your applications to see the changes."

# reload the configuration
bash "$HOME/.config/petit-rice-scripts/reload-config.sh"
