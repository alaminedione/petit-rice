<div align="center">
    <h1>【 petit-rice 】</h1>
    <h2> Hyprland and Sway </h2>
    <h3>Compatible exclusively with Arch-based distributions </h3>
    <h3>Currently in development — please do not use yet unless you are an expert</h3>
</div>


<div align="center"> 

![](https://img.shields.io/github/last-commit/alaminedione/petit-rice?&style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B)
![](https://img.shields.io/github/stars/alaminedione/petit-rice?style=for-the-badge&logo=andela&color=86dbd7&logoColor=D9E0EE&labelColor=1E202B)
![](https://img.shields.io/github/repo-size/alaminedione/petit-rice?color=86dbce&label=SIZE&logo=protondrive&style=for-the-badge&logoColor=D9E0EE&labelColor=26230e)
</div>


The main reason I created this configuration is to make my system easily reproducible. I particularly enjoy minimalist, clean, and highly productive setups. This repository reflects my desire for an environment that is simple to replicate, while remaining elegant and efficient.

I've created a script (`install.sh`) that allows for a quick installation of my work environment, as well as backup and restoration capabilities.

## 📸 Screenshots

<div align="center">

### Desktop Overview
![Desktop Screenshot](screenshoot/screenshot-20250730-045141.png)

### Terminal
![Application Launcher](screenshoot/screenshot-20250730-045152.png)

### File Manager
![Terminal View](screenshoot/screenshot-20250730-045203.png)

### Application Launcher
![Workspace](screenshoot/screenshot-20250730-045210.png)

### Neovim
![System Info](screenshoot/screenshot-20250730-045343.png)

</div>


## 🎨 Supported Themes

Currently supported themes:
*   `catppuccin-macchiato` (dark)
*   `rose-pine-dawn` (light)
*   `gruvbox-dark`

Themes under development:
*   `catppuccin-mocha`
*   `catppuccin-latte`
*   `catppuccin-frappe`
*   `rose-pine-moon` (dark)
*   `gruvbox-light`
*   `nord`

## 🚀 Covered Applications

This configuration covers the following applications:
*   **Terminal Emulators**: `foot`, `ghostty`
*   **Bar**: `waybar`
*   **Notifications**: `mako`
*   **Application Launcher**: `wofi`
*   **Text Editors**: `nvim`, `vim`
*   **File Manager**: `yazi`, `Thunar`
*   **Archive Manager**: `file-roller`
*   **System Info**: `fastfetch`
*   **Music Player**: `rmpc` https://mierak.github.io/rmpc/

Neovim (Nvchad + AI) : A highly optimized configuration providing full-featured development environments for JavaScript/TypeScript, React, VueJS, Html, Css,  Lua, Python, Go, Rust, Java, C, C++, and other languages, including Language Server Protocol (LSP) integration, debugging, linting, and auto-completion.


## ⚙️ Installation

To get started, clone the repository and run the installation script:

```bash
git clone --depth 1 https://github.com/alaminedione/petit-rice.git
cd petit-rice
./install.sh
```

You may want to deactivate the blue light filter or modify the values.
For Hyprland, comment out the line ` exec wlsunset -t 5700 -T 5800 -l 14.71 -L -17.46 &` in `~/.config/hypr/hyprland.conf`.
For Sway, comment out the line `exec = hyprsunset` in `~/.config/sway/config`.
Restart your session.

You will need to change the time zone in the `clock` module of the Waybar configuration files: `~/.config/hypr/waybar/config.json` and `~/.config/sway/waybar/config-sway`

For a detailed explanation of the `install.sh` script, its options, and how to use it, please refer to the  [Installation Guide ](docs/GUIDE_INSTALLATION.md).

For a complete and up-to-date list of keybindings, please refer to the [Keybindings Guide](docs/KEYBINDINGS.md).

For more detailed information on backup and restoration, please refer to the [Backup and Restore Guide](docs/BACKUP_AND_RESTORE.md).

## 🎨 How to Change Themes

change the theme with the keybinding `super + t`

After changing a theme, it's recommended to restart your applications or session to see all changes applied.

For a detailed guide on how to add a new theme, please refer to the [How to Add a New Theme Guide](docs/HOW_TO_ADD_THEME.md).


## ⚠️ Important Notes

*   **Restart Required**: After installation or restoration, it's recommended to restart your session to apply all changes.
*   **Permissions**: Ensure that `install.sh` and `restore.sh` are executable (`chmod +x install.sh restore.sh`).

## 🤝 Support and Contributions

For any issues or suggestions, please open an issue on the project's GitHub repository.
Feel free to contribute to the project by submitting pull requests or opening issues.

