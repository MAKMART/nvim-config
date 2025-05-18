return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" }, -- 👈 Load only when used
  build = ":MasonUpdate", -- auto-update registry
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
      },
    })
  end,
}
