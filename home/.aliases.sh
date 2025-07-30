#!/bin/bash

# ==============================================================================
#  Configuration des Alias et Fonctions Utiles
# ==============================================================================

# ------------------------------------------------------------------------------
#  Alias Généraux
# ------------------------------------------------------------------------------

# Source des alias TGPT depuis un fichier séparé
[ -f ~/.tgpt_aliases.sh ] && source ~/.tgpt_aliases.sh

# Créer un fichier, y compris les répertoires parents si nécessaire
alias mkfile='f() { mkdir -p "$(dirname "$1")" && touch "$1"; }; f'

# Alias vi/nvim commentés (exemples pour différents terminaux)
# alias vi="alacritty --config-file ~/.config/alacritty-nvim/alacritty.toml -e nvim &"
# alias vi="foot -c /home/alamine/.config/foot-nvim.ini -e nvim&"

# ------------------------------------------------------------------------------
#  Gestion des Services Système
# ------------------------------------------------------------------------------

alias start='sudo systemctl start '
alias stop='sudo systemctl stop '
alias restart='sudo systemctl restart '
alias enable='sudo systemctl enable ' 
alias disable='sudo systemctl disable ' 



# ------------------------------------------------------------------------------
#  Téléchargement
# ------------------------------------------------------------------------------

# Alias yt-dlp avec options par défaut pour télécharger des vidéos/audio
alias yt-dlp='yt-dlp --downloader aria2c --external-downloader-args "aria2c:-x 3 -s 3 -k 1M" --format "bestvideo[height<=1080]+bestaudio/best" --merge-output-format mkv --embed-chapters --embed-subs --embed-thumbnail -o "~/Videos/yt-dlp/%(uploader)s - %(playlist)s/%(title)s.%(ext)s" '

# ------------------------------------------------------------------------------
#  Affichage de Fichiers (avec bat)
# ------------------------------------------------------------------------------

# Utiliser bat pour l'affichage des fichiers (si installé)
alias b="bat "

# ------------------------------------------------------------------------------
#  Navigation
# ------------------------------------------------------------------------------

# Utiliser z pour la navigation rapide (si installé)
alias cd='z'

# Raccourcis de navigation basiques (utilisent l'alias cd=z)
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias -- -='cd -' # Retour au répertoire précédent

# Alias de listage de fichiers améliorés avec eza
alias l='eza --group-directories-first'
alias ls='eza -l  --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2'
alias ltd='eza --tree --only-dirs'
alias ld='eza -l --group-directories-first --only-dirs'
alias lad='eza -l --group-directories-first --only-dirs -a'
alias lf='eza -l --icons --group-directories-first --only-files'
alias laf='eza -l --icons --only-files -a'
alias lz='exa --tree --level=3 --icons | fzf'

# ------------------------------------------------------------------------------
#  Raccourcis Communs
# ------------------------------------------------------------------------------

alias c='clear' # Effacer l'écran
alias h='history' # Afficher l'historique
alias m='mkdir -p' # Créer un répertoire (et parents si besoin)
alias o='xdg-open' # Ouvrir un fichier avec l'application par défaut

# ------------------------------------------------------------------------------
#  Gestion de Fichiers (Interactif et Corbeille)
# ------------------------------------------------------------------------------

# Commandes de sécurité interactives (demandent confirmation avant écrasement)
#alias cp='cp -i'
#alias mv='mv -i'
alias ln='ln -i'

# Utiliser trash-cli pour supprimer des fichiers (si installé)
alias rm='trash-put -v'
alias empty-trash='trash-empty'

# ------------------------------------------------------------------------------
#  Recherche
# ------------------------------------------------------------------------------

# Utiliser grep avec coloration automatique
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# ------------------------------------------------------------------------------
#  Réseau
# ------------------------------------------------------------------------------

alias ping='ping -c 5' # Ping avec 5 paquets par défaut
alias web='python3 -m http.server' # Serveur web simple dans le répertoire courant


# ------------------------------------------------------------------------------
#  Gestionnaire de Paquets (Pacman)
# ------------------------------------------------------------------------------

alias pacup='sudo pacman -Syyu --noconfirm"' # Mettre à jour le système
alias pacout='sudo pacman -Rns' # Supprimer un paquet et ses dépendances non utilisées
alias pacin='sudo pacman -Sy --needed ' # Installer un paquet (ne réinstalle pas si déjà présent)

# ------------------------------------------------------------------------------
#  Git Amélioré
# ------------------------------------------------------------------------------

alias gs='git status -sb' # Statut court et branch
alias ga='git add' # Ajouter des fichiers à l'index
alias gc='git commit -m ' # Commiter avec un message
alias gp='git push' # Pousser les changements et afficher une émoticône
alias gd='git diff --color-words' # Afficher les différences avec coloration par mots


# Fonction pour afficher la mémoire RAM utilisée par une application
# Fonction pour afficher la mémoire RAM utilisée par une application
memtake() {
    local application="$1"
    local total_ram=0

    if [ -z "$application" ]; then
        echo "Usage: memtake <nom_application>"
        return 1
    fi

    # Récupérer les processus correspondant à l'application
    # Utilise pgrep pour trouver les PIDs, puis ps pour obtenir la mémoire RSS
    for pid in $(pgrep -f "$application"); do
        # ps -p <pid> -o rss affiche la mémoire résidente en KiB
        local rss=$(ps -p "$pid" -o rss= 2>/dev/null) # 'rss=' supprime l'en-tête
        if [ -n "$rss" ]; then # Vérifie que rss n'est pas vide
            total_ram=$((total_ram + rss))
        fi
    done

    if [ "$total_ram" -eq 0 ]; then
        echo "Aucun processus trouvé pour '$application' ou impossible d'obtenir les informations mémoire."
        return 1
    fi

    # Convertir la somme totale en mégaoctets
    # Utilise printf pour formater la sortie flottante
    local total_ram_mb=$(printf "%.2f" $(bc -l <<<"scale=2; $total_ram / 1024"))

    echo "La mémoire RAM totale utilisée par '$application' est de $total_ram_mb Mo."
}
