return {
	'epwalsh/obsidian.nvim',
	version = '*',
	lazy = true,
	event = {
		'BufReadPre ' .. vim.fn.expand('~') .. '/.dev/vaults/**.md',
		'BufNewFile ' .. vim.fn.expand('~') .. '/.dev/vaults/**.md',
	},
	keys = function()
		local noremap = { noremap = true, silent = true }
		return {
			{ '<leader>ns', '<cmd>ObsidianSearch<CR>', noremap },
			{ '<leader>nr', '<cmd>ObsidianRename<CR>', noremap },
		}
	end,
	config = function()
		require('obsidian').setup({
			workspaces = {
				{
					name = 'vaults',
					path = '~/.dev/vaults',
				},
			},
			log_level = vim.log.levels.INFO,
			completion = {
				nvim_cmp = true,
				min_chars = 2,
				prepend_note_id = true,
				prepend_note_path = false,
				use_path_only = false,
			},
			mappings = {
				['<CR>'] = {
					action = function()
						return require('obsidian').util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				['<leader><CR>'] = {
					action = function()
						return require('obsidian').util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
			},
			note_id_func = function(title)
				local suffix = ''
				if title ~= nil then
					suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
				else
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. '-' .. suffix
			end,

			disable_frontmatter = false,
			note_frontmatter_func = function(note)
				local out = { id = note.id, tags = note.tags }
				if note.aliases and #note.aliases > 0 then
					out.aliases = { note.aliases[#note.aliases] }
				end
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,
			backlinks = {
				height = 10,
				wrap = true,
			},
			follow_url_func = function(url)
				vim.fn.jobstart({ 'open', url }) -- Mac OS
			end,
			use_advanced_uri = false,
			open_app_foreground = false,
			finder = 'telescope.nvim',
			sort_by = 'modified',
			sort_reversed = true,
			open_notes_in = 'current',
			ui = {
				enable = true, -- set to false to disable all additional syntax features
				update_debounce = 200, -- update delay after a text change (in milliseconds)
				checkboxes = {
					[' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
					['x'] = { char = '', hl_group = 'ObsidianDone' },
					['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
					['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
				},
				bullets = { char = '•', hl_group = 'ObsidianBullet' },
				external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
				reference_text = { hl_group = 'ObsidianRefText' },
				highlight_text = { hl_group = 'ObsidianHighlightText' },
				tags = { hl_group = 'ObsidianTag' },
				hl_groups = {
					ObsidianTodo = { bold = true, fg = '#f78c6c' },
					ObsidianDone = { bold = true, fg = '#89ddff' },
					ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
					ObsidianTilde = { bold = true, fg = '#ff5370' },
					ObsidianBullet = { bold = true, fg = '#89ddff' },
					ObsidianRefText = { underline = true, fg = '#c792ea' },
					ObsidianExtLinkIcon = { fg = '#c792ea' },
					ObsidianTag = { italic = true, fg = '#89ddff' },
					ObsidianHighlightText = { fg = '#000000', bg = '#E6B455' },
				},
			},
			attachments = {
				img_folder = 'assets/imgs',
				img_text_func = function(client, path)
					local link_path
					local vault_relative_path = client:vault_relative_path(path)
					if vault_relative_path ~= nil then
						link_path = vault_relative_path
					else
						link_path = tostring(path)
					end
					local display_name = vim.fs.basename(link_path)
					return string.format('![%s](%s)', display_name, link_path)
				end,
			},
			yaml_parser = 'native',
		})
	end,
}
