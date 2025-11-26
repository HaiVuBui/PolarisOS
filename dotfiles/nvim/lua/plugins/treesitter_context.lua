return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    enable = true,
    max_lines = 3,
    trim_scope = "inner",
    mode = "cursor",
    separator = "─",
    zindex = 20,
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
  end,
  keys = function()
    return {
      {
        "<leader>tc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
      {
        "]c",
        function()
          require("treesitter-context").go_to_context()
        end,
        desc = "Jump to parent context",
      },
    }
  end,
}

