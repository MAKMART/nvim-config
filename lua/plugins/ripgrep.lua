return {
  "iruzo/ripgrep.nvim",
  version = "*",
  cmd = { "Rg", "RgSearch", "RgLiveGrep" }, -- Load only when the user actually searches
  build = function()
    -- Safeguard: Only install if not already available
    local rg = vim.fn.executable("rg") == 1
    if not rg then
      require("rg_setup").install_rg()
    end
  end,
}

