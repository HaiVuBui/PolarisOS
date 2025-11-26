return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_material_background = "soft"
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      transparent = false,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      integrations = {
        treesitter = true,
        telescope = true,
      },
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      styles = {
        transparency = false,
      },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    "sainnhe/everforest",
    lazy = true,
  },
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 900,
    config = function()
      local function capitalize(text)
        return text:sub(1, 1):upper() .. text:sub(2)
      end

      local function lines(list)
        return table.concat(list, "\n")
      end

      local themes = {}

      local function add_theme(theme)
        table.insert(themes, theme)
      end

      local gruvbox_contrasts = { "soft", "medium", "hard" }
      for _, contrast in ipairs(gruvbox_contrasts) do
        add_theme({
          name = "Gruvbox Material Dark " .. capitalize(contrast),
          colorscheme = "gruvbox-material",
          before = lines({
            [[vim.o.background = "dark"]],
            string.format([[vim.g.gruvbox_material_background = "%s"]], contrast),
            [[vim.g.gruvbox_material_foreground = "material"]],
          }),
        })
      end
      for _, contrast in ipairs(gruvbox_contrasts) do
        add_theme({
          name = "Gruvbox Material Light " .. capitalize(contrast),
          colorscheme = "gruvbox-material",
          before = lines({
            [[vim.o.background = "light"]],
            string.format([[vim.g.gruvbox_material_background = "%s"]], contrast),
            [[vim.g.gruvbox_material_foreground = "material"]],
          }),
        })
      end

      local catppuccin_flavours = {
        { flavour = "latte", background = "light" },
        { flavour = "frappe", background = "dark" },
        { flavour = "macchiato", background = "dark" },
        { flavour = "mocha", background = "dark" },
      }
      for _, flavour in ipairs(catppuccin_flavours) do
        add_theme({
          name = "Catppuccin " .. capitalize(flavour.flavour),
          colorscheme = "catppuccin",
          before = lines({
            string.format([[vim.o.background = "%s"]], flavour.background),
            string.format([[vim.g.catppuccin_flavour = "%s"]], flavour.flavour),
          }),
        })
      end

      add_theme({
        name = "Tokyonight Storm",
        colorscheme = "tokyonight",
        before = [[vim.o.background = "dark"]],
      })

      add_theme({
        name = "Rose Pine Moon",
        colorscheme = "rose-pine-moon",
      })

      add_theme({
        name = "Nightfox",
        colorscheme = "nightfox",
      })

      local everforest_contrasts = { "soft", "medium", "hard" }
      for _, background in ipairs({ "dark", "light" }) do
        for _, contrast in ipairs(everforest_contrasts) do
          add_theme({
            name = string.format("Everforest %s %s", capitalize(background), capitalize(contrast)),
            colorscheme = "everforest",
            before = lines({
              string.format([[vim.o.background = "%s"]], background),
              string.format([[vim.g.everforest_background = "%s"]], contrast),
              [[vim.g.everforest_better_performance = 1]],
            }),
          })
        end
      end

      require("themery").setup({
        themes = themes,
        livePreview = true,
      })

      vim.api.nvim_create_user_command("ThemePicker", function()
        vim.cmd("Themery")
      end, { desc = "Open the theme picker" })
    end,
  },
}
