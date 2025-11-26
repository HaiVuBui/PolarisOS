-- Codeium inline AI completions (Windsurf-style)
-- Uses the official plugin with ghost text suggestions and custom mappings.
return {
  "Exafunction/codeium.vim",
  event = "InsertEnter",
  init = function()
    -- Disable defaults; we define our own keymaps below
    vim.g.codeium_disable_bindings = 1

    -- Disable in UIs and prompts where inline AI is distracting
    vim.g.codeium_filetypes = {
      TelescopePrompt = false,
      ["neo-tree"] = false,
      ["neo-tree-popup"] = false,
      NvimTree = false,
      lazy = false,
      help = false,
      gitcommit = false,
    }
  end,
  config = function()
    -- Single explicit keymap: accept suggestion
    vim.keymap.set(
      "i",
      "<C-g>",
      function()
        return vim.fn["codeium#Accept"]()
      end,
      { expr = true, silent = true, desc = "Codeium Accept" }
    )
  end,
}
