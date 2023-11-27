vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


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
		'nvim-telescope/telescope.nvim', tag = '0.1.4',
		dependencies = {'nvim-lua/plenary.nvim'}
	},
	'navarasu/onedark.nvim',
	'nvim-lualine/lualine.nvim',
	{
		"nvim-treesitter/nvim-treesitter", 
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = { "go", "lua", "vim"},
				sync_install = false,
				higlight = {enable = true},
				indent = {enable = true},
			})
		end
	}
})


vim.wo.number = true
vim.wo.rnu = true

vim.o.undofile = true
vim.o.mouse = 'a'
vim.opt.colorcolumn = "80"

vim.cmd.colorscheme 'onedark'

local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<C-p>', telescope.git_files, {})

-- If fzf is installed, we ensure that telescope is going to use it
pcall(require('telescope').load_extension, 'fzf')


require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}
