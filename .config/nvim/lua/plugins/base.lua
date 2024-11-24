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
}
