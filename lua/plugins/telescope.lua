return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
	local builtin = require("telescope.builtin")

	vim.keymap.set("n", "<C-p>", builtin.git_files, {})

	vim.keymap.set("n", "<leader>pf", function()
	    builtin.find_files({ cwd = "" })
	end, { desc = "Find files in directory" })

	vim.keymap.set("n", "<leader>ps", function()
	    builtin.live_grep({ cwd = "" })
	end, { desc = "Grep in files in directory" })
    end,
}
