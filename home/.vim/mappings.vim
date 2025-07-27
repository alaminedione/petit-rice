"bismilah

" Active Goyo avec leader uz
" a faire

inoremap jj <Esc>

colorscheme  catppuccin_macchiato

nnoremap ; :

" 6. Activer which-key automatiquement sur leader
let mapleader = " "
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>


" Mappings NERDTree
nnoremap <silent> <leader>n :NERDTreeToggle<CR>       " Ouvrir/fermer NERDTree
"nnoremap <silent> <leader>f :NERDTreeFind<CR>         " Trouver fichier courant dans NERDTree

" Basculer entre fenêtre NERDTree et fenêtre d'édition active
function! ToggleNERDTreeWindow()
  " Vérifier si NERDTree est ouvert
  if exists("t:NERDTreeBufName")
    " Si on est dans NERDTree, aller à la fenêtre précédente (éditeur)
    if &filetype ==# 'nerdtree'
      wincmd p
    else
      " Sinon, chercher la fenêtre NERDTree et s’y déplacer
      exec "NERDTreeFocus"
    endif
  else
    echo "NERDTree n'est pas ouvert"
  endif
endfunction

nnoremap <silent> <leader>e :call ToggleNERDTreeWindow()<CR>

