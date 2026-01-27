return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local map = vim.keymap.set
			local servers = {
				-- python
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = { typeCheckingMode = "basic" },
						},
					},
				},

				-- haskell
				hls = {
					filetypes = { "haskell", "lhaskell" },
				},

				-- latex
				texlab = {
					settings = {
						texlab = {
							build = {
								executable = "latexmk",
								args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							},
						},
					},
				},

				-- nix
				nixd = {},

				-- go
				gopls = {},

				-- rust
				rust_analyzer = {
					-- settings = {
					-- 	["rust-analyzer"] = {
					-- 		cargo = {
					-- 			allFeatures = true,
					-- 		},
					-- 		procMacro = {
					-- 			enable = true,
					-- 		},
					-- 	},
					-- },
				},
			}

			vim.o.signcolumn = "yes"

			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
					prefix = ">",
				},
				float = { source = "always", border = "rounded" },
				severity_sort = true,
			})

			for server, opts in pairs(servers) do
				opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
				vim.lsp.config(server, opts)
			end

			vim.lsp.enable(vim.tbl_keys(servers))

			map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
			map("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
			map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
			map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
			map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
		end,
	},
}
