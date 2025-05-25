return {
	"nvimtools/none-ls.nvim",
	config = function()
		local lspImportSource = require("python-lsp-imports").setup()

		require("null-ls").setup({
			sources = {
				lspImportSource,
			},
		})
	end,
}
