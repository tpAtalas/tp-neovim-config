-- import null-ls plugin safely
local setup, null_ls = pcall(require, 'null-ls')
if not setup then
	return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local codeactions = null_ls.builtins.code_actions -- to setup code action
local completion = null_ls.builtins.completion -- to setup completion

local eslint = { -- js/ts linter
	-- only enable eslint if root has .eslintrc.js
	condition = function(utils)
		return utils.root_has_file('.eslintrc.json') -- change file extension if you use something else
	end,
}

-- to setup format on save
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

-- Built-in sources:
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local source = {
	diagnostics.tsc,
	-- WARNING: diagnostics listed below do not support workspace level diagnostics
	formatting.markdownlint,
	diagnostics.codespell,
	formatting.codespell,
	formatting.stylua, -- lua formatter
	formatting.prettier, -- js/ts formatter
	codeactions.eslint_d.with(eslint),
	diagnostics.eslint_d.with(eslint),
}

local on_attach = function(current_client, bufnr)
	if current_client.supports_method('textDocument/formatting') then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					filter = function(client)
						--  only use null-ls for formatting instead of lsp server
						return client.name == 'null-ls'
					end,
					bufnr = bufnr,
				})
			end,
		})
	end
end

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = source,
	on_attach = on_attach,
	debug = false,
	fallback_severity = vim.diagnostic.severity.WARN,
	float = false,
	virtual_text = true,
	signs = true,
	severity_sort = true,
	update_in_insert = false,
	debounce = 1000,
})
