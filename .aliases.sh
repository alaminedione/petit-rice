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
alias j='jobs -l' # Afficher les jobs en cours
alias q='exit' # Quitter le shell
alias m='mkdir -p' # Créer un répertoire (et parents si besoin)
alias v='vim' # Lancer vim
alias o='xdg-open' # Ouvrir un fichier avec l'application par défaut

# ------------------------------------------------------------------------------
#  Gestion de Fichiers (Interactif et Corbeille)
# ------------------------------------------------------------------------------

# Commandes de sécurité interactives (demandent confirmation avant écrasement)
#alias cp='cp -i'
#alias mv='mv -i'
#alias ln='ln -i'

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

# Alias de recherche basés sur find
#alias f='find . -name' # Recherche de fichiers/dossiers par nom
#alias ff='find . -type f -name' # Recherche uniquement de fichiers par nom
#alias fd='find . -type d -name' # Recherche uniquement de répertoires par nom

# ------------------------------------------------------------------------------
#  Informations Système
# ------------------------------------------------------------------------------

alias df='df -h' # Taille des disques en format lisible
alias du='du -h' # Taille des répertoires en format lisible
alias free='free -m' # Afficher la mémoire en Mo
alias top='htop' # Utiliser htop si installé, sinon top
alias ports='netstat -tulanp' # Afficher les ports ouverts et les processus associés

# ------------------------------------------------------------------------------
#  Réseau
# ------------------------------------------------------------------------------

alias ip='ip -c' # Afficher les infos réseau avec couleurs
alias ping='ping -c 5' # Ping avec 5 paquets par défaut
alias fastping='ping -c 100 -s.2' # Ping rapide avec 100 paquets de petite taille
alias web='python3 -m http.server' # Serveur web simple dans le répertoire courant
alias myip='curl ifconfig.me' # Afficher l'IP publique
alias localip="hostname -I | cut -d' ' -f1" # Afficher l'IP locale

# ------------------------------------------------------------------------------
#  Archives
# ------------------------------------------------------------------------------

alias untar='tar -zxvf' # Décompresser .tar.gz
alias untarbz='tar -jxvf' # Décompresser .tar.bz2

# ------------------------------------------------------------------------------
#  Docker
# ------------------------------------------------------------------------------

alias d='docker'
alias dc='docker-compose'
alias dps='docker ps' # Lister les conteneurs en cours
alias dimg='docker images' # Lister les images
alias drm='docker rm' # Supprimer un conteneur
alias drmi='docker rmi' # Supprimer une image

# ------------------------------------------------------------------------------
#  Gestionnaire de Paquets (Pacman)
# ------------------------------------------------------------------------------

alias pacup='sudo pacman -Syu && echo -e "\\U2705 System updated!"' # Mettre à jour le système
alias pacout='sudo pacman -Rns' # Supprimer un paquet et ses dépendances non utilisées
alias pacin='sudo pacman -Sy --needed ' # Installer un paquet (ne réinstalle pas si déjà présent)

# ------------------------------------------------------------------------------
#  Git Amélioré
# ------------------------------------------------------------------------------

alias gs='git status -sb' # Statut court et branch
alias ga='git add' # Ajouter des fichiers à l'index
alias gc='git commit -m ' # Commiter avec un message
alias gp='git push && echo -e "\\U1F680 Push successful!"' # Pousser les changements et afficher une émoticône
alias gd='git diff --color-words' # Afficher les différences avec coloration par mots

# ------------------------------------------------------------------------------
#  Raccourcis d'Applications
# ------------------------------------------------------------------------------

alias calc='bc -l' # Calculatrice en ligne de commande
alias weather='curl wttr.in' # Afficher la météo
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -' # Lancer un test de vitesse

# ------------------------------------------------------------------------------
#  Fonctions Utiles
# ------------------------------------------------------------------------------

# Créer un dossier et s'y déplacer
mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Extraire différents types d'archives
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar e "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' ne peut pas être extrait via extract()" ;;
        esac
    else
        echo "'$1' n'est pas un fichier valide"
    fi
}

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


# ------------------------------------------------------------------------------
#  Configuration et Fonctions FZF
# ------------------------------------------------------------------------------

# Commande par défaut pour fzf (utiliser fd si installé)
export FZF_DEFAULT_COMMAND="fd --type f -H"

