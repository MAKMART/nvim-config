return {
    "mbbill/undotree",
    keys = {
        {
            "<leader>u",
            function()
                -- This triggers plugin load automatically, then calls the toggle
                vim.cmd.UndotreeToggle()
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle UndoTree",
        },
    },
    -- No eager config function! We let the lazy-loader handle it
}
