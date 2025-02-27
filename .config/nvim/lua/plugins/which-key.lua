return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- 自動トリガーを無効化するための設定
      triggers = {}, -- 空の配列を指定して自動トリガーをオフにする

      -- その他のデフォルト設定はそのまま使用
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
      -- 必要に応じて、グローバルキーマップを表示するための設定も追加できます
      --{
      --  "<leader>wk",
      --  function()
      --    require("which-key").show({ mode = "n" }) -- ノーマルモードのすべてのキーマップを表示
      --  end,
      --  desc = "Show All Keymaps (which-key)",
      --},
    },
  },
}
