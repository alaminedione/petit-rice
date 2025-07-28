# Dotfiles Backup and Restore System

This system offers a complete solution for backing up and restoring your dotfiles configurations with a unique backup folder and a flexible restoration system.

## 🚀 Features

### Global Backup
- **Single backup folder** with timestamp for all configurations
- **Automatic backup** before each installation
- **Information file** detailing the content of each backup
- **Preservation of file and folder structure**

### Flexible Restoration
- **Interactive menu** to select a backup
- **Restoration by specific timestamp**
- **Automatic safety backup** before restoration
- **Backup management** (list, details, deletion, cleanup)

## 📁 Backup Structure

The backup system creates a timestamped directory for each backup, containing the configurations of all managed applications and relevant home directory files.

```
~/.config-backups/
├── backup-YYYYMMDD-HHMMSS/
│   ├── backup-info.txt
│   ├── foot/
│   ├── kitty/
│   ├── nvim/
│   ├── sway/
│   ├── swaylock/
│   ├── wofi/
│   ├── mako/
│   ├── fastfetch/
│   ├── hypr/
│   ├── home/
│   │   ├── .aliases.sh
│   │   ├── .fdignore
│   │   ├── .tgpt_aliases.sh
│   │   ├── .vimrc
│   │   ├── .viminfo
│   │   └── .vim/
│   └── hotfiles-scripts/
├── backup-YYYYMMDD-HHMMSS/
│   └── ...
└── safety-backup-YYYYMMDD-HHMMSS/
    └── ...
```

## 🔧 Installation

To install these dotfiles, you will use the `install.sh` script. This script automatically creates a global backup of all your existing configurations before proceeding with the installation.

### Complete Installation
```bash
./install.sh
```

### Installation Options
When you run `./install.sh`, an interactive menu will be presented with the following options:

1.  **Complete Installation (recommended)**: Executes all steps: Global backup, configuration installation, dependency installation, default theme application, and execution of additional scripts.
2.  **Install Configurations Only**: Performs the global backup and installs only the application configurations and `$HOME` directory files.
3.  **Install Dependencies Only**: Only executes the `scripts/install-apps.sh` script to install the necessary applications and packages.
4.  **Apply Default Theme Only**: Only executes the `scripts/change-theme/set-mocha.sh` script to apply the default theme.
5.  **Quit**: Allows you to exit the script without performing any operations.

## 🔄 Restoration

### Interactive Menu
```bash
./restore.sh
```

Displays a menu with all available backups and their details.

### Direct Restoration
```bash
./restore.sh 20240127-143052
```

Directly restores the backup specified by its timestamp.

### Management Commands

#### List Backups
```bash
./restore.sh list
```

#### Show Details
```bash
./restore.sh details 20240127-143052
```

#### Delete a Backup
```bash
./restore.sh delete 20240127-143052
```

#### Clean Up Old Backups
```bash
./restore.sh cleanup
```
Automatically deletes the oldest backups (keeps the 10 most recent).

#### Help
```bash
./restore.sh help
```

## 🛡️ Security

### Safety Backup
Before each restoration, the script automatically creates a safety backup of your current configurations. This backup is named `safety-backup-<timestamp>` and can be used to undo a restoration.

### Security Flow Example
1. You restore a backup from 01/27 at 14:30
2. The script automatically creates `safety-backup-20240127-160145`
3. If you want to undo: `./restore.sh 20240127-160145`

## 📋 Managed Configurations

The system automatically backs up and restores:

- **Terminal Applications**: foot, kitty
- **Editors**: nvim
- **Window Managers**: sway, hypr
- **Status Bars**: waybar
- **Launchers**: wofi
- **Security**: swaylock
- **Notifications**: mako
- **System**: fastfetch
- **Utility Scripts**: hotfiles-scripts

## 🔍 Backup Information

Each backup contains a `backup-info.txt` file with:
- Creation date and time
- Unique timestamp
- Script used for creation
- List of backed-up configurations
- Source directory

## ⚠️ Important Notes

1. **Restart Required**: After a restoration, restart your session to apply all changes.

2. **Timestamp Format**: Timestamps follow the `YYYYMMDD-HHMMSS` format (e.g., `20240127-143052`).

3. **Disk Space**: Backups can take up space. Use `./restore.sh cleanup` regularly.

4. **Permissions**: Ensure that the scripts are executable (`chmod +x install.sh restore.sh`).

## 🐛 Troubleshooting

### Problem: "Backup not found"
- Verify that the timestamp is correct with `./restore.sh list`
- Make sure the `~/.config-backups` directory exists

### Problem: "Permission denied"
- Make the scripts executable: `chmod +x install.sh restore.sh`

## 📞 Support

To report a problem or suggest an improvement, create an issue in the project's GitHub repository.

---

**Version** : 2.0  
**Last updated** : January 2024
