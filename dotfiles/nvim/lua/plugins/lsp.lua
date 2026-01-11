return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local map = vim.keymap.set
      local servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = { typeCheckingMode = "basic" },
            },
          },
        },
        hls = {
          filetypes = { "haskell", "lhaskell" },
        },
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              },
            },
          },
        },
        nixd = {},
        gopls = {},
      }

      vim.o.signcolumn = "yes"

      vim.lsp.config("*", { capabilities = capabilities })

      for server, opts in pairs(servers) do
        vim.lsp.config(server, opts)
      end

      vim.lsp.enable(vim.tbl_keys(servers))

      map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
      map("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
      map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
    end,
  },
}
