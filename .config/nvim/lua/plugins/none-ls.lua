-- might have to clear the cache  ~/.cache/nvim/cspell.nvim/ for changes to take effect
local cspellConfig = {
	config_file_preferred_name = ".cspell.json",
	cspell_config_dirs = { "~/.config/" },
	decode_json = function(cspell_str)
		local result = vim.json.decode(cspell_str)
		result.language = "en,nl"
		return result
	end,
	encode_json = function(tbl)
		tbl.language = "en,nl"
		return vim.fn.json_encode(tbl)
	end,
}
return {
	"nvimtools/none-ls.nvim",
	config = function()
		local lspImportSource = require("python-lsp-imports").setup()
		local cspell = require("cspell")

		require("null-ls").setup({
			sources = {
				lspImportSource,
				cspell.diagnostics.with({
					diagnostics_postprocess = function(diagnostic)
						diagnostic.severity = vim.diagnostic.severity["INFO"]
					end,
					config = cspellConfig,
				}),
				cspell.code_actions.with({
					config = cspellConfig,
				}),
			},
		})
	end,
}
