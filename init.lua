local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 999
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Disable arrow keys in Normal mode
vim.keymap.set("n", "<up>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("n", "<down>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("n", "<left>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("n", "<right>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')

-- Disable arrow keys in Insert mode
vim.keymap.set("i", "<up>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("i", "<down>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("i", "<left>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("i", "<right>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')

-- Disable arrow keys in Visual mode
vim.keymap.set("v", "<up>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("v", "<down>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("v", "<left>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')
vim.keymap.set("v", "<right>", '<cmd>echo "Don\'t use the arrows idiot"<cr>')

require("lazy").setup({
	-- 1. SYNTAX HIGHLIGHTING
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"query",
					"rust",
					"typescript",
					"javascript",
					"cpp",
					"java",
					"python",
				},
				highlight = { enable = true },
			})
		end,
	},

	{
		"fedepujol/move.nvim",
		config = function()
			require("move").setup({
				line = { enable = true, indent = true },
				block = { enable = true, indent = true },
			})
			local opts = { noremap = true, silent = true }
			-- Normal mode (move single lines)
			vim.keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", opts)
			vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", opts)
			-- Visual mode (move selected blocks)
			vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
			vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use main branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	{ "lewis6991/gitsigns.nvim", config = true },

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>sb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, {})
		end,
	},

	-- 2. LSP & MASON (The fix is here)
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()

			-- This tells the LSP what features nvim-cmp supports
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "rust_analyzer", "vtsls" },
				handlers = {
					-- Default handler
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
					-- Lua specific
					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = { Lua = { diagnostics = { globals = { "vim" } } } },
						})
					end,

					["rust_analyzer"] = function()
						require("lspconfig").rust_analyzer.setup({
							capabilities = capabilities,
							settings = {
								["rust_analyzer"] = {
									imports = {
										granularity = {
											group = "module",
										},
										prefix = "self",
									},
									cargo = {
										buildScripts = {
											enable = true,
										},
									},
									procMacro = {
										enable = true,
									},
									standaloneDefault = true,
								},
							},
						})
					end,
				},
			})

			-- LSP Keybinds
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},

	-- 3. AUTOCOMPLETE ENGINE
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
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
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	{ "xiyaowong/transparent.nvim", config = true },
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = { timeout_ms = 500, lsp_fallback = true },
			})
		end,
	},
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "numToStr/Comment.nvim", config = true },
})

-- UI / Themes
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local function apply_halflife_theme()
	local hev_orange = "#FF9E00"
	local hazard_yel = "#FFFF00"
	local toxic_green = "#76FF03"
	local concrete = "#666666"
	local alarm_red = "#FF0000"

	vim.api.nvim_set_hl(0, "Normal", { fg = hev_orange, bg = "NONE" })
	vim.api.nvim_set_hl(0, "Identifier", { fg = hev_orange })
	vim.api.nvim_set_hl(0, "Statement", { fg = hazard_yel, bold = true })
	vim.api.nvim_set_hl(0, "Keyword", { fg = hazard_yel, bold = true })
	vim.api.nvim_set_hl(0, "String", { fg = toxic_green })
	vim.api.nvim_set_hl(0, "Comment", { fg = concrete, italic = true })
	vim.api.nvim_set_hl(0, "LineNr", { fg = concrete })
	vim.api.nvim_set_hl(0, "@lsp.type.macro", { fg = alarm_red, bold = true })
	vim.api.nvim_set_hl(0, "@function.macro", { fg = alarm_red, bold = true })
end

apply_halflife_theme()
