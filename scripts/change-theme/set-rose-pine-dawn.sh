# changer le theme du terminal foot a catppuccin macchiato
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/rose-pine-dawn.ini|" ~/.config/foot/foot.ini
# changer le theme du terminal kitty a catppuccin mocha 
echo "include themes/rose-pine-dawn.conf" > ~/.config/kitty/colors.conf

# changer le theme de wofi a catppuccin macchiato
cp ~/.config/wofi/rose-pine-dawn.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/rose-pine-dawn.css ~/.config/sway/waybar/style.css
sed -i 's/"position": ".*"/"position": "top"/' ~/.config/sway/waybar/config-sway
sed -i 's/"height": .*/"height": 30/' ~/.config/sway/waybar/config-sway

#waybar hyprland  
cp ~/.config/hypr/waybar/rose-pine-down.css ~/.config/hypr/waybar/style.css
sed -i 's/"position": ".*"/"position": "top"/' ~/.config/hypr/waybar/config.json
sed -i 's/"height": .*/"height": 30/' ~/.config/hypr/waybar/config.json

# changer le theme de vim a macchiato
sed -i "s|^set background=light|set background=dark|" ~/.vimrc
sed -i "s|^colorscheme .*|colorscheme rosepine_dawn|" ~/.vimrc

# changer le theme de nvim a catppuccin_macchiato 
sed -i "s|theme = .*|theme = \"flexoki-light\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa

# changer le theme de sway a catppuccin catppuccin_macchiato
sed -i "s|^include=./themes/.*|include=./themes/rose-pine-dawn|" ~/.config/sway/config

# changer le theme de mako 
cp ~/.config/mako/rose-pine-dawn ~/.config/mako/config

# ghostty
# sed -i "s|theme=.*|theme=rose-pine-dawn|" ~/.config/ghostty/config
sed -i "/^theme=/s|.*|theme=rose-pine-dawn|" ~/.config/ghostty/config

# gsettings
gsettings set org.gnome.desktop.interface icon-theme 'Luv'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Light'
gsettings set org.gnome.desktop.wm.preferences theme 'Orchis-Light'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10.4'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface cursor-theme 'Layan Cursors'
gsettings set org.gnome.desktop.interface cursor-size 24

echo "" > ~/.config/gtk-3.0/settings.ini
echo  "" > ~/.config/gtk-4.0/settings.ini

# changer le theme kvantum 
sed -i "s|theme=.*|theme=KvArc|" ~/.config/Kvantum/kvantum.kvconfig

# Wallpaper
sed -i "s|output \* bg .*|output * bg ~/.wallpaper/lofi-anime-girl2.png fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/lofi-anime-girl2.png|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/lofi-anime-girl2.png|" ~/.config/hypr/hyprpaper.conf




echo "Thème rose-pine-dawn appliqué avec succès !"
echo "Redémarrez vos applications pour voir les changements."