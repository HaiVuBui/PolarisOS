return {
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = function()
      local theme = require("telescope.themes")
      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          file_ignore_patterns = {
            "%.git/",
            "__pycache__/",
            "node_modules/",
            "%.cache/",
            "typings/",
          },
        },
        pickers = {
          find_files = {
            hidden = true, -- include dotfiles like .gitignore/.editorconfig
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob",
              "!.git/",
              "--glob",
              "!*.cache/",
            },
          },
        },
        extensions = {
          ["ui-select"] = theme.get_dropdown({}),
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "ui-select")
    end,
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>sh", builtin.help_tags, desc = "[S]earch [H]elp" },
        { "<leader>sk", builtin.keymaps, desc = "[S]earch [K]eymaps" },
        { "<leader>f", builtin.find_files, desc = "[S]earch [F]iles" },
        { "<leader>ss", builtin.builtin, desc = "[S]earch [S]elect Telescope" },
        { "<leader>sw", builtin.grep_string, desc = "[S]earch current [W]ord" },
        { "<leader>g", builtin.live_grep, desc = "[S]earch by [G]rep" },
        { "<leader>sd", builtin.diagnostics, desc = "[S]earch [D]iagnostics" },
        { "<leader>sr", builtin.resume, desc = "[S]earch [R]esume" },
        { "<leader>s.", builtin.oldfiles, desc = "[S]earch Recent Files" },
        { "<leader><leader>", builtin.buffers, desc = "Browse buffers" },
        { "<leader>/", builtin.current_buffer_fuzzy_find, desc = "Fuzzy search buffer" },
      }
    end,
  },
}
