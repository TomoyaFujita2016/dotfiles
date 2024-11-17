return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
      save_empty = false,
    },
    config = function(_, opts)
      require("persistence").setup(opts)
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)
    end,
  },
}
