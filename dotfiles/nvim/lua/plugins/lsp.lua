return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
			}

			local function lsp_keymaps(bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "<leader>r", vim.lsp.buf.rename, "Rename symbol")
				map("n", "K", vim.lsp.buf.hover, "Show hover info")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Show code actions")
				map("n", "gl", vim.diagnostic.open_float, "Show line diagnostics")
				map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
			end

			local function make_on_attach(existing)
				return function(client, bufnr)
					if existing then
						existing(client, bufnr)
					end
					lsp_keymaps(bufnr)
				end
			end

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
				local server_opts = vim.deepcopy(opts)
				server_opts.capabilities =
					vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
				server_opts.on_attach = make_on_attach(server_opts.on_attach)
				vim.lsp.config(server, server_opts)
			end

			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
