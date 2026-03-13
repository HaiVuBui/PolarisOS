return {
  "zk-org/zk-nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "markdown" },
  config = function()
    local zk = require("zk")
    zk.setup({})

    local function cursor_location()
      local pos = vim.api.nvim_win_get_cursor(0)
      local line = pos[1] - 1
      local col = pos[2]
      return {
        uri = vim.uri_from_bufnr(0),
        range = {
          start = { line = line, character = col },
          ["end"] = { line = line, character = col },
        },
      }
    end

    vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew<CR>", { desc = "Zk new note" })
    vim.keymap.set("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", { desc = "Zk insert link" })
    vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes<CR>", { desc = "Zk find notes" })
    vim.keymap.set("n", "<leader>zg", function()
      local query = vim.fn.input("Search: ")
      if query == nil or query == "" then
        return
      end

      require("zk.commands").get("ZkNotes")({
        sort = { "modified" },
        match = { query },
      })
    end, { desc = "Zk match search" })
    vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Zk tags" })
    vim.keymap.set("n", "<leader>zT", function()
      local input = vim.fn.input("Tags search: ")
      if input == nil or input == "" then
        return
      end

      local tags = {}
      for tag in input:gmatch("%S+") do
        table.insert(tags, tag)
      end

      if #tags == 0 then
        return
      end

      require("zk.commands").get("ZkNotes")({
        sort = { "modified" },
        tags = tags,
      })
    end, { desc = "Zk multi-tag search" })
    vim.keymap.set("n", "<leader>zo", function()
      zk.new({
        insertLinkAtLocation = cursor_location(),
      })
    end, { desc = "Zk new note + link" })
  end,
}
