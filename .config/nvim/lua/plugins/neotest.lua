return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim", -- Common utilities used by `neotest`
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter", -- Syntax highlighting and parsing
		"fredrikaverpil/neotest-golang", -- Adapter for Go tests
		"nvim-neotest/neotest-python",
	},
	config = function()
		-- Setup function for configuring neotest
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					dap = {
						justMyCode = true,
						stopOnEntry = false,
					},
					args = { "-vv", "-s" },
				}),
			},
		})

		local neotest = require("neotest")

		-- Bind each key separately using vim.keymap.set
		vim.keymap.set("n", "<leader>tt", function()
			vim.api.nvim_command("write")
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run File (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tT", function()
			vim.api.nvim_command("write")
			neotest.run.run(vim.loop.cwd())
		end, { desc = "Run All Test Files (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tr", function()
			vim.api.nvim_command("write")
			neotest.run.run()
		end, { desc = "Run Nearest (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tl", function()
			vim.api.nvim_command("write")
			neotest.run.run_last()
		end, { desc = "Run Last (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Toggle Summary (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>to", function()
			neotest.output.open({ enter = true, auto_close = true })
		end, { desc = "Show Output (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tO", function()
			neotest.output_panel.toggle()
		end, { desc = "Toggle Output Panel (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tS", function()
			neotest.run.stop()
		end, { desc = "Stop (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tw", function()
			neotest.watch.toggle(vim.fn.expand("%"))
		end, { desc = "Toggle Watch (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>td", function()
			require("dap-python").test_method({
				test_runner = "pytest",
				config = function(config)
					config.args = vim.list_extend({ "--headed" }, config.args or {})
					return config
				end,
			})
		end, { desc = "Debug Test (Neotest)", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tk", function()
			local expr = vim.trim(vim.fn.input("pytest -k: "))

			if expr == "" then
				vim.notify("No pytest -k expression given", vim.log.levels.WARN)
				return
			end

			require("dap").run({
				type = "python",
				request = "launch",
				name = "pytest -k " .. expr,
				module = "pytest",
				args = {
					"--headed",
					"-k",
					expr,
				},
				console = "integratedTerminal",
				cwd = vim.fn.getcwd(),
			})
		end, { desc = "Pytest -k across suite" })
	end,
}