# Options par défaut pour fzf
export FZF_DEFAULT_OPTS="
--height 70%
--reverse
--border rounded
--ansi
#--color='fg:#abb2bf,bg:#282c34,hl:#98c379'
#--color='fg+:#ffffff,bg+:#2c313a,hl+:#98c379'
#--color='info:#61afef,prompt:#e06c75,pointer:#c678dd'
#--color='marker:#e5c07b,spinner:#56b6c2,header:#56b6c2'
--prompt='   '
--pointer='→'
--marker='✓'
"

# Fonction utilitaire pour vérifier si une commande existe
check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Erreur: La commande '$1' n'est pas installée." >&2
        return 1
    fi
}

# Ouvrir un fichier texte/code avec bat via fzf
batf() {
    check_command bat || return 1
    check_command fd || return 1
    local file
    # Exclure les fichiers binaires ou multimédia courants
    file=$(command fd -H \
        --exclude "*.mp4" --exclude "*.mkv" --exclude "*.png" --exclude "*.jpg" \
        --exclude "*.jpeg" --exclude "*.mp3" --exclude "*.pdf" \
        | fzf --bind 'esc:abort' \
        --preview 'echo "📄 Fichier: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "" && bat --color=always --style=numbers --line-range=:50 {}' \
        --preview-window=right:60%:wrap \
        --header="🔍 Sélectionnez un fichier à visualiser avec bat" \
        --exit-0) && \
    bat --color=always "$file"
}

# Ouvrir un fichier avec vim via fzf (sélection multiple possible)
vimf() {
    check_command vim || return 1
    check_command fd || return 1
    local files
    # Exclure les fichiers binaires ou multimédia courants
    files=$(command fd -H \
        --exclude "*.pdf" --exclude "*.mp4" --exclude "*.mkv" --exclude "*.png" \
        --exclude "*.jpg" --exclude "*.jpeg" --exclude "*.mp3" \
        | fzf --bind 'esc:abort' \
        --preview 'echo "📝 Fichier: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "🔤 Type: $(file -b {})" && echo "" && bat --color=always --style=numbers --line-range=:30 {} 2>/dev/null || head -30 {}' \
        --preview-window=right:60%:wrap \
        --header="✏️  Sélectionnez des fichiers pour vim (Tab pour multi-sélection)" \
        -m --exit-0) && \
    vim $files
}

# Ouvrir un fichier avec nvim via fzf (sélection multiple possible)
vif() {
    check_command nvim || return 1
    check_command fd || return 1
    local files
    # Exclure les fichiers binaires ou multimédia courants
    files=$(command fd -H \
        --exclude "*.pdf" --exclude "*.mp4" --exclude "*.mkv" --exclude "*.png" \
        --exclude "*.jpg" --exclude "*.jpeg" --exclude "*.mp3" \
        | fzf --bind 'esc:abort' \
        --preview 'echo "⚡ Fichier: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "🔤 Type: $(file -b {})" && echo "📍 Chemin: $(realpath {})" && echo "" && bat --color=always --style=numbers --line-range=:30 {} 2>/dev/null || head -30 {}' \
        --preview-window=right:60%:wrap \
        --header="⚡ Sélectionnez des fichiers pour neovim (Tab pour multi-sélection)" \
        -m --exit-0) && \
    nvim $files
}

# Afficher le contenu de plusieurs fichiers avec bat via fzf (sélection multiple)
catf() {
    check_command bat || return 1
    check_command fd || return 1
    local files
    # Exclure les fichiers binaires ou multimédia courants
    files=$(command fd -H \
        --exclude "*.pdf" --exclude "*.mp4" --exclude "*.mkv" --exclude "*.png" \
        --exclude "*.jpg" --exclude "*.jpeg" --exclude "*.mp3" \
        | fzf --bind 'esc:abort' \
        --preview 'echo "📖 Fichier: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "📊 Lignes: $(wc -l {} 2>/dev/null | cut -d" " -f1)" && echo "" && bat --color=always --style=numbers --line-range=:40 {}' \
        --preview-window=right:60%:wrap \
        --header="📖 Sélectionnez des fichiers à afficher avec bat (Tab pour multi-sélection)" \
        -m --exit-0) && \
    bat --color=always $files
}

# Ouvrir un fichier vidéo avec vlc via fzf
vlcf() {
    check_command vlc || return 1
    check_command fd || return 1

    local file
    # Chercher les fichiers vidéo courants
    file=$(command fd --type f -e mp4 -e mkv -e avi -e webm -e mov -e flv -e wmv 2>/dev/null |
        fzf --bind 'esc:abort' \
        --preview 'echo "🎬 Vidéo: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "🎞️  Format: $(file -b {})" && echo "📍 Chemin: $(realpath {})" && echo "" && mediainfo {} 2>/dev/null | head -20 || echo "Informations détaillées non disponibles"' \
        --preview-window=right:60%:wrap \
        --header="🎬 Sélectionnez une vidéo pour VLC") || return

    [ -f "$file" ] && vlc "$file" &
}

