return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- Keep lazy-loading on command
    keys = {
        { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Search git files" },
        { "<leader>pf", function() require("telescope.builtin").find_files({ cwd = "" }) end, desc = "Find files in directory" },
        { "<leader>ps", function() require("telescope.builtin").live_grep({ cwd = "" }) end, desc = "Grep in files in directory" },
    },
    dependencies = {
        { "nvim-lua/plenary.nvim", event = "VeryLazy" }, -- Defer plenary loading
        {
		--Make sure to have fzy installed on you system (it should since it's part of C libs)
            "nvim-telescope/telescope-fzy-native.nvim",
            build = "make",
            -- Load extension only when Telescope is used
            config = function()
                vim.defer_fn(function() require("telescope").load_extension("fzy_native") end, 50)
            end,
        },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                layout_config = {
                    horizontal = { preview_width = 0.5 },
                },
                file_ignore_patterns = { "node_modules", "%.git/" },
                -- Optimize performance
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden", -- Include hidden files, optional
                    "--glob=!.git/", -- Exclude .git
                },
            },
            extensions = {
                fzy_native = {
                    override_generic_sorter = true,
                    override_file_sorter = true,
                },
            },
        })
    end,
}
