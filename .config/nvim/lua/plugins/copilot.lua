return {
  {
    "github/copilot.vim",
    priority = 2000,
    event = "InsertEnter",
    config = function()
      local utils = require("utils")
      vim.g.copilot_no_tab_map = true
      utils.map("i", "<M-j>", "<Plug>(copilot-next)")
      utils.map("i", "<M-k>", "<Plug>(copilot-previous)")
      utils.map("i", "<M-o>", "<Plug>(copilot-dismiss)")
      utils.map("i", "<M-s>", "<Plug>(copilot-suggest)")
      vim.api.nvim_set_keymap("i", "<C-g>", "copilot#Accept()", { silent = true, expr = true })
    end,
  },
}