# Ouvrir un fichier PDF avec atril via fzf
atrilf() {
    check_command atril || return 1
    check_command fd || return 1

    local file
    # Chercher les fichiers PDF
    file=$(command fd --type f -e pdf 2>/dev/null |
        fzf --bind 'esc:abort' \
        --preview 'echo "📄 PDF: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "📍 Chemin: $(realpath {})" && echo "" && pdfinfo {} 2>/dev/null || echo "Informations PDF non disponibles"' \
        --preview-window=right:60%:wrap \
        --header="📄 Sélectionnez un PDF pour Atril") || return

    [ -f "$file" ] && atril "$file" &
}

# Naviguer vers un répertoire sélectionné via fzf
cdf() {
    check_command fd || return 1
    local dir
    dir=$(command fd -H --type d | fzf --bind 'esc:abort' \
        --preview 'echo "📁 Dossier: {}" && echo "📏 Taille: $(du -sh {} 2>/dev/null | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "📊 Fichiers: $(find {} -maxdepth 1 -type f 2>/dev/null | wc -l)" && echo "📁 Sous-dossiers: $(find {} -maxdepth 1 -type d 2>/dev/null | wc -l)" && echo "" && tree -C {} -L 2 2>/dev/null | head -20 || ls -la {}' \
        --preview-window=right:60%:wrap \
        --header="📁 Sélectionnez un dossier pour naviguer" \
        --exit-0) && \
    cd "$dir" || return
}

# Ouvrir un fichier audio avec rhythmbox via fzf
rhythmboxf() {
    check_command rhythmbox || return 1
    check_command fd || return 1

    local file
    # Chercher les fichiers audio courants
    file=$(command fd --type f -e mp3 -e ogg -e flac -e wav -e m4a -e aac -e wma 2>/dev/null |
        fzf --bind 'esc:abort' \
        --preview 'echo "🎵 Audio: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "🎼 Format: $(file -b {})" && echo "📍 Chemin: $(realpath {})" && echo "" && mediainfo {} 2>/dev/null | head -15 || echo "Informations audio non disponibles"' \
        --preview-window=right:60%:wrap \
        --header="🎵 Sélectionnez un fichier audio pour Rhythmbox") || return

    # Lancer Rhythmbox avec le fichier sélectionné
    if [ -f "$file" ]; then
        rhythmbox "$file" &
    else
        echo "Fichier audio introuvable: $file" >&2
        return 1
    fi
}

