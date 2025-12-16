local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"

require("lazy").setup({
  -- 1. SYNTAX HIGHLIGHTING (Keep this)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "query", "rust", "javascript", "cpp", "java" },
        highlight = { enable = true },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- NEW: Configure Telescope to see hidden files
      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true, -- Finds dotfiles (like .config)
          },
          live_grep = {
            -- Grep inside hidden files too
            additional_args = function(args)
              return vim.list_extend(args, { "--hidden" })
            end,
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>sb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, {})
      vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, {})
    end,
  },

  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        extra_groups = { -- Make these transparent too
          "NormalFloat", "NvimTreeNormal"
        },
      })
      vim.cmd("TransparentEnable")
    end,
  },

  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "lua_ls" },
      })

      local lspconfig = require("lspconfig")

      lspconfig.clangd.setup({})

      lspconfig.lua_ls.setup({
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
      })

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
  {
    "numToStr/Comment.nvim",
    config = true
  }
})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


local function apply_halflife_theme()
  local hev_orange  = "#FF9E00"
  local hazard_yel  = "#FFFF00"
  local toxic_green = "#76FF03"
  local concrete    = "#666666"
  local alarm_red   = "#FF0000"

  vim.api.nvim_set_hl(0, "Normal", { fg = hev_orange, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Identifier", { fg = hev_orange })
  vim.api.nvim_set_hl(0, "Operator", { fg = hev_orange })
  vim.api.nvim_set_hl(0, "Delimiter", { fg = hev_orange })
  vim.api.nvim_set_hl(0, "Constant", { fg = hev_orange })


  vim.api.nvim_set_hl(0, "Statement", { fg = hazard_yel, bold = true })
  vim.api.nvim_set_hl(0, "Keyword", { fg = hazard_yel, bold = true })
  vim.api.nvim_set_hl(0, "Type", { fg = hazard_yel, bold = true })
  vim.api.nvim_set_hl(0, "Function", { fg = hazard_yel })


  vim.api.nvim_set_hl(0, "String", { fg = toxic_green })
  vim.api.nvim_set_hl(0, "Comment", { fg = concrete, italic = true })
  vim.api.nvim_set_hl(0, "LineNr", { fg = concrete })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = hazard_yel, bold = true })


  vim.api.nvim_set_hl(0, "NormalFloat", { fg = hev_orange, bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = concrete, bg = "NONE" })
end


apply_halflife_theme()


vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_halflife_theme,
})
