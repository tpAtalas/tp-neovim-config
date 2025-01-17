local M = {}

local utils = require('plugins.lspconfig.utils')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local get_included_filetypes = require('utils.filetype_util')
local on_attach = function(client, bufnr) end
local capabilities = cmp_nvim_lsp.default_capabilities()
local default_configs = {
	capabilities = capabilities,
	on_attach = on_attach,
}

M.html = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		separate_diagnostic_server = true,
		publish_diagnostic_on = 'insert_leave',
	},
}

M.dockerls = default_configs
M.jsonls = default_configs
M.cssmodules_ls = default_configs

M.cssls = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		scss = {
			lint = {
				unknownAtRules = 'ignore',
			},
		},
		css = {
			lint = {
				unknownAtRules = 'ignore',
			},
		},
		less = {
			lint = {
				unknownAtRules = 'ignore',
			},
		},
	},
}

M.tailwindcss = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					-- https://cva.style/docs/getting-started/installation
					{ 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
				},
			},
		},
	},
	filetypes = {
		'html',
		'typescriptreact',
		'typescript',
		'javascriptreact',
		'javascript',
		'css',
		'sass',
		'scss',
		'less',
		'svelte',
	},
}

M.emmet_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
}

M.eslint = {
	capabilities = capabilities,
	on_attach = on_attach,
	condition = function(utils)
		return utils.root_has_file('.eslintrc.*')
	end,

	settings = {
		codeAction = {
			disableRuleComment = {
				enable = false,
				location = 'separateLine',
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			enable = false,
			mode = 'all',
		},
		experimental = {
			useFlatConfig = false,
		},
		format = true,
		nodePath = '',
		onIgnoredFiles = 'off',
		problems = {
			shortenToSingleLine = false,
		},
		quiet = false,
		rulesCustomizations = {},
		run = 'onType',
		useESLintClass = true,
		validate = 'on',
	},
}

M.lua_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.stdpath('config') .. '/lua'] = true,
				},
			},
		},
	},
}

M.typos_lsp = {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = get_included_filetypes({ 'toggleterm' }),
}

M.ts_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		separate_diagnostic_server = true,
		publish_diagnostic_on = 'change',
		tsserver_max_memory = 'auto',
	},
	commands = {
		OrganizeImports = {
			utils.organize_imports,
			description = 'Organize Imports',
		},
		AddMissingImports = {
			utils.add_missing_imports,
			description = 'Add Missing Imports',
		},
	},
	handlers = {
		['textDocument/publishDiagnostics'] = function(_, result, ctx, ...)
			local client = vim.lsp.get_client_by_id(ctx.client_id)

			if client and client.name == 'ts_ls' then
				result.diagnostics = vim.tbl_filter(function(diagnostic)
					return diagnostic.code ~= 80001
				end, result.diagnostics)
			end

			return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, ...)
		end,
	},
}

M.taplo = {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- https://github.com/elijah-potter/harper/blob/master/harper-ls/README.md
M.harper_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		['harper-ls'] = {
			userDictPath = '~/.config/langs/dict.txt',
			linters = {
				spell_check = true,
				spelled_numbers = false,
				an_a = true,
				sentence_capitalization = false,
				unclosed_quotes = true,
				wrong_quotes = false,
				long_sentences = true,
				repeated_words = true,
				spaces = true,
				matcher = true,
				correct_number_suffix = true,
				number_suffix_capitalization = true,
				multiple_sequential_pronouns = true,
			},
			diagnosticSeverity = 'hint', -- Can also be "information", "warning", or "error"
			codeActions = {
				forceStable = true,
			},
		},
	},
}

M.sourcekit = {
	capabilities = capabilities,
	on_attach = on_attach,
}

return M
