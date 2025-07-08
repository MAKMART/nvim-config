return {
  dir = ".",  -- any dummy value that disables GitHub fetching
  name = "cmake-runner",  -- the name Lazy will refer to it by
  lazy = true,
  keys = {
    {
      "<leader>db",
      function()
        require("utils.cmake_runner").run_build_and_exec("Debug")
      end,
      desc = "Build & Run (Debug)",
    },
    {
      "<leader>rb",
      function()
        require("utils.cmake_runner").run_build_and_exec("Release")
      end,
      desc = "Build & Run (Release)",
    },
    {
      "<leader>r",
      function()
        require("utils.cmake_runner").run_only("Debug")
      end,
      desc = "Run Debug",
    },
    {
      "<leader>R",
      function()
        require("utils.cmake_runner").run_only("Release")
      end,
      desc = "Run Release",
    },
  },
  config = false, -- no plugin config needed
}
