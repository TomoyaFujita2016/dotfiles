return {
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 40, -- 最小の高さ
      },
    },
    keys = {
      { "<space>r", "<CMD>OverseerRun<CR>" },
      { "<space>R", "<CMD>OverseerToggle<CR>" },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
    end,
  },
}
