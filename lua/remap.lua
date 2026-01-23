local M = {}

vim.g.mapleader = " " -- leader key must be set before Lazy.nvim loading!

local function remove_keymap(mode, key)
	local maps = vim.api.nvim_get_keymap(mode)
	for _, m in ipairs(maps) do
		if m.lhs == key then
			vim.keymap.del(mode, key)
			return
		end
	end
end

function M.setup()

	local map = vim.keymap.set
	local opts = { noremap = true, silent = true }

	-- Disable arrow keys
	for _, key in ipairs({'Up','Down','Left','Right'}) do
		map('', '<'..key..'>', '<Cmd>echo "Use hjkl!"<CR>', opts)
	end

	-- ======================
	-- Global keymaps
	-- ======================

	map('n', '<leader>pv', ':Explore<CR>', opts)
	map('n', '<leader>pf', ':Telescope find_files<CR>', opts)
	map('n', '<leader>t', ':tabnew<CR>', opts)
	map('n', '<Tab>', ':bnext<CR>', opts)
	map('n', '<S-Tab>', ':bprev<CR>', opts)
	map('n', '<leader>bd', ':bdelete<CR>', opts)
	--map("n", "<C-d>", "<C-d>zz", opts);
	--map("n", "<C-u>", "<C-u>zz", opts);

	--Runner mappings
	map('n', '<leader>db', function() require("utils.project_runner").build("debug") end)
	map('n', '<leader>rb', function() require("utils.project_runner").build("release") end)
	map('n', '<leader>r',  function() require("utils.project_runner").run("debug") end)
	map('n', '<leader>R',  function() require("utils.project_runner").run("release") end)

	--Window navigation
	map('n', '<Leader>h', '<C-w>h', { desc = 'Move to left split' })
	map('n', '<Leader>j', '<C-w>j', { desc = 'Move to down split' })
	map('n', '<Leader>k', '<C-w>k', { desc = 'Move to up split' })
	map('n', '<Leader>l', '<C-w>l', { desc = 'Move to right split' })
	map('n', '<Leader>w', '<C-w>w', { desc = 'Cycle through splits' })

	--Buffer commands
	map('n', '<leader>bn', function() vim.cmd('enew') end, { desc = 'Open new buffer' })

	--LSP formatting / actions
	map('n', '<leader>cf', function() vim.lsp.buf.format() end, { desc = 'LSP: Format Code' })
	map('n', '<leader>ct', function() vim.lsp.buf.code_action({ context = { diagnostics = {} } }) end, { desc = "Run clang-tidy via LSP" })

	--Telescope
	map("n", "<C-p>", function() require("telescope.builtin").git_files() end, vim.tbl_extend("force", opts, { desc = "Search git files" }))
	map("n", "<leader>pf", function() require("telescope.builtin").find_files({ cwd = "" }) end, vim.tbl_extend("force", opts, { desc = "Find files in directory" }))
	map("n", "<leader>ps", function() require("telescope.builtin").live_grep({ cwd = "" }) end, vim.tbl_extend("force", opts, { desc = "Grep in files in directory" }))


	-- ======================
	-- LSP keymaps (buffer-local)
	-- ======================
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local lopts = { buffer = ev.buf, silent = true }
			local lsp_maps = {
				{ "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
				{ "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
				{ "n", "gd", vim.lsp.buf.definition, "Show LSP definition" },
				{ "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
				{ "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
				{ {"n","v"}, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
				{ "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
				{ "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
				{ "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
				{ "n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Go to previous diagnostic" },
				{ "n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Go to next diagnostic" },
				{ "n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor" },
				{ "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
			}

			for _, m in ipairs(lsp_maps) do
				map(m[1], m[2], m[3], vim.tbl_extend("force", lopts, { desc = m[4] }))
			end
		end,
	})


	-- vim.lsp.inlay_hint.enable(true)

	--[[
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
	})]]




end

function M.cmp_mappings(cmp, luasnip)
	local map = cmp.mapping
	local select_opts = { behavior = cmp.SelectBehavior.Select }

	return {
		["<C-k>"] = map.select_prev_item(select_opts),
		["<C-j>"] = map.select_next_item(select_opts),
		["<C-b>"] = map.scroll_docs(-4),
		["<C-f>"] = map.scroll_docs(4),
		["<C-Space>"] = map.complete(),
		["<C-e>"] = map.abort(),
		["<CR>"] = map.confirm({ select = false }),
		["<Tab>"] = map(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = map(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}
end

return M
