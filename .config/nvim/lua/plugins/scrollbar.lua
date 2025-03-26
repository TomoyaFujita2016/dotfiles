return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("scrollbar").setup({
      -- カスタム設定をここに追加
      show = true,
      handle = {
        text = " ",
        color = "#5e5f65",
        hide_if_all_visible = true,
      },
      marks = {
        Search = { color = "#f7bb3b" },
        Error = { color = "#e82424" },
        Warn = { color = "#ff9e64" },
        Info = { color = "#658594" },
        Hint = { color = "#56bdb8" },
        Misc = { color = "#8077d1" },
      },
    })
    require("scrollbar").setup()
    require("scrollbar.handlers.gitsigns").setup() -- GitSignsとの連携を有効化
  end,
  dependencies = {
    "lewis6991/gitsigns.nvim", -- オプション: GitSignsと連携する場合
  },
}
