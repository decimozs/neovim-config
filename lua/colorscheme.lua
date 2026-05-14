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

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "none", nocombine = true })
		vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "none", bg = "none", nocombine = true })
		vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none", fg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none", fg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none", fg = "none" })
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = "none", bg = "none" })
	end,
})

vim.cmd.colorscheme("vesper")
