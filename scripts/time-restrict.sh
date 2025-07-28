#!/bin/bash

# Fichier de configuration des horaires
# Définissez les intervalles autorisés pour chaque jour.
# Le format est "HHMM-HHMM" pour un intervalle (ex: 0900-1200 pour 09:00 à 12:00)
# Séparez les intervalles par des espaces si vous en avez plusieurs pour un jour.
# Laissez la chaîne vide "" si aucune restriction pour ce jour.
# Note: Les intervalles ne doivent pas traverser minuit (ex: pas de "2200-0600").
#       Chaque intervalle doit avoir une heure de fin supérieure ou égale à l'heure de début.

# Lundi
ALLOWED_INTERVALS_MON="0900-1300 1410-1645 1710-1900 2030-2200"

# Mardi
ALLOWED_INTERVALS_TUE="0900-1300 1410-1645 1710-1900 2030-2200"

# Mercredi
ALLOWED_INTERVALS_WED="0900-1300 1410-1645 1710-1900 2030-2200"

# Jeudi
ALLOWED_INTERVALS_THU="0900-1300 1410-1645 1710-1830 2030-2200"

# Vendredi
ALLOWED_INTERVALS_FRI="0900-1300 1410-1645 2030-2200"

# Samedi
ALLOWED_INTERVALS_SAT="0900-1300 1410-1645 2030-2200"

# Dimanche
ALLOWED_INTERVALS_SUN="0900-1300 1410-1645 1710-1900 2030-2200"


# --- Ne modifiez pas ce qui suit sauf si vous savez ce que vous faites ---

# Obtenir le jour de la semaine actuel (Mon=1, Tue=2, ..., Sun=7)
CURRENT_DAY_OF_WEEK=$(date +%u)

# Obtenir l'heure actuelle au format HHMM
CURRENT_TIME=$(date +%H%M)

# Variable pour stocker les intervalles autorisés pour le jour actuel et le nom du jour
CURRENT_DAY_INTERVALS=""
DAY_NAME="Jour inconnu"

# Déterminer les intervalles autorisés pour le jour actuel
case "$CURRENT_DAY_OF_WEEK" in
    1) # Lundi
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_MON"
        DAY_NAME="Lundi"
        ;;
    2) # Mardi
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_TUE"
        DAY_NAME="Mardi"
        ;;
    3) # Mercredi
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_WED"
        DAY_NAME="Mercredi"
        ;;
    4) # Jeudi
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_THU"
        DAY_NAME="Jeudi"
        ;;
    5) # Vendredi
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_FRI"
        DAY_NAME="Vendredi"
        ;;
    6) # Samedi
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_SAT"
        DAY_NAME="Samedi"
        ;;
    7) # Dimanche
        CURRENT_DAY_INTERVALS="$ALLOWED_INTERVALS_SUN"
        DAY_NAME="Dimanche"
        ;;
esac

# Variable pour indiquer si l'heure actuelle est dans un intervalle autorisé
IS_ALLOWED=0

# Vérifier si des restrictions sont définies pour ce jour
if [ -n "$CURRENT_DAY_INTERVALS" ]; then
    # Parcourir chaque intervalle défini pour ce jour
    # Le séparateur par défaut de 'read' et 'for' est l'espace, ce qui convient ici
    for interval in $CURRENT_DAY_INTERVALS; do
        # Séparer l'intervalle en heure de début et de fin
        # Utilise IFS pour spécifier le tiret comme séparateur
        IFS='-' read -r start_time end_time <<< "$interval"

        # Vérifier si l'heure actuelle est dans cet intervalle
        # Assurez-vous que start_time et end_time sont des nombres valides pour la comparaison
        if [[ "$start_time" =~ ^[0-9]{4}$ ]] && [[ "$end_time" =~ ^[0-9]{4}$ ]]; then
             # Utiliser 10# pour forcer l'interprétation en base 10, au cas où un horaire commencerait par 08 ou 09
             if (( CURRENT_TIME >= 10#$start_time && CURRENT_TIME <= 10#$end_time )); then
                IS_ALLOWED=1 # L'heure actuelle est dans un intervalle autorisé
                break        # Pas besoin de vérifier les autres intervalles pour ce jour
            fi
        else
            # Optionnel : afficher un message d'erreur si un format d'intervalle est incorrect
            # echo "Erreur de format d'intervalle dans le script ($DAY_NAME) : '$interval'" >&2
            : # Ne rien faire si le format est incorrect pour éviter de bloquer le shell
        fi
    done

    # Si après avoir vérifié tous les intervalles, IS_ALLOWED est toujours 0, l'utilisateur n'est pas dans les temps
    if [ "$IS_ALLOWED" -eq 0 ]; then
        echo ""
        echo "------------------------------------------------------------------------"
        echo "ATTENTION : L'utilisation de cette machine est restreinte."
        echo "Aujourd'hui, $DAY_NAME, l'utilisation est autorisée durant les intervalles suivants :"
        # Formater les intervalles pour l'affichage
        FORMATTED_INTERVALS=""
        SEP=""
        for interval in $CURRENT_DAY_INTERVALS; do
             IFS='-' read -r start_time end_time <<< "$interval"
             # Ajout d'une vérification de format simple avant de formater
             if [[ "$start_time" =~ ^[0-9]{4}$ ]] && [[ "$end_time" =~ ^[0-9]{4}$ ]]; then
                FORMATTED_INTERVALS="${FORMATTED_INTERVALS}${SEP}${start_time:0:2}:${start_time:2:2}-${end_time:0:2}:${end_time:2:2}"
                SEP=" et " # Ajouter " et " comme séparateur après le premier intervalle
             fi
        done
        echo "$FORMATTED_INTERVALS"
        echo "Il est actuellement $(date +%H:%M)."
        echo "Vos actions peuvent être limitées."
        echo "------------------------------------------------------------------------"
        echo ""
         pkill -SIGKILL -u $(whoami)
 #       /sbin/shutdown -h +1 "Hors horaires autorisés"

        fi
else
    # Si CURRENT_DAY_INTERVALS est vide, il n'y a pas de restriction pour ce jour.
    # Ou si l'heure est autorisée (IS_ALLOWED=1), nous n'entrons pas dans ce bloc.
    # Le shell continue normalement.
    : # Pas de restrictions pour ce jour ou heure autorisée
fi
