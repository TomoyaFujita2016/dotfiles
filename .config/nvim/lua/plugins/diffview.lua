return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true, -- ハイライトの強化
      view = {
        default = {
          layout = "diff2_horizontal", -- デフォルトレイアウト
        },
        merge_tool = {
          layout = "diff3_horizontal", -- マージツールのレイアウト
          disable_diagnostics = true,
        },
      },
      keymaps = {
        view = {
          ["q"] = "<cmd>DiffviewClose<CR>", -- diffviewを閉じる
        },
      },
    })
  end,
  lazy = false,
  keys = {
    { mode = "n", "<leader>hh", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "1つ前とのdiff" },
    { mode = "n", "<leader>hf", "<cmd>DiffviewFileHistory %<CR>", desc = "ファイルの変更履歴" },
    { mode = "n", "<leader>hc", "<cmd>DiffviewClose<CR>", desc = "diffの画面閉じる" },
  },
}
