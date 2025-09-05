#!/bin/bash

mkdir -p ~/.npm-global/lib

npm config set prefix '~/.npm-global'


#assure toi d'ajouter cette ligne dans ~/.zshrc
#export PATH=~/.npm-global/bin:$PATH

