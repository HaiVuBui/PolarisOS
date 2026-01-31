return {
  "zk-org/zk-nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "markdown" },
  config = function()
    require("zk").setup({})
    vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew<CR>", { desc = "Zk new note" })
    vim.keymap.set("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", { desc = "Zk insert link" })
    vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes<CR>", { desc = "Zk find notes" })
    vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Zk tags" })
  end,
}
