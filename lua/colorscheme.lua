require("vesper").setup({
	transparent = false,
	italics = {
		comments = true,
		keywords = false,
		functions = true,
		strings = true,
		variables = false,
	},
	overrides = {},
	palette_overrides = {},
})
vim.cmd.colorscheme("vesper")
