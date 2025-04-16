--[[
Zuardi's neovim config (Apr 2025)

Another month, another laptop cleanup, let's start a new vim config!
]]


-- BASIC --

-- <space> as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- leader w = [w]rite
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')

-- spaces for identing
vim.opt.expandtab = true

-- default tab size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
  -- YES Tim Pope! even for Markdown!
  -- see https://www.reddit.com/r/neovim/comments/z2lhyz/comment/ixjb7je/ and :help ft-markdown-plugin
vim.g.markdown_recommended_style = 0

-- display trailing spaces, nbsp and tab chars
vim.opt.list = true

-- show color column
vim.opt.colorcolumn = { 100 }

-- show line numbers
vim.opt.number = true

-- case insensitive search unless the search has capital letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10


-- PLUGINS --

local plugins = {
  -- Harpoon 2
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      require("nvim-treesitter.install").prefer_git = true
    end,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "vim",
        "lua",
        "bash",
        "markdown",
        "dockerfile",
        "python",
        "typescript",
        "javascript",
        "css",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Svelte syntax highlight?
  { "leafOfTree/vim-svelte-plugin",
    config = function()
      vim.g.vim_svelte_plugin_use_typescript = 1
    end,
  },

  -- Theme: Catppuccin
  { "catppuccin/nvim", name = "colorscheme:catppuccin",
    config = function() vim.cmd.colorscheme('catppuccin-frappe') end, -- default colorscheme
  },

}

-- plugin manager bootstrap (lazy.nvim)
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
require('lazy').setup(plugins)


-- AFTER PLUGINS LOADED


-- Keymaps: Harpoon 2
local h = require("harpoon")
h:setup()
vim.keymap.set("n", "<leader>a", function() h:list():add() end)
vim.keymap.set("n", "<leader><space>", function() h.ui:toggle_quick_menu(h:list()) end)
vim.keymap.set("n", "<leader>j", function() h:list():select(1) end)
vim.keymap.set("n", "<leader>k", function() h:list():select(2) end)
vim.keymap.set("n", "<leader>l", function() h:list():select(3) end)
vim.keymap.set("n", "<leader>;", function() h:list():select(4) end)
