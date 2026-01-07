local opt = vim.opt
local api = vim.api

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.number = true
opt.relativenumber = true
opt.conceallevel = 0
opt.clipboard = "unnamedplus" -- share yanks with the system clipboard

-- start: line numbers color
local function set_line_number_contrast()
  local background = vim.o.background
  local normal = api.nvim_get_hl(0, { name = "Normal", link = false })
  local fallback = background == "dark" and "#ffffff" or "#000000"
  local color = normal and normal.fg or fallback
  api.nvim_set_hl(0, "LineNr", { fg = color, bg = "NONE" })
  api.nvim_set_hl(0, "CursorLineNr", { fg = color, bg = "NONE", bold = true })
end

set_line_number_contrast()

api.nvim_create_autocmd("ColorScheme", {
  callback = set_line_number_contrast,
  desc = "Keep line numbers high contrast after colorscheme changes",
})
-- end: line numbers color

-- 1. Enable autoread
vim.o.autoread = true

-- 2. Create an autocommand to trigger the reload immediately
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})

-- 3. Notification (Optional: lets you know it happened)
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = "echomsg 'File changed on disk. Buffer reloaded.'",
})

require("config.lazy")
