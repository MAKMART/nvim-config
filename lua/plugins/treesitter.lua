return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    lazy = true,
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash", "css", "html", "javascript",
                "json", "lua", "markdown", "python",
                -- 👇 Notice C/C++ are intentionally omitted
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = { "c", "cpp" },  -- 👈 Disable Treesitter highlighting for C/C++
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}
