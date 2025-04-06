return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				{
					name = "my-actions",
					method = null_ls.methods.CODE_ACTION,
					filetypes = {},
					generator = {
						fn = function(context)
							local actions = {}
							local imports = require("config.lspimport").import()

							if imports then
								for _, import in ipairs(imports) do table.insert(actions, {
										title = import.title,
										action = import.action
									})
								end
							end
							return actions
						end,
					},
				},
			},
		})
	end,
}
