# Dotfiles Installation Guide

This guide explains in detail how the `install.sh` script works, its different options, and how to execute it to configure your Linux environment with these dotfiles.

## 🚀 About the `install.sh` Script

The `install.sh` script is an automation tool designed to simplify the deployment of this dotfiles configuration on your system. It handles backing up your existing configurations, installing new configurations, managing software dependencies, applying the default theme, and executing additional configuration scripts.

The goal is to provide a fast, reliable, and interactive installation process.

## 🛠️ Main Features

The `install.sh` script performs the following operations:

1.  **Global Backup of Existing Configurations**:
    *   Before any installation, the script checks for the presence of existing configurations for the covered applications (foot, kitty, nvim, sway, swaylock, waybar, wofi, mako, fastfetch, hypr) as well as some files in the `$HOME` directory (`.aliases.sh`, `.fdignore`, `.tgpt_aliases.sh`, `.vimrc`,  `.vim`, `.zshrc` `.wallpaper`).
    *   If configurations are found, a timestamped backup is created in `$HOME/.config-backups/backup-YYYYMMDD-HHMMSS/`. This ensures that you can always revert to your previous state.
    *   A `backup-info.txt` file is included in each backup, detailing its content.

2.  **Installation of Application Configurations**:
    *   The configuration folders for applications (`foot`, `nvim`, `sway`, `swaylock`, `waybar`, `wofi`, `mako`, `fastfetch`, `hypr`, `ghostty`) are copied from the repository directory to `$HOME/.config/`.
    *   Existing configurations for these applications are deleted before copying to ensure a clean installation.

3.  **Installation of `$HOME` Directory Files**:
    *   Files and folders contained in the `home/` directory of the repository (e.g., `.vimrc`, `.zshrc`, `.aliases.sh`, `.vim/`) are copied directly to your `$HOME` directory.

4.  **Make Scripts Executable**:
    *   All shell scripts (`.sh`) found in the `scripts/` directory of the repository are made executable (`chmod +x`).

5.  **Installation of Utility Scripts**:
    *   Scripts from the `scripts/` directory are copied to `$HOME/.config/petit-rice-scripts/` to make them easily accessible from your system.

6.  **Dependency Installation (Optional)**:
    *   The script can execute `scripts/install-apps.sh` to install the necessary applications and packages for the environment to function correctly. You will be prompted for confirmation.

7.  **Default Theme Application (Optional)**:
    *   The script can apply the `Catppuccin Mocha` theme by executing `scripts/change-theme/set-mocha.sh`. You will be prompted for confirmation.

8.  **Execution of Additional Configuration Scripts (Optional)**:
    *   The script offers to execute several optional scripts for specific configurations (e.g., font correction, Zsh configuration, cursor installation, etc.). Each execution requires confirmation.

## ⚙️ Installation Options

When you run `./install.sh`, an interactive menu will be presented with the following options:

1.  **Complete Installation (recommended)**:
    *   Executes all steps: Global backup, configuration installation, dependency installation, default theme application, and execution of additional scripts.
    *   This is the simplest option for a first complete installation.

2.  **Install Configurations Only**:
    *   Performs the global backup and installs only the application configurations and `$HOME` directory files.
    *   Useful if you have already managed dependencies.

3.  **Install Dependencies Only**:
    *   Only executes the `scripts/install-apps.sh` script to install the necessary applications and packages.
    *   Useful if you want to manage configuration and theme installation separately.

4.  **Apply Default Theme Only**:
    *   Only executes the `scripts/change-theme/set-mocha.sh` script to apply the default theme.
    *   Useful if you have already installed the configurations and dependencies.

5.  **Quit**:
    *   Allows you to exit the script without performing any operations.

## 🚀 How to Execute the Script

To execute the `install.sh` script, follow these steps:

1.  **Clone the repository** (if you haven't already):
    ```bash
    git clone https://github.com/alaminedione/petit-rice.git
    cd petit-rice
    ```

2.  **Make the script executable**:
    ```bash
    chmod +x install.sh
    ```

3.  **Run the script**:
    ```bash
    ./install.sh
    ```

    The interactive menu will appear, allowing you to choose the desired installation option.

## ⚠️ Important Notes

*   **Execution from Repository Directory**: The script must be executed from the root directory of the `petit-rice` repository (where `install.sh` is located).
*   **Session Restart**: After a complete installation, it is highly recommended to restart your session (or your system) for all changes to take effect correctly.
*   **Permissions**: Ensure you have the necessary permissions to install packages and modify configuration files in your `$HOME` directory.
*   **Backups**: Remember that the script creates backups. In case of problems, you can use `restore.sh` to revert to a previous state. Refer to `README-backup-restore.md` for more details on restoration.
