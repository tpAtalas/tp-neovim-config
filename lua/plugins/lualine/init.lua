--
local colors = require('kanagawa.colors').setup({ theme = 'wave' })

return {
	'nvim-lualine/lualine.nvim',
	lazy = false,
	priority = 500,
	config = function()
		local custom_theme = require('plugins.lualine.custom_theme')
		local custom_components = require('plugins.lualine.custom_components')

		require('lualine').setup({
			options = {
				icons_enabled = true,
				theme = custom_theme(colors),
				component_separators = ' ',
				section_separators = ' ',
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					-- 30 min
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{ 'mode', icon = ' ' },
				},
				lualine_b = {},
				lualine_c = {
					{ 'filetype', padding = { left = 1, right = 0 } },
					{ 'encoding', padding = { left = 1, right = 0 } },
					{
						'diagnostics',
						sources = { 'nvim_workspace_diagnostic' },
						symbols = { error = ' ', warn = ' ', info = ' ', hint = 'ﴞ ' },
						sections = { 'error', 'warn', 'info', 'hint' },
						colored = true,
						update_in_insert = true,
						always_visible = false,
					},
					{
						require('lazy.status').updates,
						cond = require('lazy.status').has_updates,
						color = { fg = colors.sakuraPink },
					},
				},
				lualine_x = {
					{ custom_components.search_count, icon = '󰍉', color = { fg = colors.autumnYellow } },
					{ custom_components.path_winbar, icon = { '󰋜', align = 'left' }, color = { fg = colors.oniViolet } },
					{ custom_components.anchor },
				},
				lualine_y = {
					-- { 'progress', icon = '', padding = { left = 0, right = 1 } },
					-- { 'location', icon = '', padding = { left = 0, right = 1 } },
					{ 'filesize', icon = '', padding = { left = 0, right = 1 } },
					{ custom_components.total_lines_file, icon = '', padding = { left = 0, right = 1 } },
					{
						'diff',
						symbols = { added = ' ', modified = ' ', removed = ' ' },
						diff_color = {
							added = { fg = colors.springGreen },
							modified = { fg = colors.autumnYellow },
							removed = { fg = colors.sakuraPink },
						},
					},
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = { 'toggleterm' },
		})
	end,
}