# Supprimer des fichiers/dossiers sélectionnés via fzf en utilisant trash-put
rmf() {
    # Vérifier trash-cli
    if ! command -v trash-put &>/dev/null; then
        echo "Install trash-cli: sudo apt install trash-cli" >&2
        return 1
    fi
    check_command fd || return 1

    # Sélection fichiers/dossiers avec preview
    local targets=($(
        command fd --hidden --type f --type d | fzf --multi \
            --preview 'if [[ -d {} ]]; then echo "📁 Dossier: {}" && echo "📏 Taille: $(du -sh {} 2>/dev/null | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "📊 Contenu: $(find {} -type f 2>/dev/null | wc -l) fichiers, $(find {} -type d 2>/dev/null | wc -l) dossiers" && echo "" && tree -C {} -L 2 2>/dev/null | head -15 || ls -la {}; else echo "📄 Fichier: {}" && echo "📏 Taille: $(du -h {} | cut -f1)" && echo "📅 Modifié: $(stat -c "%y" {} | cut -d. -f1)" && echo "🔤 Type: $(file -b {})" && echo "" && bat --color=always --style=numbers --line-range=:20 {} 2>/dev/null || head -20 {}; fi' \
            --preview-window=right:60%:wrap \
            --header="🗑️  Sélectionnez des éléments à supprimer (Tab pour multi-sélection)" \
            --bind 'esc:abort'
        #--bind 'ctrl-a:select-all,ctrl-d:deselect-all' # Exemples de raccourcis supplémentaires
    ))

    # Si aucune cible sélectionnée, sortir
    [[ ${#targets[@]} -eq 0 ]] && return

    # Confirmation avant de déplacer vers la corbeille
    printf "Déplacer vers la corbeille:\n"
    printf "• %s\n" "${targets[@]}"
    read -rp "Confirmer ? [y/N] " ans
    [[ $ans =~ [yY] ]] && trash-put "${targets[@]}"
}

# Nouvelles fonctions fzf avec previews avancés

# Rechercher dans le contenu des fichiers avec fzf et ripgrep
rgf() {
    check_command rg || return 1
    check_command fzf || return 1
    
    if [ $# -eq 0 ]; then
        echo "Usage: rgf <pattern> [path]"
        return 1
    fi
    
    local pattern="$1"
    local search_path="${2:-.}"
    
    rg --color=always --line-number --no-heading --smart-case "$pattern" "$search_path" |
    fzf --ansi \
        --delimiter : \
        --preview 'echo "🔍 Recherche: {1}" && echo "📍 Ligne: {2}" && echo "📄 Contenu:" && bat --color=always --highlight-line {2} {1}' \
        --preview-window=right:60%:wrap \
        --header="🔍 Résultats de recherche pour: $pattern" \
        --bind 'enter:execute(nvim {1} +{2})'
}

# Parcourir l'historique des commandes avec preview
histf() {
    check_command fzf || return 1
    
    local cmd
    cmd=$(history | fzf --tac --no-sort \
        --preview 'echo "📜 Commande historique:" && echo "{}" | sed "s/^[ ]*[0-9]*[ ]*//" && echo "" && echo "💡 Appuyez sur Entrée pour exécuter"' \
        --preview-window=up:30%:wrap \
        --header="📜 Historique des commandes" \
        --bind 'esc:abort') || return
    
    # Extraire la commande sans le numéro
    cmd=$(echo "$cmd" | sed 's/^[ ]*[0-9]*[ ]*//')
    
    # Demander confirmation avant exécution
    echo "Exécuter: $cmd"
    read -rp "Confirmer ? [y/N] " ans
    [[ $ans =~ [yY] ]] && eval "$cmd"
}

# Navigateur de processus avec fzf
psf() {
    check_command fzf || return 1
    
    local pid
    pid=$(ps aux | fzf --header-lines=1 \
        --preview 'echo "🔍 Processus sélectionné:" && echo "{}" && echo "" && echo "📊 Détails du processus:" && ps -p {2} -o pid,ppid,user,pcpu,pmem,time,comm,args 2>/dev/null || echo "Processus non trouvé"' \
        --preview-window=right:60%:wrap \
        --header="🔍 Sélectionnez un processus" \
        | awk '{print $2}') || return
    
    if [ -n "$pid" ]; then
        echo "PID sélectionné: $pid"
        read -rp "Action [k=kill, i=info, s=strace]: " action
        case "$action" in
            k|kill) kill "$pid" ;;
            i|info) ps -p "$pid" -o pid,ppid,user,pcpu,pmem,time,comm,args ;;
            s|strace) strace -p "$pid" ;;
            *) echo "Action non reconnue" ;;
        esac
    fi
}

# Navigateur de variables d'environnement
envf() {
    check_command fzf || return 1
    
    env | sort | fzf \
        --preview 'echo "🌍 Variable d'\''environnement:" && echo "{}" | cut -d= -f1 && echo "" && echo "💾 Valeur:" && echo "{}" | cut -d= -f2- && echo "" && echo "📏 Longueur: $(echo "{}" | cut -d= -f2- | wc -c) caractères"' \
        --preview-window=right:60%:wrap \
        --header="🌍 Variables d'environnement" \
        --bind 'enter:execute(echo {} | cut -d= -f2- | xclip -selection clipboard && echo "Valeur copiée dans le presse-papiers")'
}

# Navigateur de commits git avec preview
gitf() {
    check_command git || return 1
    check_command fzf || return 1
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Erreur: Pas dans un dépôt Git" >&2
        return 1
    fi
    
    local commit
    commit=$(git log --oneline --color=always | fzf --ansi \
        --preview 'echo "📝 Commit: {1}" && echo "📅 Détails:" && git show --color=always {1} --stat && echo "" && git show --color=always {1} --format=fuller' \
        --preview-window=right:60%:wrap \
        --header="📝 Historique Git" \
        --bind 'enter:execute(git show {1})') || return
    
    if [ -n "$commit" ]; then
        local hash=$(echo "$commit" | cut -d' ' -f1)
        echo "Commit sélectionné: $hash"
        read -rp "Action [s=show, c=checkout, r=reset]: " action
        case "$action" in
            s|show) git show "$hash" ;;
            c|checkout) git checkout "$hash" ;;
            r|reset) git reset "$hash" ;;
            *) echo "Action non reconnue" ;;
        esac
    fi
}
