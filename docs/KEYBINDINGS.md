## ⌨️ Keybindings

Keybindings are consistent across both Sway and Hyprland. The main modifier key (`$mod`) is the **Super key** (Windows key).

Here's a summary of the most common keybindings:

### General

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `$mod + Return`        | Launch Terminal (`ghostty`)             |
| `$mod + q`             | Kill active window                      |
| `$mod + d`             | Launch application menu (`wofi drun`)   |
| `$mod + x`             | Power menu (`wofi power`)               |
| `$mod + c`             | Launch Calculator (`galculator`)        |
| `$mod + v`             | Clipboard history (`clipman pick`)      |
| `$mod + b`             | Toggle Waybar                           |
| `$mod + Ctrl + l`      | Lock screen (`hyprlock` / `swaylock`)   |

### Window Management

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `$mod + Left/Right/Up/Down` | Move focus to adjacent window           |
| `$mod + space`         | Toggle floating mode for active window  |
| `$mod + Tab`           | Switch to previously focused workspace  |

### Workspaces

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `$mod + [1-0]`         | Switch to workspace `[1-10]`            |
| `$mod + Shift + [1-0]` | Move active window to workspace `[1-10]`|

### Screenshots

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `Print`                | Full screenshot                         |
| `$mod + s`             | Area screenshot                         |


For a complete and up-to-date list of keybindings, please refer to the configuration files:
*   `~/.config/hypr/hyprland.conf`
*   `~/.config/sway/config`

### Ghostty (Terminal)

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `Alt + n`              | New tab                                 |
| `Alt + x`              | Close tab                               |
| `Alt + Right`          | Next tab                                |
| `Alt + Left`           | Previous tab                            |
| `Alt + Shift + Right`  | Move tab right                          |
| `Alt + Shift + Left`   | Move tab left                           |
| `Alt + [1-9]`          | Go to tab `[1-9]`                       |
| `Alt + Enter`          | New split right                         |
| `Alt + v`              | New split down                          |
| `Alt + q`              | Close split                             |
| `Alt + ]`              | Next split                              |
| `Alt + [`              | Previous split                          |
| `Alt + =`              | Increase font size                      |
| `Alt + -`              | Decrease font size                      |
| `Alt + 0`              | Reset font size                         |
