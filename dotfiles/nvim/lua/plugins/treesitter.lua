return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- pin to the stable API (new default branch is an incompatible rewrite)
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "c",
      "cpp",
      "python",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "elixir",
      "heex",
      "javascript",
      "html",
      "markdown",
      "markdown_inline",
      "latex",
      "rust"
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
