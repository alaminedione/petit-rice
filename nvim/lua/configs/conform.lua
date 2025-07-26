local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
     css = { "prettier" },
     html = { "prettier" },
    php = { "php_cs_fixer" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
