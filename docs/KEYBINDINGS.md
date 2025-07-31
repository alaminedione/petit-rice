## ⌨️ Keybindings

Keybindings are consistent across both Sway and Hyprland. The main modifier key (`$mod`) is the **Super key** (Windows key).

you can find the configuration files in `~/.config/hypr/hyprland.conf` and `~/.config/sway/config`.

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

### Vim

I added a few keybindings on top of the default ones.

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `jj`                   | Escape (Insert mode)                    |
| `;`                    | Command mode                            |
| `<leader>n`            | Toggle NERDTree                         |
| `<leader>e`            | Toggle focus between NERDTree and editor |


### Nvim

I added a few keybindings on top of the default ones.

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `;`                    | Command mode                            |
| `jj`                   | Escape (Insert mode)                    |
| `<leader>n`            | Toggle NvimTree                         |
| `<leader>e`            | Toggle focus between NvimTree and editor |
| `<leader>ts`           | Telescope: Grep String                  |
| `<leader>tc`           | Telescope: Command History              |
| `<leader>td`           | Telescope: Diagnostics                  |
| `<leader>tm`           | Telescope: Marks                        |
| `<leader>tgf`          | Telescope: Git Files                    |
| `<leader>tgb`          | Telescope: Git Branches                 |
| `<leader>tgc`          | Telescope: Git Commits                  |
| `<leader>la`           | Lspsaga: Code Action                    |
| `<leader>ld`           | Lspsaga: Go to definition               |
| `<leader>lp`           | Lspsaga: Preview definition             |
| `<leader>lr`           | Lspsaga: Rename                         |
| `<leader>ui`           | Toggle inline errors                    |
| `<leader>un`           | Toggle line numbers                     |
| `<leader>uz`           | Toggle Zen Mode                         |
| `<leader>ul`           | Toggle underline diagnostics            |

#### Supermaven in neovim

| Keybinding             | Action                                  |
| :--------------------- | :-------------------------------------- |
| `<C-a>`                | Accept suggestion                       |
| `<C-x>`                | Clear suggestion                        |
| `<C-]>`                | Accept word                             |

#### Avante (AI) in neovim

Avante works primarily through commands and keybindings. 
visite  https://github.com/yetone/avante.nvim for more information.
the configuration is located at `~/.config/nvim/lua/plugins/init.lua

Here are some of the most common ones:

**Commands:**

| Command                | Description                             |
| :--------------------- | :-------------------------------------- |
| `:AvanteAsk`           | Query the AI about the code             |
| `:AvanteChat`          | Start a chat session                    |
| `:AvanteEdit`          | Edit the selected code block            |
| `:AvanteToggle`        | Toggle the sidebar                      |
| `:AvanteFocus`         | Focus the sidebar                       |
| `:AvanteClear`         | Clear the chat history                  |

**Default Keybindings:**

*   **Sidebar:**
    *   `]p` / `[p`: Navigate between prompts
    *   `a`: Apply changes
*   **AI Suggestions:**
    *   `<M-l>`: Accept suggestion
    *   `<M-]>` / `<M-[>`: Cycle through suggestions
*   **Diffs:**
    *   `co`: Choose "ours"
    *   `ct`: Choose "theirs"

