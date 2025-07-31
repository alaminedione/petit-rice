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
*   **vim**: You'll need to install a theme with vim-plug.
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

# wofi
cp ~/.config/wofi/your-new-theme.css ~/.config/wofi/style.css

# waybar sway
cp ~/.config/sway/waybar/your-new-theme.css ~/.config/sway/waybar/style.css

# waybar hyprland
cp ~/.config/hypr/waybar/your-new-theme.css ~/.config/hypr/waybar/style.css

# mako
cp ~/.config/mako/your-new-theme ~/.config/mako/config

# ghostty
sed -i "s|theme=.*|theme=your-new-theme|" ~/.config/ghostty/config

# nvim
sed -i "s|theme = .*|theme = \"your_nvim_theme\",|" ~/.config/nvim/lua/chadrc.lua
nvim --headless +'lua require("base46").load_all_highlights()' +qa # Reload nvim theme

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
