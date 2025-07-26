require("nvim-tree").setup {
  filters = { dotfiles = false, git_ignored = false },
  -- auto_reload_on_write = true,
  -- view = {
  --   centralize_selection = false,
  --   cursorline = true,
  --   debounce_delay = 15,
  --   width = {},
  --   side = "left",
  --   preserve_window_proportions = false,
  --   number = true,
  --   relativenumber = true,
  --   signcolumn = "yes",
  -- },
  -- update_focused_file = { enable = true, update_root = false, ignore_list = {} },
  -- renderer = {
  --   add_trailing = false,
  --   group_empty = false,
  --   highlight_git = false,
  --   full_name = false,
  --   highlight_opened_files = "all",
  --   highlight_modified = "none",
  --   root_folder_label = ":~:s?$?/..?",
  --   indent_width = 2,
  --   indent_markers = {
  --     enable = true,
  --     inline_arrows = true,
  --     icons = {
  --       corner = "└",
  --       edge = "│",
  --       item = "│",
  --       bottom = "─",
  --       none = " ",
  --     },
  --   },
  -- },
}

local lspsaga = require "lspsaga"
lspsaga.setup { -- defaults ...
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  infor_sign = "",
  diagnostic_header_icon = "   ",
  -- code action title icon
  code_action_icon = " ",
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = false,
  },
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  max_preview_lines = 10,
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<ESC>",
    exec = "<CR>",
  },
  definition_preview_icon = "  ",
  border_style = "single",
  rename_prompt_prefix = "➤",
  rename_output_qflist = {
    enable = false,
    auto_open_qflist = false,
  },
  server_filetype_map = {},
  diagnostic_prefix_format = "%d. ",
  diagnostic_message_format = "%m %c",
  highlight_prefix = false,
}

require("telescope").setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob",
      "!**/node_modules/*",
      "--glob",
      "!**/.git/*",
      "--glob",
      "!**/build/*",
      "--glob",
      "!**/dist/*",
      "--glob",
      "!**/tmp/*",
      "--glob",
      "!**/logs/*",
      "--glob",
      "!**/coverage/*",
      "--glob",
      "!**/bin/*",
      "--glob",
      "!**/vendor/*",
      "--glob",
      "!**/.idea/*",
      "--glob",
      "!**/.vscode/*",
      "--glob",
      "!**/.cache/*",
      "--glob",
      "!**/docs/*",
      "--glob",
      "!**/backup/*",
    },
    file_ignore_patterns = {
      "node_modules",
      ".git",
      "build",
      "dist",
      "tmp",
      "logs",
      "coverage",
      "bin",
      "vendor",
      ".idea",
      ".vscode",
      ".cache",
      "docs",
      "backup",
    },
    -- sorting_strategy = "descending",
    -- layout_strategy = "horizontal",
    -- preview = false,
  },
  extensions = {
    fzf = {
      fuzzy = true, -- active la recherche floue
      override_generic_sorter = true, -- remplace le sorter générique
      override_file_sorter = true, -- remplace le sorter de fichiers
      case_mode = "smart_case", -- mode de casse intelligent
    },
  },
}

-- Charger l'extension fzf-native si installée
pcall(require("telescope").load_extension, "fzf")
