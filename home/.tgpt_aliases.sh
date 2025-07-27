#!/bin/bash
# ==============================================================================
#  Alias TGPT Simples - Configuration minimaliste
# ==============================================================================
# Usage: source ~/.tgpt_aliases.sh dans votre ~/.bashrc ou ~/.zshrc
# ==============================================================================

# ------------------------------------------------------------------------------
#  Alias de Base
# ------------------------------------------------------------------------------

# Modes principaux
alias t='tgpt'                           # TGPT basique
alias tq='tgpt --quiet'                  # Sans animation
alias tw='tgpt --whole'                  # Réponse complète d'un coup
alias tc='tgpt --code'                   # Génération de code
alias ts='tgpt --shell'                  # Commandes shell
alias tsy='tgpt --shell -y'              # Shell avec exécution auto

# Modes interactifs
alias ti='tgpt --interactive'            # Mode interactif
alias tim='tgpt --multiline'             # Mode multi-lignes
alias tis='tgpt --interactive-shell'     # Shell interactif

# Génération d'images
alias timg='tgpt --image'                # Image basique
alias timghd='tgpt --image --height 1024 --width 1024'  # Image HD
alias timgsq='tgpt --image --height 512 --width 512'    # Image carrée

# ------------------------------------------------------------------------------
#  Fonctions Utiles
# ------------------------------------------------------------------------------

# Fonction pour expliquer du code
explain() {
  if [ $# -eq 0 ]; then
    echo "Usage: explain '<code>' ou cat fichier | explain"
    return 1
  fi

  local code_input
  if [ -t 0 ]; then
    code_input="$*"
  else
    code_input=$(cat)
  fi

  echo "📖 Explication du code..."
  tgpt "Explique ce code de manière claire:\n\n$code_input"
}

# Fonction pour déboguer du code
debug() {
  if [ $# -eq 0 ]; then
    echo "Usage: debug '<code>' ou cat fichier | debug"
    return 1
  fi

  local code_input
  if [ -t 0 ]; then
    code_input="$*"
  else
    code_input=$(cat)
  fi

  echo "🐛 Débogage du code..."
  tgpt --code "Trouve et corrige les erreurs:\n\n$code_input"
}

# Fonction pour résumer du texte
resume() {
  if [ $# -eq 0 ]; then
    echo "Usage: resume '<texte>' ou cat fichier | resume"
    return 1
  fi

  local text_input
  if [ -t 0 ]; then
    text_input="$*"
  else
    text_input=$(cat)
  fi

  echo "📝 Résumé en cours..."
  tgpt "Résume ce texte:\n\n$text_input"
}

# Fonction pour traduire
trad() {
  if [ $# -lt 2 ]; then
    echo "Usage: trad '<langue>' '<texte>' ou cat fichier | trad '<langue>'"
    echo "Exemple: trad anglais 'Bonjour'"
    return 1
  fi

  local lang="$1"
  local text_input
  
  if [ $# -eq 1 ] && [ ! -t 0 ]; then
    text_input=$(cat)
  else
    shift
    text_input="$*"
  fi

  echo "🌍 Traduction en $lang..."
  tgpt "Traduis en $lang:\n\n$text_input"
}

# Fonction pour optimiser du code
opti() {
  if [ $# -eq 0 ]; then
    echo "Usage: opti '<code>' ou cat fichier | opti"
    return 1
  fi

  local code_input
  if [ -t 0 ]; then
    code_input="$*"
  else
    code_input=$(cat)
  fi

  echo "⚡ Optimisation du code..."
  tgpt --code "Optimise ce code:\n\n$code_input"
}

# Fonction pour générer des images avec nom de fichier
img() {
  if [ $# -eq 0 ]; then
    echo "Usage: img '<description>' [nom_fichier]"
    echo "Exemple: img 'un chat mignon' mon_chat"
    return 1
  fi

  local description="$1"
  local filename="${2:-image_$(date +%Y%m%d_%H%M%S)}"
  local output="$HOME/Pictures/${filename}.jpg"

  echo "🎨 Génération d'image: $description"
  echo "💾 Fichier: $output"
  
  tgpt --image --out "$output" "$description"
  
  if [ -f "$output" ]; then
    echo "✅ Image sauvée: $output"
  fi
}

# Fonction d'aide rapide
aide() {
  echo "🤖 Aide TGPT - Alias Simples"
  echo "=========================="
  echo ""
  echo "Alias de base:"
  echo "  t       - tgpt normal"
  echo "  tq      - sans animation"
  echo "  tw      - réponse complète"
  echo "  tc      - génération code"
  echo "  ts      - commandes shell"
  echo "  tsy     - shell auto-exec"
  echo "  ti      - mode interactif"
  echo "  tim     - multi-lignes"
  echo "  tis     - shell interactif"
  echo "  timg    - générer image"
  echo "  timghd  - image HD"
  echo "  timgsq  - image carrée"
  echo ""
  echo "Fonctions:"
  echo "  explain - expliquer code"
  echo "  debug   - déboguer code"
  echo "  opti    - optimiser code"
  echo "  resume  - résumer texte"
  echo "  trad    - traduire"
  echo "  img     - image avec nom"
  echo "  aide    - cette aide"
}

# Raccourci pour l'aide
alias th='aide'

echo "✅ Alias TGPT simples chargés"
echo "💡 Tapez 'aide' ou 'th' pour l'aide"
