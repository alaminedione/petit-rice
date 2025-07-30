## ➕ How to Add a New Theme

Adding a new theme involves creating theme-specific configuration files for each application and then creating a shell script to apply these theme files.

Here's a step-by-step guide:

### Step 1: Create Theme Files for Each Application

For each application, you'll need to create a new theme file in its respective theme directory. The naming convention should be consistent (e.g., `your-new-theme.ini`, `your-new-theme.conf`, `your-new-theme.css`).

*   **foot**: Create a `.ini` file in `foot/themes/` (e.g., `foot/themes/your-new-theme.ini`).
*   **kitty**: Create a `.conf` file in `kitty/themes/` (e.g., `kitty/themes/your-new-theme.conf`).
*   **wofi**: Create a `.css` file in `wofi/` (e.g., `wofi/your-new-theme.css`).
*   **waybar (Hyprland)**: Create a `.css` file in `hypr/waybar/` (e.g., `hypr/waybar/your-new-theme.css`).
*   **waybar (Sway)**: Create a `.css` file in `sway/waybar/` (e.g., `waybar/your-new-theme.css`).
*   **mako**: Create a configuration file in `mako/` (e.g., `mako/your-new-theme`).
*   **sway**: Create a theme directory in `sway/themes/` containing your Sway-specific configurations (e.g., `sway/themes/your-new-theme/config`).
*   **ghostty**: ghostty support already a lot of themes `ghostty +list-themes`.
*   **vim**: You'll need to install a theme with vimp-plug.
*   **nvim**: NvChad support a lot of themes `<leader>th` in nvim.to see all themes.
*   **gsettings**: You'll need to install a theme (cursors, icons, themes).
*   **kvantum**: open Kvantum and add your theme. 
*   **wallpaper**: put your wallpaper in `~/.wallpaper/` .

### Step 2: Create a Theme Application Script

Create a new shell script in `scripts/change-theme/` (e.g., `scripts/change-theme/set-your-new-theme.sh`). This script will be responsible for applying your new theme to all relevant applications.

Here's a template you can adapt:

```bash
#!/bin/bash

# foot
sed -i "s|^include=~/.config/foot/themes/.*|include=~/.config/foot/themes/your-new-theme.ini|" ~/.config/foot/foot.ini

# kitty
echo "include themes/your-new-theme.conf" > ~/.config/kitty/colors.conf

# wofi
cp ~/.config/wofi/your-new-theme.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/your-new-theme.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/your-new-theme.css ~/.config/hypr/waybar/style.css

# vim
sed -i "s|^set background=light|set background=dark|" ~/.vimrc # Adjust 'dark' or 'light' as needed
sed -i "s|^colorscheme .*|colorscheme your_vim_colorscheme|" ~/.vimrc

# nvim
sed -i "s|theme = .*|theme = \"your_nvim_theme\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa # Reload nvim theme

# sway
sed -i "s|^include=./themes/.*|include=./themes/your-new-theme|" ~/.config/sway/config

# mako
cp ~/.config/mako/your-new-theme ~/.config/mako/config

# ghostty
sed -i "s|theme=.*|theme=your-new-theme|" ~/.config/ghostty/config

# gsettings (adjust values as per your theme's light/dark preference and fonts)
gsettings set org.gnome.desktop.interface icon-theme 'YourIconTheme'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' # or 'prefer-light'
gsettings set org.gnome.desktop.interface gtk-theme "YourGtkTheme"
gsettings set org.gnome.desktop.wm.preferences theme "YourGtkTheme"
gsettings set org.gnome.desktop.interface font-name 'YourFontName 10.4'
gsettings set org.gnome.desktop.interface document-font-name 'YourFontName 10.4'
gsettings set org.gnome.desktop.interface monospace-font-name 'YourMonoFontName 10.4'
gsettings set org.gnome.desktop.interface cursor-theme 'YourCursorTheme'

# GTK settings for dark/light preference, make sure that you have a settings.ini file in your ~/.config/gtk-3.0/ and ~/.config/gtk-4.0/ folders
# if your're using a light theme do this :
echo -e "[Settings] \n gtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini  
# if your're using a dark theme do this instead:
echo "" >~/.config/gtk-3.0/settings.ini 
echo "" >~/.config/gtk-4.0/settings.ini

# kvantum
sed -i "s|theme=.*|theme=YourKvantumTheme|" ~/.config/Kvantum/kvantum.kvconfig

# Wallpaper
sed -i "s|output \* bg .*|output * bg ~/.wallpaper/your-wallpaper fill|" ~/.config/sway/config
sed -i -e "s|preload = ~/.wallpaper/.*|preload = ~/.wallpaper/your-wallpaper|" -e "s|wallpaper = ,~/.wallpaper/.*|wallpaper = ,~/.wallpaper/your-wallpaper|" ~/.config/hypr/hyprpaper.conf

echo "Your New Theme applied successfully!"
echo "Restart your applications to see the changes."
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
