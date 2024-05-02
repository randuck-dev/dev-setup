require("randuck")

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
	{
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function ()
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>sg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>sl', builtin.live_grep, {})

      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

    end
	},
	'navarasu/onedark.nvim',
	'nvim-lualine/lualine.nvim',
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = { "go", "lua", "vim", "markdown", "markdown_inline", "hcl"},
				sync_install = false,
				higlight = {enable = true},
				indent = {enable = true},
			})
		end
	},

	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'neovim/nvim-lspconfig', config = function ()
    -- We wait for the lsp to attach, and then we end up setting up the LSP keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
      end
    })
	end},
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

	-- completion engine
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
  {'elentok/format-on-save.nvim'},

	{'L3MON4D3/LuaSnip'},

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = {'hrsh7th/nvim-cmp'},
    config = function ()
      require('nvim-autopairs').setup {}

      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'

      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function ()
      require('copilot').setup({
        suggestion = {
          auto_trigger = false
        },
        panel = {
          enabled = false
        }
      })
    end
  },
  {
        "kdheepak/lazygit.nvim",
      cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
      },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
           { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
    {
          "folke/todo-comments.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
          opts = {
            signs = false,
            higlight = {
              multiline = true,
              multiline_pattern = "^."
            }
          }
    },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Telescope Begin
local telescope = require('telescope.builtin')

-- Telesecope End

-- Diagnostic Begin

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror message'})

-- Diagnostic End
vim.keymap.set('n', '<S-l>', ":bnext<CR>", {})
vim.keymap.set('n', '<S-h>', ":bprevious<CR>", {})

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>wh', ":split<CR>", {})
vim.keymap.set('n', '<leader>wv', ":vsplit<CR>", {})


local opts = { noremap = true, silent = true }

-- Terraform Shortcuts Begin
vim.keymap.set('n', '<leader>ti', ":!terraform -chdir=%:p:h init<CR>", opts)
vim.keymap.set('n', '<leader>tp', ":!terraform -chdir=%:p:h plan<CR>", opts)

-- Terraform Shortcuts End 

-- If fzf is installed, we ensure that telescope is going to use it
pcall(require('telescope').load_extension, 'fzf')


require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
}

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)



-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {"lua_ls", "marksman", "rust_analyzer", "pyright", "terraformls", "tflint"},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()

      require('lspconfig').lua_ls.setup(lua_opts)
    end,

    terraformls = function()
        require('lspconfig').terraformls.setup({})
    end,

    tflint = function ()
        require('lspconfig').tflint.setup({})
    end

  }
})

require("lspconfig").pyright.setup({})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    window = {
	    completion =	cmp.config.window.bordered(),
    	documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
    	['<C-Space>'] = cmp.mapping.complete(),
	    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
	    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
	    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
	    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),

    sources = {
      {name = 'copilot', group_index = 2},
	    {name = 'nvim_lsp', group_index = 2}
    }
})

vim.cmd [[ colorscheme catppuccin ]]


require("ibl").setup()


local format_on_save = require("format-on-save")
local formatters = require("format-on-save.formatters")

format_on_save.setup({
    formatter_by_ft = {
        terraform = formatters.lsp
    }
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

