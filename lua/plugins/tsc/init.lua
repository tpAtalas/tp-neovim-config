-- https://github.com/dmmulroy/tsc.nvim

local noremap = { noremap = true, silent = true }

function Toggle_quickfix()
	local quickfix_winid = vim.fn.getqflist({ winid = 0 }).winid
	if quickfix_winid == 0 then
		vim.cmd('copen')
		vim.cmd('wincmd L')
		vim.cmd('vertical resize 40')
	else
		vim.cmd('cclose')
	end
end

return {
	'dmmulroy/tsc.nvim',
	lazy = true,
	ft = { 'typescript', 'typescriptreact' },
	keys = {
		{ '<leader>to', ':TSC<CR>', noremap },
		{ '<leader>tl', ':lua Toggle_quickfix()<CR>', noremap },
	},
	config = function()
		require('tsc').setup({
			auto_open_qflist = false,
			auto_close_qflist = false,
			-- auto_start_watch_mode = true,
			bin_path = require('tsc.utils').find_tsc_bin(),
			enable_progress_notifications = false,
			flags = {
				noEmit = true,
				watch = true,
			},
			hide_progress_notifications_from_history = true,
			spinner = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
		})

		vim.api.nvim_create_autocmd('FileType', {
			pattern = { 'typescript', 'typescriptreact' },
			callback = function()
				if vim.b.did_run_tsc == nil then
					vim.cmd(':TSC')
					vim.b.did_run_tsc = true
				end
			end,
		})
	end,
}
