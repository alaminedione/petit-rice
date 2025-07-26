require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

--o.foldenable = false -- Activer le pliage des l'ouverture d'un fichier
-- o.foldmethod = "expr" -- Méthode de pliage par expression
--o.foldexpr = "nvim_treesitter#foldexpr()" -- Expression Tree-sitter

vim.opt.laststatus = 3
-- vim.g.mcphub_auto_approve = true

vim.diagnostic.config {
  virtual_text = false, -- désactive l'affichage inline des erreurs
  signs = true, -- tu peux garder les signes dans la marge
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

local cmp = require "cmp"
cmp.setup {
  mapping = {
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    -- vous pouvez garder d'autres mappings comme <CR> pour confirmer la sélection
  },
  -- autres options...
}
