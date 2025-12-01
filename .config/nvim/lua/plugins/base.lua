-- ファイル訳めんどいやつがここにおる
return {
  -- Emmet
  -- { "mattn/emmet-vim", ft = { "html", "css", "javascript", "typescript", "vue" } },
  --{ "sheerun/vim-polyglot", event = { "BufReadPre", "BufNewFile" } },

  -- vim-polyglot
  {
    "sheerun/vim-polyglot",
    event = { "BufReadPre", "BufNewFile" },
  },
  -- UI改善
  {
    "kkharji/lspsaga.nvim",
    event = "LspAttach",
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  -- LSP進捗表示
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
  },
  -- OSC52クリップボード連携
  {
    "ojroques/vim-oscyank",
    event = "VeryLazy",
    config = function()
      vim.g.oscyank_silent = false
      vim.g.oscyank_term = "default"
      vim.g.oscyank_max_length = 0

      -- ビジュアルモードでのヤンク時にOSC52を使用
      vim.keymap.set('v', '<leader>y', ':OSCYank<CR>', { silent = true, desc = 'OSC52でヤンク' })
      vim.keymap.set('n', '<leader>y', '<Plug>OSCYankOperator', { silent = true, desc = 'OSC52でヤンク' })
      vim.keymap.set('n', '<leader>yy', '<leader>y_', { silent = true, remap = true, desc = 'OSC52で行ヤンク' })
    end,
  },
}
