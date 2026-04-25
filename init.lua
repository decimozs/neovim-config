require("options")
require("keymaps")

vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "none", bg = "none" })

vim.pack.add({
	{ src = "https://github.com/datsfilipe/vesper.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
	},
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
	},
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
	},
	{
		src = "https://github.com/nvimdev/lspsaga.nvim",
	},
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons",
	},
	{
		src = "https://github.com/mfussenegger/nvim-lint",
	},
	{
		src = "https://github.com/stevearc/conform.nvim",
	},
	{
		src = "https://github.com/nvim-lualine/lualine.nvim",
	},
	{
		src = "https://github.com/nvim-tree/nvim-tree.lua",
	},
	{
		src = "https://github.com/windwp/nvim-autopairs",
	},
	{
		src = "https://github.com/norcalli/nvim-colorizer.lua",
	},
	{
		src = "https://github.com/kylechui/nvim-surround",
		version = vim.version.range("4.x"),
	},
	{
		src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
	},
	{
		src = "https://github.com/folke/flash.nvim",
	},
	{
		src = "https://github.com/L3MON4D3/LuaSnip",
	},
	{
		src = "https://github.com/j-hui/fidget.nvim",
	},
	{
		src = "https://github.com/nickjvandyke/opencode.nvim",
	},
})

require("colorscheme")

local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"vim",
		"vimdoc",
		"rust",
		"c",
		"cpp",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"typescript",
		"astro",
		"bash",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

require("gitsigns").setup({
	signs = {
		add = { text = "\u{2590}" },
		change = { text = "\u{2590}" },
		delete = { text = "\u{2590}" },
		topdelete = { text = "\u{25e6}" },
		changedelete = { text = "\u{25cf}" },
		untracked = { text = "\u{25cb}" },
	},
	signcolumn = true,
	current_line_blame = false,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

require("mason").setup({
	install_root_dir = "C:\\dev\\nvim\\mason",
})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "tailwindcss", "emmet_ls", "pyright", "eslint", "clangd" },
})
require("mason-tool-installer").setup({
	ensure_installed = { "stylua", "ruff", "eslint_d", "biome" },
})

require("lspsaga").setup({
	symbol_in_winbar = {
		enable = false,
	},
	ui = {
		code_action = "",
	},
})

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap

	opts.desc = "Show LSP references"
	keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

	opts.desc = "Go to declaration"
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Show LSP definition"
	keymap.set("n", "gd", vim.lsp.buf.definition, opts)

	opts.desc = "Show LSP implementations"
	keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

	opts.desc = "Show LSP type definitions"
	keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	opts.desc = "See available code actions"
	keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "Smart rename"
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	opts.desc = "Show buffer diagnostics"
	keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

	opts.desc = "Show line diagnostics"
	keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

	opts.desc = "Go to previous diagnostic"
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>")

	opts.desc = "Go to next diagnostic"
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>")

	opts.desc = "Show documentation for what is under cursor"
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>")

	opts.desc = "Restart LSP"
	keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},

	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"clangd",
})

require("telescope").setup({
	defaults = {
		prompt_prefix = "   ",
		selection_caret = "    ",
		entry_prefix = "   ",
		path_display = { "truncate" },
		vimgrep_arguments = {
			"rg",
			"--follow",
			"--hidden",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--glob=!**/.git/*",
			"--glob=!**/.idea/*",
			"--glob=!**/.vscode/*",
			"--glob=!**/build/*",
			"--glob=!**/dist/*",
			"--glob=!**/yarn.lock",
			"--glob=!**/package-lock.json",
			"--ignore-file",
			".gitignore",
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = {
				"rg",
				"--files",
				"--hidden",
				"--glob=!**/.git/*",
				"--glob=!**/.idea/*",
				"--glob=!**/.vscode/*",
				"--glob=!**/build/*",
				"--glob=!**/dist/*",
				"--glob=!**/yarn.lock",
				"--glob=!**/package-lock.json",
			},
		},
	},
})

require("lint").linters_by_ft = {
	javascript = { "eslint_d", "biomejs" },
	typescript = { "eslint_d", "biomejs" },
	javascriptreact = { "eslint_d", "biomejs" },
	typescriptreact = { "eslint_d", "biomejs" },
	astro = { "eslint_d", "biomejs" },
	python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("conform").setup({
	formatters_by_ft = {
		astro = { "biomejs" },
		javascript = { "biomejs" },
		typescript = { "biomejs" },
		javascriptreact = { "biomejs" },
		typescriptreact = { "biomejs" },
		css = { "biomejs" },
		html = { "biomejs" },
		json = { "biomejs" },
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format" },
	},
	format_on_save = {
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	},
})

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (visual)" })

local modes = {
	["n"] = "N",
	["no"] = "N",
	["v"] = "V",
	["V"] = "V",
	[""] = "V",
	["s"] = "S",
	["S"] = "S",
	[""] = "S",
	["i"] = "I",
	["ic"] = "I",
	["R"] = "R",
	["Rv"] = "R",
	["c"] = "C",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "P",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "T",
}

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode]):upper()
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			"NvimTree",
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = {
			{
				mode,
			},
		},
		lualine_b = {
			{
				"branch",
			},
		},
		lualine_c = { "filetype", "filename" },
		lualine_x = {},
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	inactive_winbar = {},
	extensions = {
		"nvim-tree",
		"oil",
		"mason",
		"fzf",
	},
})

require("nvim-tree").setup({
	renderer = {
		root_folder_label = false,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	view = {
		centralize_selection = false,
		cursorline = true,
		debounce_delay = 15,
		side = "right",
		preserve_window_proportions = false,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
		width = 50,
		float = {
			enable = false,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			},
		},
	},
	filters = {
		dotfiles = true,
	},
})

require("nvim-autopairs").setup({})
require("colorizer").setup({})
require("nvim-web-devicons").setup({
	strict = true,
	override_by_extension = {
		astro = {
			icon = "",
			color = "#EF8547",
			name = "astro",
		},
	},
})
require("nvim-surround").setup({})
require("render-markdown").setup({
	completions = { blink = { enabled = true }, lsp = { enabled = true } },
})
require("flash").setup({
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
})

require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})

vim.keymap.set({ "n", "x" }, "<C-a>", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "t" }, "<leader>oc", function()
	require("opencode").toggle()
end, { desc = "Toggle opencode" })
