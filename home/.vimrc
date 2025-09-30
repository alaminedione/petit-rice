" Copier en mode visuel : sélection + copie dans wl-copy
xnoremap <silent> y y:call system('wl-copy', @")<CR>

" Copier une ligne avec yy et envoyer dans wl-copy
nnoremap <silent> yy yy:call system('wl-copy', @")<CR>

" Coller depuis le presse-papiers système avec "+p
nnoremap <silent> "+p :let @"=substitute(system('wl-paste --no-newline'), '\r', '', 'g')<CR>p

" Coller depuis le presse-papiers primaire avec "*p
nnoremap <silent> "*p :let @"=substitute(system('wl-paste --no-newline --primary'), '\r', '', 'g')<CR>p


set clipboard=unnamed,unnamedplus
set nocompatible
set termguicolors
"set t_Co=256

syntax on           " Active la coloration syntaxique
filetype on         " Active la détection du type de fichier
filetype plugin on  " Active les plugins spécifiques au type de fichier
filetype indent on  " Active l'indentation spécifique au type de fichier

cmap w!! w !sudo tee > /dev/null %


" Activer la coloration syntaxique
syntax on

" Activer le numéro de ligne
"set number

" Mettre en surbrillance la recherche
" set hlsearch

" Ignorer la casse lors de la recherche
set ignorecase
set smartcase

" Rechercher pendant que tu tapes
set incsearch

" Garder une indentation intelligente
set autoindent
set smartindent

" Utiliser des espaces au lieu de tabulations
set expandtab
set tabstop=4
set shiftwidth=4

" Garder une ligne de marge autour du curseur
set scrolloff=5

" Activer le mode souris
set mouse=a

" Sauvegarder automatiquement avant de quitter ou de changer de buffer
"autocmd BufLeave * silent! write

" Activer la barre de statut améliorée
"set laststatus=2

" Afficher les lignes correspondantes entre ( ) { }
set showmatch



call plug#begin()
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && pnpm install' }
Plug 'preservim/nerdtree'
" Auto-completion
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'rose-pine/vim'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'
Plug 'arcticicestudio/nord-vim'

call plug#end()

" ~/.vimrc
source ~/.vim/mappings.vim


" Lancer NERDTree avec F2
map <F2> :NERDTreeToggle<CR>

" Active Goyo automatiquement à l'ouverture de Vim
" autocmd VimEnter * Goyo


inoremap jj <Esc>

set background=dark
colorscheme nord

nnoremap ; :

" 6. Activer which-key automatiquement sur leader
let mapleader = " "
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>


" Mappings NERDTree
nnoremap <silent> <leader>n :NERDTreeToggle<CR>       " Ouvrir/fermer NERDTree
nnoremap <silent> <leader>f :NERDTreeFind<CR>         " Trouver fichier courant dans NERDTree

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



