-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "nord",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }

M.ui = {
  tabufline = {
    enabled = false, -- Disable top tab bar
  },

  statusline = {
    modules = {
      -- 1-letter mode indicator with native NvChad color coding
      mode = function()
        local utils = require "nvchad.stl.utils"
        if not utils.is_activewin() then
          return ""
        end

        local config = require("nvconfig").ui.statusline
        local sep_style = config.separator_style
        local sep_icons = utils.separators
        local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
        local sep_r = separators["right"]

        local modes = utils.modes
        local m = vim.api.nvim_get_mode().mode
        local mode_info = modes[m] or { "N", "Normal" }

        -- Take only the first letter of the mode name
        local short_mode = mode_info[1]:sub(1, 1)

        local current_mode = "%#St_" .. mode_info[2] .. "Mode# " .. short_mode .. " "
        local mode_sep1 = "%#St_" .. mode_info[2] .. "ModeSep#" .. sep_r
        return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
      end,

      -- Open buffer list override (without icons)
      file = function()
        local bufs = vim.api.nvim_list_bufs()
        local cur_buf = vim.api.nvim_get_current_buf()
        local buf_items = {}

        for _, bufnr in ipairs(bufs) do
          if vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr) then
            local path = vim.api.nvim_buf_get_name(bufnr)
            local filename = (path ~= "") and vim.fs.basename(path) or "[No Name]"
            local modified = vim.bo[bufnr].modified and " [+]" or ""

            -- Highlight active buffer vs inactive buffers
            if bufnr == cur_buf then
              table.insert(buf_items, "%#St_file_txt# " .. filename .. modified .. " %#St_file_bg#")
            else
              table.insert(buf_items, "%#Comment# " .. filename .. modified .. " %#St_file_bg#")
            end
          end
        end

        return table.concat(buf_items, "  ")
      end,
    },
  },
}

return M
