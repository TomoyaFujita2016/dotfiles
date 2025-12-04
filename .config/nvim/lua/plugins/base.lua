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
      -- tmux内ではtmux用エスケープが必要
      vim.g.oscyank_term = "tmux"
      vim.g.oscyank_max_length = 0

      -- 通常のヤンク操作と自動連動
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("OSCYankPost", { clear = true }),
        callback = function()
          if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
            vim.fn.OSCYankRegister('')
          end
        end,
      })
    end,
  },
}
