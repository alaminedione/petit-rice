require("supermaven-nvim").setup {
  lazy = "true",
  keymaps = {
    accept_suggestion = "<C-a>",
    clear_suggestion = "<C-x>",
    accept_word = "<C-]>",
  },
  ignore_filetypes = { "txt", "md" }, -- or { "cpp", }
  color = {
    suggestion_color = "#7c7c7c",
    cterm = 244,
  },
  log_level = "info", -- set to "off" to disable logging completely
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false, -- disables built in keymaps for more manual control
  condition = function()
    return false
  end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
}
