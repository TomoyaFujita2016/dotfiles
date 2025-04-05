return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- ts_context_commentstringの設定
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          typescript = "// %s",
          tsx = {
            __default = "// %s",
            jsx_element = "{/* %s */}",
            jsx_fragment = "{/* %s */}",
            jsx_attribute = "// %s",
            comment = "// %s",
          },
          javascript = "// %s",
          jsx = {
            __default = "// %s",
            jsx_element = "{/* %s */}",
            jsx_fragment = "{/* %s */}",
            jsx_attribute = "// %s",
            comment = "// %s",
          },
        },
      })

      require("Comment").setup({
        -- コメントの前後に空白を追加
        padding = true,
        -- コメントの位置を揃える
        sticky = true,
        -- 現在の行をコメントアウトするマッピング
        toggler = {
          line = "gcc", -- 行コメント
          block = "gbc", -- ブロックコメント
        },
        -- テキストオブジェクト用マッピング
        opleader = {
          line = "gc", -- 行コメント
          block = "gb", -- ブロックコメント
        },
        -- JSX/TSXのコメント対応を有効化
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- JSX/TSXコメントのためのTreesitterコンテキスト
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
}
