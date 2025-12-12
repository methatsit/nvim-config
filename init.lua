
-- ==                           CORE SETTINGS                              == --
-- ========================================================================== --

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true -- Optional: Relative line numbers

-- Tab settings (2 spaces)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Clipboard (Sync with system)
vim.opt.clipboard = "unnamedplus"

-- ========================================================================== --
-- ==                       PLUGIN MANAGER (LAZY)                          == --
-- ========================================================================== --

-- Bootstrap lazy.nvim
-- (This chunk checks if lazy exists, and downloads it if it doesn't)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- ==                             PLUGINS                                  == --
-- ========================================================================== --

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "javascript", "cpp" },
        highlight = { enable = true },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup() -- This activates the plugin!
    end,
  },
})

-- ========================================================================== --
-- ==                           KEYBINDINGS                                == --
-- ========================================================================== --

-- Example: Press <leader>pv to go back to file explorer (Netrw)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
