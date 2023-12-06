return {
	'echasnovski/mini.indentscope',
	event = 'VeryLazy',
	opts = {
		symbol = '│',
		options = { try_as_border = true },
		draw = {
			delay = 50,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd('FileType', {
			pattern = {
				'help',
				'alpha',
				'dashboard',
				'neo-tree',
				'Trouble',
				'trouble',
				'lazy',
				'mason',
				'notify',
				'toggleterm',
				'lazyterm',
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
