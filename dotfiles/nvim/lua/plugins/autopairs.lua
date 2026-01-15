return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    check_ts = true,
    map_cr = true,
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    -- Enable angle bracket pairing (useful for tags and generics).
    local Rule = require("nvim-autopairs.rule")
    npairs.add_rules({
      Rule("<", ">"),
    })
  end,
}
