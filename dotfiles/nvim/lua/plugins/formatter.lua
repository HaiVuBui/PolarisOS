return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			nix = { "nixfmt" },
			sh = { "shfmt" },
			haskell = { "ormolu" },
			latex = { "latexindent" },
			go = { "gofumpt" },
			rust = { "rustfmt" },
		},
		format_on_save = false,
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format file/range",
		},
		{
			"<leader>cF",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				local state = vim.g.disable_autoformat and "disabled" or "enabled"
				vim.notify("Format-on-save globally " .. state, vim.log.levels.INFO)
			end,
			desc = "Toggle format-on-save (global)",
		},
	},
}
