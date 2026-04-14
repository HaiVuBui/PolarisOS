local function next_footnote_id(bufnr)
  bufnr = bufnr or 0
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local max_id = 0

  for _, line in ipairs(lines) do
    for id in line:gmatch("%[%^(%d+)%]") do
      max_id = math.max(max_id, tonumber(id))
    end
    for id in line:gmatch("^%[%^(%d+)%]:") do
      max_id = math.max(max_id, tonumber(id))
    end
  end

  return max_id + 1
end

local function insert_text_at_cursor(text)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(1, col + 1) .. text .. line:sub(col + 2)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col + #text })
end

local function insert_next_footnote_with_def()
  local id = next_footnote_id(0)
  local footnote = ("[^%d]: "):format(id)
  local last_line = vim.api.nvim_buf_line_count(0)
  insert_text_at_cursor(("[^%d]"):format(id))
  vim.api.nvim_buf_set_lines(0, -1, -1, false, { footnote })
  vim.api.nvim_win_set_cursor(0, { last_line + 1, #footnote })
end

local function extension_for_mime(mime)
  local map = {
    ["image/png"] = "png",
    ["image/jpeg"] = "jpg",
    ["image/jpg"] = "jpg",
    ["image/webp"] = "webp",
    ["image/gif"] = "gif",
    ["image/bmp"] = "bmp",
    ["image/tiff"] = "tiff",
    ["image/svg+xml"] = "svg",
  }

  return map[mime] or "png"
end

local function first_image_mime_type()
  local output = vim.fn.system("wl-paste --list-types")
  if vim.v.shell_error ~= 0 then
    return nil
  end

  for _, mime in ipairs(vim.split(output, "\n", { trimempty = true })) do
    if mime:match("^image/") then
      return mime
    end
  end

  return nil
end

local function paste_clipboard_image_to_assets()
  local mime = first_image_mime_type()
  if not mime then
    vim.notify("Clipboard does not contain an image", vim.log.levels.WARN)
    return
  end

  local md_dir = vim.fn.expand("%:p:h")
  local assets_dir = md_dir .. "/assets"
  vim.fn.mkdir(assets_dir, "p")

  local ext = extension_for_mime(mime)
  local filename = ("img-%s.%s"):format(os.date("%Y%m%d-%H%M%S"), ext)
  local abs_path = assets_dir .. "/" .. filename
  local rel_path = "assets/" .. filename

  local cmd = ("wl-paste --type %s > %s"):format(vim.fn.shellescape(mime), vim.fn.shellescape(abs_path))
  vim.fn.system({ "sh", "-c", cmd })

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to write clipboard image", vim.log.levels.ERROR)
    return
  end

  insert_text_at_cursor(("![](%s)"):format(rel_path))
end

vim.keymap.set("n", "<localleader>c", insert_next_footnote_with_def, {
  buffer = true,
  desc = "Insert next footnote cite + definition",
})

vim.keymap.set("n", "<C-A-v>", paste_clipboard_image_to_assets, {
  buffer = true,
  desc = "Paste clipboard image to ./assets and insert markdown link",
})
