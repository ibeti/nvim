require "nvchad.options"

-- add yours here!
-- 1. Hide top tabline & enable per-window statuslines
vim.opt.showtabline = 0
vim.opt.laststatus = 2

-- 2. Define custom dynamic statusline handler
_G.my_statusline = function()
  local winid = vim.g.statusline_winid
  local cur_win = vim.api.nvim_get_current_win()

  if winid == cur_win then
    -- ACTIVE WINDOW: Render NvChad's full statusline (uses custom module from chadrc.lua)
    local stl_theme = "default"
    local ok_cfg, nvconfig = pcall(require, "nvconfig")
    if ok_cfg and nvconfig.ui and nvconfig.ui.statusline then
      stl_theme = nvconfig.ui.statusline.theme or "default"
    end

    local ok_stl, stl = pcall(require, "nvchad.stl." .. stl_theme)
    if ok_stl and type(stl) == "function" then
      return stl()
    end
    return require("nvchad.stl.default")()
  else
    -- INACTIVE WINDOW: Text-only filename crumb
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local filename = (path ~= "") and vim.fs.basename(path) or "[No Name]"
    local modified = vim.bo[bufnr].modified and " [+]" or ""

    return "%#StatusLineNC#  " .. filename .. modified .. " %="
  end
end

-- 3. Instruct Neovim to use our wrapper function
vim.opt.statusline = "%!v:lua.my_statusline()"
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
