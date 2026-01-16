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
      highlight_groups = {
        -- Soften contrast for Dawn to reduce eye strain.
        Normal = { bg = "#f0e9e0", fg = "#5f586e" },
        NormalFloat = { bg = "#ede5db", fg = "#5f586e" },
        CursorLine = { bg = "#e6dfd6" },
        Visual = { bg = "#ddd6cd" },
        LineNr = { fg = "#8f879d" },
        CursorLineNr = { fg = "#6f6885" },
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
    "kepano/flexoki-neovim",
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

      local function add_gruvbox(background, contrast)
        add_theme({
          name = string.format("Gruvbox Material %s %s", capitalize(background), capitalize(contrast)),
          colorscheme = "gruvbox-material",
          before = lines({
            string.format([[vim.o.background = "%s"]], background),
            string.format([[vim.g.gruvbox_material_background = "%s"]], contrast),
            [[vim.g.gruvbox_material_foreground = "material"]],
          }),
        })
      end

      for _, background in ipairs({ "dark", "light" }) do
        for _, contrast in ipairs({ "soft", "medium", "hard" }) do
          add_gruvbox(background, contrast)
        end
      end

      local function add_catppuccin(flavour, background)
        add_theme({
          name = "Catppuccin " .. capitalize(flavour),
          colorscheme = string.format("catppuccin-%s", flavour),
          before = lines({
            string.format([[vim.o.background = "%s"]], background),
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
        add_catppuccin(flavour.flavour, flavour.background)
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
        name = "Rose Pine Dawn",
        colorscheme = "rose-pine-dawn",
        before = [[vim.o.background = "light"]],
      })
      add_theme({
        name = "Nightfox",
        colorscheme = "nightfox",
      })

      add_theme({
        name = "Flexoki Dark",
        colorscheme = "flexoki-dark",
        before = [[vim.o.background = "dark"]],
      })

      add_theme({
        name = "Flexoki Light",
        colorscheme = "flexoki-light",
        before = [[vim.o.background = "light"]],
      })

      local function add_everforest(background, contrast)
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

      local everforest_contrasts = { "soft", "medium", "hard" }
      for _, background in ipairs({ "dark", "light" }) do
        for _, contrast in ipairs(everforest_contrasts) do
          add_everforest(background, contrast)
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
